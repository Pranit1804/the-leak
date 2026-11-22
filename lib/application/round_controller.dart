import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/engine/caption_picker.dart';
import '../domain/engine/round_machine.dart';
import '../domain/engine/scorer.dart';
import '../domain/models/caption.dart';
import '../domain/models/player.dart';
import '../domain/models/round.dart';
import '../domain/models/round_phase.dart';
import '../domain/models/trip.dart';
import '../domain/models/vote.dart';
import '../domain/models/word.dart';
import 'providers.dart';
import 'telemetry.dart';
import 'trip_controller.dart';

/// Everything a round screen needs.
class RoundView {
  const RoundView({
    required this.round,
    required this.trip,
    required this.players,
    required this.word,
    required this.votes,
    this.caption,
    this.points = const {},
  });

  final Round round;
  final Trip trip;

  /// Every player of the trip by id.
  final Map<int, Player> players;
  final Word word;
  final List<Vote> votes;
  final Caption? caption;

  /// Points per participant, filled in at the reveal.
  final Map<int, int> points;

  List<int> get handoutOrder => handoutOrderOf(round);
  int get questionLimit => trip.questionLimit;
  String name(int? id) => players[id]?.name ?? '';

  /// The player holding the phone in handout or voting.
  int? get currentHandoutPlayer => round.handoutIndex < handoutOrder.length ? handoutOrder[round.handoutIndex] : null;

  RoundView copyWith({Round? round, List<Vote>? votes, Caption? caption, Map<int, int>? points}) => RoundView(
        round: round ?? this.round,
        trip: trip,
        players: players,
        word: word,
        votes: votes ?? this.votes,
        caption: caption ?? this.caption,
        points: points ?? this.points,
      );
}

/// Drives one round through the state machine (TECH_SPEC section 6).
///
/// Every action is queued so taps are handled in order, and each new state is
/// written to the database before the UI state changes.
class RoundController extends AsyncNotifier<RoundView> {
  RoundController(this.roundId);

  final int roundId;
  Future<void> _queue = Future.value();

  /// Hooks for side effects (announcements, haptics); see [RoundEvents].
  RoundEvents get _events => ref.read(roundEventsProvider);
  Telemetry get _telemetry => ref.read(telemetryProvider);

  @override
  Future<RoundView> build() => _load();

  Future<RoundView> _load() async {
    final rounds = ref.read(roundRepositoryProvider);
    final round = await rounds.getRound(roundId);
    if (round == null) throw StateError('Round $roundId not found');
    final trip = (await ref.read(tripRepositoryProvider).getTrip(round.tripId))!;
    final players = await ref.read(tripRepositoryProvider).players(round.tripId);
    final word = await ref.read(deckRepositoryProvider).byId(round.wordId);
    if (word == null) throw StateError('Word ${round.wordId} missing from the deck');
    final caption = round.captionId == null ? null : await ref.read(captionRepositoryProvider).byId(round.captionId!);
    final scores = round.phase == RoundPhase.reveal || round.phase == RoundPhase.done
        ? (await rounds.records(round.tripId)).firstWhere((r) => r.round.id == roundId).points
        : const <int, int>{};
    return RoundView(
      round: round,
      trip: trip,
      players: {for (final p in players) p.id: p},
      word: word,
      votes: await rounds.votes(roundId),
      caption: caption,
      points: scores,
    );
  }

  RoundView get _view => state.requireValue;

  /// Runs [action] after any earlier ones finish.
  Future<void> _run(Future<void> Function(RoundView v) action) {
    final next = _queue.then((_) async {
      if (!state.hasValue) return;
      await action(_view);
    });
    _queue = next.catchError((Object _) {});
    return next;
  }

  /// Persist, then publish.
  Future<void> _commit(Round next, {Future<void> Function()? write, List<Vote>? votes}) async {
    await (write ?? () => ref.read(roundRepositoryProvider).save(next))();
    state = AsyncData(_view.copyWith(round: next, votes: votes));
    _telemetry.setRoundPhase(next.phase.name);
  }

  DateTime get _now => ref.read(clockProvider)();

  Future<void> handoutDone() => _run((v) async {
        final next = RoundMachine.handoutDone(v.round);
        await _commit(next);
        if (next.phase == RoundPhase.questioning) unawaited(_events.roundStarted(_view));
      });

