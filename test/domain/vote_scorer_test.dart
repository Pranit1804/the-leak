import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/domain/engine/scorer.dart';
import 'package:the_leak/domain/engine/vote_resolver.dart';
import 'package:the_leak/domain/models/outcome.dart';
import 'package:the_leak/domain/models/vote.dart';

import 'helpers.dart';

List<Vote> votes(Map<int, int> m) => [for (final e in m.entries) Vote(voterId: e.key, targetId: e.value)];

void main() {
  group('resolveVote', () {
    test('Insider with strictly the most votes is caught', () {
      final r = resolveVote(votes({1: 3, 2: 3, 4: 3, 5: 2, 3: 5}), 3);
      expect(r.caught, isTrue);
      expect(r.insiderVotes, 3);
      expect(r.otherVotes, 2);
    });

    test('a plurality is enough', () {
      // Insider 3 gets 2; 1 and 2 get 1 each.
      expect(resolveVote(votes({1: 3, 2: 3, 4: 1, 5: 2}), 3).caught, isTrue);
    });

    test('a tie for the most votes is not caught', () {
      final r = resolveVote(votes({1: 3, 2: 3, 3: 4, 4: 3, 5: 4, 6: 4}), 3);
      expect(r.caught, isFalse);
      expect(r.topTargets, [3, 4]);
      expect(r.topIsTie, isTrue);
    });

    test('someone else with the most votes: not caught', () {
      expect(resolveVote(votes({1: 4, 2: 4, 3: 4, 4: 3}), 3).caught, isFalse);
    });

    test('no votes for the Insider, or no votes at all: not caught', () {
      expect(resolveVote(votes({1: 2, 2: 1}), 3).caught, isFalse);
      expect(resolveVote(const [], 3).caught, isFalse);
    });
  });

  group('groupVerdict', () {
    test('the one group vote names who was voted out', () {
      expect(groupVerdict(const [Vote(voterId: 2, targetId: 4)], masterId: 2), 4);
      expect(resolveVote(const [Vote(voterId: 2, targetId: 4)], 4).caught, isTrue);
      expect(resolveVote(const [Vote(voterId: 2, targetId: 5)], 4).caught, isFalse);
    });

    test('per-player votes from an older build: the clear top target, or nobody on a tie', () {
      expect(groupVerdict(votes({1: 3, 2: 3, 4: 1}), masterId: 2), 3);
      expect(groupVerdict(votes({1: 3, 2: 4}), masterId: 2), isNull);
      expect(groupVerdict(const [], masterId: 2), isNull);
    });
  });

  group('scoreRound (PRD 2.3)', () {
    // 6 players, Car mode on, driver 1, Master 2, Insider 4.
    final found = makeRound(
        participants: [1, 2, 3, 4, 5, 6], master: 2, insider: 4, carMode: true, driver: 1, guessedBy: 3, questions: 7);

    test('word found, Insider caught: Commons +2 each (driver too), Insider 0, Master +1', () {
      final s = scoreRound(found, votes({3: 4, 4: 3, 5: 4, 6: 4, 2: 4, 1: 5}));
      expect(s.outcome, Outcome.caught);
      expect(s.points, {1: 2, 2: 1, 3: 2, 4: 0, 5: 2, 6: 2});
    });

    test('word found, Insider not caught: Insider +3, everyone else 0', () {
      final s = scoreRound(found, votes({3: 5, 4: 3, 5: 3, 6: 4, 2: 4, 1: 3}));
      expect(s.outcome, Outcome.notCaught);
      expect(s.points, {1: 0, 2: 0, 3: 0, 4: 3, 5: 0, 6: 0});
    });

    test('word found, vote tied: not caught, Insider +3', () {
      final s = scoreRound(found, votes({3: 4, 4: 3, 5: 4, 6: 5, 2: 5, 1: 3}));
      expect(s.outcome, Outcome.notCaught);
      expect(s.points[4], 3);
    });

    test('word not found: nobody scores', () {
      final r = makeRound(participants: [1, 2, 3, 4], master: 1, insider: 2, questions: 20);
      final s = scoreRound(r, const []);
      expect(s.outcome, Outcome.notFound);
      expect(s.points, {1: 0, 2: 0, 3: 0, 4: 0});
    });

    test('abandoned: nobody scores', () {
      final r = makeRound(participants: [1, 2, 3, 4], master: 1, insider: 2, guessedBy: 3, outcome: Outcome.abandoned);
      final s = scoreRound(r, votes({2: 3, 3: 2, 4: 2, 1: 2}));
      expect(s.outcome, Outcome.abandoned);
      expect(s.points.values.every((p) => p == 0), isTrue);
    });
  });
}
