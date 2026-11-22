import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/domain/engine/round_machine.dart';
import 'package:the_leak/domain/models/outcome.dart';
import 'package:the_leak/domain/models/round_phase.dart';

import 'helpers.dart';

void main() {
  // Mockup cast in seat order: Rohan 1 (driver), Priya 2 (Master), Amit 3, Sneha 4, Kunal 5, Neha 6.
  final car = makeRound(participants: [1, 2, 3, 4, 5, 6], master: 2, insider: 4, carMode: true, driver: 1);

  group('orders', () {
    test('handout skips the driver, starts after the Master, Master last (04a: Sneha is 2 of 5)', () {
      expect(handoutOrderOf(car), [3, 4, 5, 6, 2]);
      expect(handoutOrderOf(car).indexOf(4), 1);
    });

    test('the group can vote out anyone but the Master and the driver', () {
      expect(voteCandidates(car), [3, 4, 5, 6]);
    });

    test('Car mode off: nobody skipped and the stored driver is ignored', () {
      final r = makeRound(participants: [1, 2, 3, 4], master: 4, insider: 2, carMode: false, driver: 1);
      expect(handoutOrderOf(r), [1, 2, 3, 4]);
      expect(voteCandidates(r), [1, 2, 3], reason: 'only the Master is excluded');
    });

    test('Who guessed lists everyone but the Master, driver included', () {
      expect(guessCandidates(car), [1, 3, 4, 5, 6]);
    });
  });

  group('transitions', () {
    test('handout walks every player, then questioning', () {
      var r = car;
      for (var i = 0; i < 4; i++) {
        r = RoundMachine.handoutDone(r);
        expect(r.phase, RoundPhase.handout);
        expect(r.handoutIndex, i + 1);
      }
      r = RoundMachine.handoutDone(r);
      expect(r.phase, RoundPhase.questioning);
    });

    test('counter stops at the limit and Undo stops at zero', () {
      var r = car.copyWith(phase: RoundPhase.questioning);
      r = RoundMachine.undo(r);
      expect(r.questionsUsed, 0);
      for (var i = 0; i < 25; i++) {
        r = RoundMachine.increment(r, 20);
      }
      expect(r.questionsUsed, 20);
      r = RoundMachine.undo(r);
      expect(r.questionsUsed, 19);
    });

    test('Word guessed needs at least one question and can be backed out of', () {
      final q = car.copyWith(phase: RoundPhase.questioning);
      expect(() => RoundMachine.wordGuessed(q), throwsStateError);
      final g = RoundMachine.wordGuessed(q.copyWith(questionsUsed: 7));
      expect(g.phase, RoundPhase.whoGuessed);
      expect(RoundMachine.backToQuestioning(g).phase, RoundPhase.questioning);
    });

    test('guesser picked: discussion with an end time, or voting when the timer is off', () {
      final g = car.copyWith(phase: RoundPhase.whoGuessed, questionsUsed: 7);
      final now = DateTime(2026, 11, 20, 12);
      final d = RoundMachine.guesserPicked(g, 3, discussionSeconds: 120, now: now);
      expect(d.phase, RoundPhase.discussion);
      expect(d.guessedById, 3);
      expect(d.discussionEndsAt, now.add(const Duration(minutes: 2)));
      final v = RoundMachine.guesserPicked(g, 1, discussionSeconds: 0, now: now);
      expect(v.phase, RoundPhase.voting);
      expect(() => RoundMachine.guesserPicked(g, 2, discussionSeconds: 0, now: now), throwsArgumentError,
          reason: 'the Master cannot be the guesser');
    });

    test('one group vote goes straight to the reveal', () {
      final r = RoundMachine.voteLocked(car.copyWith(phase: RoundPhase.voting));
      expect(r.phase, RoundPhase.reveal);
    });

    test('not guessed skips discussion and vote', () {
      final r = RoundMachine.notGuessed(car.copyWith(phase: RoundPhase.questioning, questionsUsed: 20));
      expect(r.phase, RoundPhase.reveal);
      expect(r.outcome, Outcome.notFound);
    });

    test('close and abandon', () {
      final now = DateTime(2026, 11, 20, 13);
      final done = RoundMachine.close(car.copyWith(phase: RoundPhase.reveal), now);
      expect(done.phase, RoundPhase.done);
      expect(done.endedAt, now);
      final ab = RoundMachine.abandon(car.copyWith(phase: RoundPhase.discussion), now);
      expect(ab.phase, RoundPhase.done);
      expect(ab.outcome, Outcome.abandoned);
    });

    test('a transition from the wrong phase is refused', () {
      expect(() => RoundMachine.increment(car, 20), throwsStateError);
      expect(() => RoundMachine.voteLocked(car), throwsStateError);
    });
  });
}
