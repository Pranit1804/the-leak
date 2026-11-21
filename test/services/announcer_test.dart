import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/application/providers.dart';
import 'package:the_leak/application/round_controller.dart';
import 'package:the_leak/application/settings_controller.dart';
import 'package:the_leak/application/trip_controller.dart';
import 'package:the_leak/domain/engine/round_machine.dart';
import 'package:the_leak/domain/models/difficulty.dart';
import 'package:the_leak/domain/models/outcome.dart';
import 'package:the_leak/services/announcer.dart';
import 'package:the_leak/services/announcer_lines.dart';

import '../support/harness.dart';

class FakeTts implements TtsEngine {
  final lines = <String>[];
  int _speaking = 0;
  int maxConcurrent = 0;
  Duration delay = Duration.zero;

  @override
  Future<void> speak(String text) async {
    _speaking++;
    if (_speaking > maxConcurrent) maxConcurrent = _speaking;
    await Future<void>.delayed(delay);
    lines.add(text);
    _speaking--;
  }

  @override
  Future<void> stop() async {}
}

void main() {
  group('lines (PRD section 4)', () {
    test('match the PRD examples', () {
      expect(AnnouncerLines.roundStarted(4, 'Priya'), 'Round 4. Priya is the Master. Start asking.');
      expect(AnnouncerLines.questionsLeft(10), 'Ten questions left.');
      expect(AnnouncerLines.questionsLeft(5), 'Five questions left.');
      expect(AnnouncerLines.questionsLeft(1), 'Last question.');
      expect(AnnouncerLines.wordGuessed('Rohan', 120), 'Word guessed by Rohan! Two minutes to find the leak.');
      expect(AnnouncerLines.wordGuessed('Rohan', 60), 'Word guessed by Rohan! One minute to find the leak.');
      expect(AnnouncerLines.wordGuessed('Rohan', 0), 'Word guessed by Rohan!');
      expect(AnnouncerLines.discussionEnding, 'Thirty seconds.');
      expect(AnnouncerLines.voteStarted(carMode: false), 'Time to vote.');
      expect(AnnouncerLines.voteStarted(carMode: true), 'Time to vote. Driver, say your vote out loud.');
      expect(AnnouncerLines.revealCaught('Amit', 'X'), 'The leak was Amit. Caught! The word was X.');
      expect(AnnouncerLines.revealNotCaught('Amit', 'X'), 'The leak was Amit, and nobody caught them. The word was X.');
      expect(AnnouncerLines.revealNotFound('Amit', 'X', outOfQuestions: true), 'Out of questions. The word was X, and the leak was Amit.');
      expect(
        AnnouncerLines.dailyStandings(4, leaders: ['Rohan'], leaderPoints: 18, seconds: ['Priya'], secondPoints: 15),
        'Day 4. Rohan leads with 18 points, Priya is second with 15.',
      );
    });

    test('daily standings handle ties and no score', () {
      expect(AnnouncerLines.dailyStandings(2, leaders: ['A', 'B'], leaderPoints: 6), 'Day 2. A and B are joint leaders with 6 points.');
      expect(AnnouncerLines.dailyStandings(2, leaders: ['A'], leaderPoints: 6, seconds: ['B', 'C'], secondPoints: 4),
          'Day 2. A leads with 6 points, B and C are joint second with 4.');
      expect(AnnouncerLines.dailyStandings(3, leaders: ['A'], leaderPoints: 0), 'Day 3. Nobody has scored yet.');
    });

    test('spoken numbers', () {
      expect([1, 10, 15, 20, 25, 30].map(AnnouncerLines.spoken).toList(), ['one', 'ten', 'fifteen', 'twenty', 'twenty-five', 'thirty']);
    });
  });

  group('Announcer queue', () {
    test('lines never overlap and keep their order', () async {
      final tts = FakeTts()..delay = const Duration(milliseconds: 5);
      final a = Announcer(tts, isMuted: () => false);
      a.say('one');
      a.say('two');
      await a.say('three');
      expect(tts.lines, ['one', 'two', 'three']);
      expect(tts.maxConcurrent, 1);
    });

    test('mute skips lines; the test voice ignores mute; stopAll drops the queue', () async {
      var muted = true;
      final tts = FakeTts()..delay = const Duration(milliseconds: 5);
      final a = Announcer(tts, isMuted: () => muted);
      await a.say('silent');
      await a.say(AnnouncerLines.testVoice, force: true);
      expect(tts.lines, [AnnouncerLines.testVoice]);
      muted = false;
      a.say('a');
      a.say('b');
      await a.stopAll();
      await a.idle;
      expect(tts.lines.length, lessThanOrEqualTo(2));
      expect(tts.lines, isNot(contains('b')));
    });
  });

  group('round announcements', () {
    late Harness h;
    late FakeTts tts;

    setUp(() async {
      tts = FakeTts();
      h = await Harness.create(extra: [
        ttsEngineProvider.overrideWithValue(tts),
        roundEventsProvider.overrideWith(AnnouncerEvents.new),
      ]);
    });
    tearDown(() => h.dispose());

    Future<void> idle() async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await h.read(announcerProvider).idle;
    }

    Future<(int, RoundController)> playToQuestioning(int tripId) async {
      final players = await h.read(tripRepositoryProvider).players(tripId);
      final id = await h.read(tripControllerProvider).startRound(
            tripId: tripId,
            carMode: true,
            driverId: players.first.id,
            difficulty: DifficultyChoice.easy,
          );
      h.container.listen(roundControllerProvider(id), (_, _) {});
      final v = await h.container.read(roundControllerProvider(id).future);
      final c = h.read(roundControllerProvider(id).notifier);
      for (var i = 0; i < v.handoutOrder.length; i++) {
        await c.handoutDone();
      }
      return (id, c);
    }

    test('a whole round: start, milestones once each, guess, vote, reveal; nothing secret before the reveal', () async {
      final tripId = await h.trip(5);
      final (id, c) = await playToQuestioning(tripId);
      for (var i = 0; i < 15; i++) {
        await c.increment();
      }
      await c.undo();
      await c.increment(); // back to 15: "Five questions left." must not repeat
      for (var i = 0; i < 4; i++) {
        await c.increment();
      }
      await c.wordGuessed();
      final v = h.container.read(roundControllerProvider(id)).requireValue;
      await c.pickGuesser(guessCandidates(v.round).first);
      await c.endDiscussion();
      final v2 = h.container.read(roundControllerProvider(id)).requireValue;
      for (final voter in v2.voteOrder) {
        await c.lockVote(voteCandidates(v2.round, voter).first);
      }
      await idle();

      final master = v.name(v.round.masterId);
      final word = v.word.word;
      final insider = v.name(v.round.insiderId);
      expect(tts.lines.first, 'Round 1. $master is the Master. Start asking.');
      expect(tts.lines.where((l) => l == 'Ten questions left.').length, 1);
      expect(tts.lines.where((l) => l == 'Five questions left.').length, 1);
      expect(tts.lines.where((l) => l == 'Last question.').length, 1);
      expect(tts.lines, contains(startsWith('Word guessed by ')));
      expect(tts.lines, contains('Time to vote. Driver, say your vote out loud.'));
      final revealAt = tts.lines.indexWhere((l) => l.contains('The leak was'));
      expect(revealAt, tts.lines.length - 1);
      expect(tts.lines.last, contains(insider));
      for (final l in tts.lines.take(revealAt)) {
        expect(l.contains(word), isFalse, reason: 'the word must not be spoken before the reveal');
        expect(l.toLowerCase().contains('leak was'), isFalse);
      }
      expect(tts.lines.last.contains(word), isTrue);
    });

    test('alerts off: no milestone lines; mute: nothing at all', () async {
      await h.read(settingsControllerProvider.notifier).setAlertsOn(false);
      final tripId = await h.trip(4);
      final (_, c) = await playToQuestioning(tripId);
      for (var i = 0; i < 20; i++) {
        await c.increment();
      }
      await idle();
      expect(tts.lines.where((l) => l.contains('questions left') || l == 'Last question.'), isEmpty);
      final before = tts.lines.length;
      await h.read(settingsControllerProvider.notifier).setMuted(true);
      await c.notGuessed();
      await idle();
      expect(tts.lines.length, before);
    });

    test('not found reveal line', () async {
      final tripId = await h.trip(4);
      final (id, c) = await playToQuestioning(tripId);
      await c.notGuessed();
      await idle();
      final v = h.container.read(roundControllerProvider(id)).requireValue;
      expect(v.round.outcome, Outcome.notFound);
      expect(tts.lines.last, startsWith('Word not found. The word was'));
    });

    test('first round of a new day starts with the daily standings', () async {
      final tripId = await h.trip(4);
      final (_, c) = await playToQuestioning(tripId);
      await c.increment();
      await c.notGuessed();
      await c.nextRound();
      await idle();
      expect(tts.lines.any((l) => l.startsWith('Day ')), isFalse, reason: 'not on day one');

      h.clock.now = h.clock.now.add(const Duration(days: 1));
      tts.lines.clear();
      await playToQuestioning(tripId);
      await idle();
      expect(tts.lines.first, 'Day 2. Nobody has scored yet.');
      expect(tts.lines[1], startsWith('Round 2.'));
    });
  });
}