  Future<void> increment() => _run((v) async {
        final next = RoundMachine.increment(v.round, v.questionLimit);
        if (identical(next, v.round)) return;
        await _commit(next);
        _events.questionAsked(_view);
      });

  Future<void> undo() => _run((v) async {
        final next = RoundMachine.undo(v.round);
        if (identical(next, v.round)) return;
        await _commit(next);
      });

  Future<void> wordGuessed() => _run((v) async => _commit(RoundMachine.wordGuessed(v.round)));

  Future<void> backToQuestioning() => _run((v) async => _commit(RoundMachine.backToQuestioning(v.round)));

  Future<void> pickGuesser(int playerId) => _run((v) async {
        final next = RoundMachine.guesserPicked(v.round, playerId, discussionSeconds: v.trip.discussionSeconds, now: _now);
        await _commit(next);
        unawaited(_events.wordGuessed(_view));
      });

  Future<void> endDiscussion() => _run((v) async {
        if (v.round.phase != RoundPhase.discussion) return;
        await _commit(RoundMachine.discussionEnded(v.round));
        unawaited(_events.voteStarted(_view));
      });

  /// The group agreed on one name and the Master tapped it: save it as the
  /// round's single vote (voter = the Master) and go straight to the reveal.
  Future<void> voteOut(int targetId) => _run((v) async {
        if (v.round.phase != RoundPhase.voting) return;
        if (!voteCandidates(v.round).contains(targetId)) throw ArgumentError('Not a candidate');
        final vote = Vote(voterId: v.round.masterId, targetId: targetId);
        await _reveal(RoundMachine.voteLocked(v.round), [vote], lastVote: vote);
      });

  Future<void> notGuessed() => _run((v) async => _reveal(RoundMachine.notGuessed(v.round), v.votes));

  Future<void> _reveal(Round next, List<Vote> votes, {Vote? lastVote}) async {
    final score = scoreRound(next, votes);
    final rounds = ref.read(roundRepositoryProvider);
    final pick = pickCaption(
      pool: await ref.read(captionRepositoryProvider).load(),
      outcome: score.outcome,
      usedIds: await rounds.usedCaptionIds(next.tripId),
      rng: ref.read(rngProvider),
    );
    final revealed = next.copyWith(outcome: score.outcome, captionId: pick?.caption.id, endedAt: _now);
    await rounds.saveReveal(revealed, score.points, lastVote: lastVote, clearUsedCaptionIds: pick?.clearedIds ?? const {});
    _telemetry.setRoundPhase(revealed.phase.name);
    _telemetry.roundEnded(
      outcome: score.outcome.db,
      questionsUsed: revealed.questionsUsed,
      questionLimit: _view.questionLimit,
      carMode: revealed.carMode,
    );
    state = AsyncData(_view.copyWith(round: revealed, votes: votes, caption: pick?.caption, points: score.points));
    unawaited(_events.revealed(_view));
  }

  /// "Continued in round n+1": closes the round.
  Future<void> nextRound() => _run((v) async => _commit(RoundMachine.close(v.round, _now)));

  /// Closes the round and ends the trip.
  Future<void> endTrip() => _run((v) async {
        await _commit(RoundMachine.close(v.round, _now));
        await ref.read(tripRepositoryProvider).endTrip(v.trip.id, now: _now);
        final records = await ref.read(roundRepositoryProvider).records(v.trip.id);
        _telemetry.tripEnded(rounds: records.where((r) => r.round.outcome?.scored ?? false).length);
      });

  /// A confirmed back-out: outcome `abandoned`, nothing scored.
  Future<void> abandon() => _run((v) async {
        _telemetry.roundAbandoned(phase: v.round.phase.name);
        final next = RoundMachine.abandon(v.round, _now);
        await _commit(next, write: () => ref.read(roundRepositoryProvider).abandon(next));
      });
}

final roundControllerProvider =
    AsyncNotifierProvider.autoDispose.family<RoundController, RoundView, int>(RoundController.new);

/// Side effects of round transitions. The default does nothing; the app
/// overrides it with the announcer (and tests with a recorder).
class RoundEvents {
  const RoundEvents();
  Future<void> roundStarted(RoundView v) async {}
  void questionAsked(RoundView v) {}
  Future<void> wordGuessed(RoundView v) async {}
  Future<void> voteStarted(RoundView v) async {}
  void discussionEnding(RoundView v) {}
  Future<void> revealed(RoundView v) async {}
}

final roundEventsProvider = Provider<RoundEvents>((ref) => const RoundEvents());
