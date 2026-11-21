import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../application/providers.dart';
import '../application/round_controller.dart';
import '../application/settings_controller.dart';
import '../domain/engine/stats_calculator.dart';
import '../domain/models/outcome.dart';
import '../domain/models/round_phase.dart';
import 'announcer_lines.dart';

/// The text-to-speech engine, abstracted so tests can record lines.
abstract class TtsEngine {
  /// Speaks [text] and completes when it has finished.
  Future<void> speak(String text);
  Future<void> stop();
}

/// flutter_tts: `en-IN`, falling back to `en-GB` then `en-US`, waiting for
/// each line to finish. On Android it uses navigation audio so car head
/// units play it over Bluetooth.
class FlutterTtsEngine implements TtsEngine {
  final FlutterTts _tts = FlutterTts();
  Future<void>? _ready;

  /// The language in use once initialised.
  String? language;

  Future<void> _init() async {
    await _tts.awaitSpeakCompletion(true);
    for (final lang in const ['en-IN', 'en-GB', 'en-US']) {
      final ok = await _tts.isLanguageAvailable(lang);
      if (ok == true || ok == 1) {
        await _tts.setLanguage(lang);
        language = lang;
        break;
      }
    }
    if (Platform.isAndroid) {
      await _tts.setAudioAttributesForNavigation();
    } else if (Platform.isIOS) {
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
        IosTextToSpeechAudioCategoryOptions.duckOthers,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      ]);
    }
    await _tts.setSpeechRate(0.5);
  }

  @override
  Future<void> speak(String text) async {
    _ready ??= _init();
    await _ready;
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}

/// Speaks announcements one at a time, in order, respecting mute.
class Announcer {
  Announcer(this._engine, {required this.isMuted});

  final TtsEngine _engine;
  /// Read before every line, so muting takes effect at once.
  final bool Function() isMuted;
  Future<void> _chain = Future.value();
  int _generation = 0;

  /// Queues [line]. [force] ignores mute (the Settings test voice).
  Future<void> say(String line, {bool force = false}) {
    if (!force && isMuted()) return Future.value();
    final gen = _generation;
    final next = _chain.then((_) async {
      if (gen != _generation || (!force && isMuted())) return;
      try {
        await _engine.speak(line);
      } catch (_) {
        // No voice available: the game carries on silently.
      }
    });
    _chain = next;
    return next;
  }

  /// Reserves a place in the queue now for lines that are still being worked
  /// out, so later announcements can't jump ahead of them.
  Future<void> sayLater(Future<List<String>> lines) {
    final gen = _generation;
    final next = _chain.then((_) async {
      List<String> resolved;
      try {
        resolved = await lines;
      } catch (_) {
        return;
      }
      for (final line in resolved) {
        if (gen != _generation || isMuted()) return;
        try {
          await _engine.speak(line);
        } catch (_) {}
      }
    });
    _chain = next;
    return next;
  }

  /// Completes when everything queued so far has been spoken.
  Future<void> get idle => _chain;

  /// Drops anything queued and stops the current line (on mute).
  Future<void> stopAll() async {
    _generation++;
    try {
      await _engine.stop();
    } catch (_) {}
  }

  Future<void> roundStarted(int number, String master) => say(AnnouncerLines.roundStarted(number, master));
  Future<void> questionsLeft(int n) => say(AnnouncerLines.questionsLeft(n));
  Future<void> wordGuessed(String name, int discussionSeconds) => say(AnnouncerLines.wordGuessed(name, discussionSeconds));
  Future<void> discussionEnding() => say(AnnouncerLines.discussionEnding);
  Future<void> voteStarted({required bool carMode}) => say(AnnouncerLines.voteStarted(carMode: carMode));
  Future<void> dailyStandings(String line) => say(line);

  Future<void> reveal(Outcome outcome, {required String insider, required String word, required bool outOfQuestions}) => say(switch (outcome) {
        Outcome.caught => AnnouncerLines.revealCaught(insider, word),
        Outcome.notCaught => AnnouncerLines.revealNotCaught(insider, word),
        Outcome.notFound || Outcome.abandoned => AnnouncerLines.revealNotFound(insider, word, outOfQuestions: outOfQuestions),
      });
}

final ttsEngineProvider = Provider<TtsEngine>((ref) => FlutterTtsEngine());

final announcerProvider = Provider<Announcer>(
  (ref) => Announcer(ref.watch(ttsEngineProvider), isMuted: () => ref.read(settingsControllerProvider).muted),
);

/// Turns round transitions into announcements.
class AnnouncerEvents extends RoundEvents {
  AnnouncerEvents(this.ref);

  final Ref ref;

  /// Milestones already spoken, per round, so Undo then +1 doesn't repeat them.
  final Map<int, Set<int>> _spoken = {};

  Announcer get _a => ref.read(announcerProvider);

  @override
  Future<void> roundStarted(RoundView v) => _a.sayLater(() async {
        final daily = await _dailyLine(v);
        return [?daily, AnnouncerLines.roundStarted(v.round.number, v.name(v.round.masterId))];
      }());

  /// "Day N. …" on the first round of a new day (Day 2 on).
  Future<String?> _dailyLine(RoundView v) async {
    final records = (await ref.read(roundRepositoryProvider).records(v.trip.id))
        .where((r) => r.round.id != v.round.id && r.round.outcome != null && r.round.outcome!.scored)
        .toList();
    final starts = records.map((r) => r.round.startedAt).toList();
    if (!isFirstRoundOfNewDay(starts, v.round.startedAt)) return null;
    final stats = computeStats(v.players.values.toList(), records);
    final leaders = stats.standings.where((r) => r.position == 1).toList();
    final secondPos = stats.standings.where((r) => r.position > 1).map((r) => r.position).fold<int?>(null, (a, b) => a ?? b);
    final seconds = stats.standings.where((r) => secondPos != null && r.position == secondPos).toList();
    return AnnouncerLines.dailyStandings(
      dayNumber(starts) + 1,
      leaders: leaders.map((r) => r.stats.player.name).toList(),
      leaderPoints: leaders.isEmpty ? 0 : leaders.first.stats.points,
      seconds: seconds.map((r) => r.stats.player.name).toList(),
      secondPoints: seconds.isEmpty ? 0 : seconds.first.stats.points,
    );
  }

  @override
  void questionAsked(RoundView v) {
    if (!v.trip.alertsOn) return;
    final left = v.questionLimit - v.round.questionsUsed;
    if (!const {10, 5, 1}.contains(left) || left >= v.questionLimit) return;
    if (!(_spoken[v.round.id] ??= {}).add(left)) return;
    unawaited(_a.questionsLeft(left));
  }

  @override
  Future<void> wordGuessed(RoundView v) async {
    unawaited(_a.wordGuessed(v.name(v.round.guessedById), v.trip.discussionSeconds));
    if (v.round.phase == RoundPhase.voting) await voteStarted(v);
  }

  @override
  void discussionEnding(RoundView v) => unawaited(_a.discussionEnding());

  @override
  Future<void> voteStarted(RoundView v) => _a.voteStarted(carMode: v.round.carMode);

  @override
  Future<void> revealed(RoundView v) => _a.reveal(
        v.round.outcome ?? Outcome.notFound,
        insider: v.name(v.round.insiderId),
        word: v.word.word,
        outOfQuestions: v.round.questionsUsed >= v.questionLimit,
      );
}
