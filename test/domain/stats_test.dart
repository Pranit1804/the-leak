import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/domain/engine/scorer.dart';
import 'package:the_leak/domain/engine/stats_calculator.dart';
import 'package:the_leak/domain/models/outcome.dart';
import 'package:the_leak/domain/models/player.dart';
import 'package:the_leak/domain/models/round.dart';
import 'package:the_leak/domain/models/round_phase.dart';
import 'package:the_leak/domain/models/stats.dart';
import 'package:the_leak/domain/models/vote.dart';

import 'helpers.dart';

// Players A..E = ids 1..5. E is removed before round 11.
const a = 1, b = 2, c = 3, d = 4, e = 5;

RoundRecord rec(
  int n, {
  required int master,
  required int insider,
  int? guessed,
  required int q,
  int? out,
  bool car = false,
  int? driver,
  List<int> who = const [a, b, c, d, e],
  required int day,
  bool abandoned = false,
}) {
  final round = makeRound(
    id: n,
    number: n,
    participants: who,
    master: master,
    insider: insider,
    carMode: car,
    driver: driver,
    phase: RoundPhase.done,
    questions: q,
    guessedBy: guessed,
    outcome: abandoned ? Outcome.abandoned : null,
    startedAt: DateTime(2026, 11, 19 + day, 9 + n),
  );
  // The group agrees on one name and the Master enters it.
  final vs = [if (out != null) Vote(voterId: master, targetId: out)];
  final score = scoreRound(round, vs);
  return RoundRecord(round: round.copyWith(outcome: score.outcome), votes: vs, points: score.points);
}

/// 12 hand-scored rounds (round 6 abandoned). Expected values below were
/// counted by hand from this table, not produced by the code under test.
final fixture = <RoundRecord>[
  rec(1, master: a, insider: b, guessed: c, q: 7, out: b, day: 1), // caught
  rec(2, master: b, insider: d, guessed: a, q: 12, out: c, day: 1), // not caught: C voted out
  rec(3, master: c, insider: e, q: 20, day: 1), // not found
  rec(4, master: d, insider: a, guessed: e, q: 5, out: a, day: 1), // caught
  rec(5, master: e, insider: c, guessed: c, q: 9, out: a, day: 1), // not caught: A voted out
  rec(6, master: a, insider: d, q: 3, day: 1, abandoned: true), // ignored
  rec(7, master: a, insider: b, guessed: d, q: 15, out: e, day: 2), // not caught: E voted out
  rec(8, master: b, insider: e, guessed: a, q: 6, out: e, car: true, driver: a, day: 2), // caught
  rec(9, master: c, insider: d, q: 14, car: true, driver: a, day: 2), // not found (gave up)
  rec(10, master: d, insider: c, guessed: b, q: 4, out: c, day: 2), // caught
  rec(11, master: a, insider: b, guessed: c, q: 11, out: c, who: [a, b, c, d], day: 3), // not caught: C voted out
  rec(12, master: b, insider: a, guessed: a, q: 8, out: a, who: [a, b, c, d], day: 3), // caught
];

void main() {
  final players = makePlayers(5, drivers: {a}, removed: {e});
  final stats = computeStats(players, fixture);
  PlayerStats s(int id) => stats.players[id]!;

  test('outcomes per round match the hand count', () {
    expect(fixture.map((r) => r.round.outcome).toList(), [
      Outcome.caught, Outcome.notCaught, Outcome.notFound, Outcome.caught, Outcome.notCaught, Outcome.abandoned, //
      Outcome.notCaught, Outcome.caught, Outcome.notFound, Outcome.caught, Outcome.notCaught, Outcome.caught,
    ]);
    expect(stats.roundsPlayed, 11);
    expect(stats.caughtCount, 5);
    expect(stats.days, 3);
  });

  test('points and rounds played', () {
    expect({for (final id in [a, b, c, d, e]) id: s(id).points}, {a: 5, b: 12, c: 11, d: 11, e: 6});
    expect({for (final id in [a, b, c, d, e]) id: s(id).roundsPlayed}, {a: 11, b: 11, c: 11, d: 11, e: 9});
  });

  test('standings share positions on ties and keep the removed player', () {
    expect(stats.standings.map((r) => [r.position, r.stats.player.id]).toList(), [
      [1, b],
      [2, c],
      [2, d],
      [4, e],
      [5, a],
    ]);
  });

  test('Insider survival rate', () {
    expect([for (final id in [a, b, c, d, e]) s(id).survival.display],
        ['0% (0 of 2)', '67% (2 of 3)', '50% (1 of 2)', '50% (1 of 2)', '0% (0 of 2)']);
  });

  test('Word cracker and fastest crack', () {
    expect([for (final id in [a, b, c, d, e]) s(id).cracks], [3, 1, 3, 1, 1]);
    expect([for (final id in [a, b, c, d, e]) s(id).fastestCrack], [6, 4, 7, 15, 5]);
  });

  test('Master success rate', () {
    expect([for (final id in [a, b, c, d, e]) s(id).masterSuccess.display],
        ['100% (3 of 3)', '100% (3 of 3)', '0% (0 of 2)', '100% (2 of 2)', '100% (1 of 1)']);
  });

  test('Wrongly voted out (Always Suspected)', () {
    expect([for (final id in [a, b, c, d, e]) s(id).wronglyVotedOut], [1, 0, 2, 0, 1]);
  });

  test('awards, including tie-breaks on points', () {
    List<int>? w(AwardType t) => stats.award(t)?.winnerIds;
    expect(w(AwardType.champion), [b]);
    expect(w(AwardType.snake), [b]);
    expect(w(AwardType.wordCracker), [c], reason: 'A and C have 3 cracks; C has more points');
    expect(w(AwardType.speedDemon), [b]);
    expect(w(AwardType.bestHost), [b], reason: 'A, B and D are all 100%; B has the most points');
    expect(w(AwardType.alwaysSuspected), [c]);
  });

  test('minimums to qualify', () {
    // After round 1 only: nobody has 2 rounds as Insider or Master, and the group voted out the Leak.
    final early = computeStats(players, fixture.take(1).toList());
    expect(early.award(AwardType.snake), isNull);
    expect(early.award(AwardType.bestHost), isNull);
    expect(early.award(AwardType.wordCracker)?.winnerIds, [c]);
    expect(early.award(AwardType.speedDemon)?.winnerIds, [c]);
    expect(early.award(AwardType.alwaysSuspected), isNull);
  });

  test('still tied after points: both get the award', () {
    final twins = [
      rec(1, master: a, insider: b, guessed: c, q: 5, out: b, day: 1),
      rec(2, master: b, insider: a, guessed: d, q: 5, out: a, day: 1),
    ];
    final t = computeStats(makePlayers(5), twins);
    // C and D both cracked in 5 and both have 4 points.
    expect(t.players[c]!.points, t.players[d]!.points);
    expect(t.award(AwardType.speedDemon)?.winnerIds, [c, d]);
  });

  test('no rounds: no awards and an empty table of zeros', () {
    final t = computeStats(players.where((p) => p.active).toList(), const []);
    expect(t.awards, isEmpty);
    expect(t.standings.every((r) => r.position == 1 && r.stats.points == 0), isTrue);
  });

  test('day helpers', () {
    final starts = [DateTime(2026, 11, 20, 9), DateTime(2026, 11, 20, 22), DateTime(2026, 11, 21, 8)];
    expect(dayNumber(starts), 2);
    expect(isFirstRoundOfNewDay(starts, DateTime(2026, 11, 21, 12)), isFalse);
    expect(isFirstRoundOfNewDay(starts, DateTime(2026, 11, 22, 7)), isTrue);
    expect(isFirstRoundOfNewDay(const [], DateTime(2026, 11, 22)), isFalse);
  });

  test('a removed player keeps past stats', () {
    final p = players.firstWhere((x) => x.id == e);
    expect(p.active, isFalse);
    expect(s(e).insiderRounds, 2);
    expect(stats.standings.any((r) => r.stats.player.id == e), isTrue);
  });

  test('votes are only counted from scored rounds', () {
    final withVoteInAbandoned = [
      ...fixture.take(5),
      RoundRecord(
        round: fixture[5].round,
        votes: const [Vote(voterId: b, targetId: c)],
        points: fixture[5].points,
      ),
    ];
    final t = computeStats(players, withVoteInAbandoned);
    final base = computeStats(players, fixture.take(5).toList());
    expect(t.players[c]!.wronglyVotedOut, base.players[c]!.wronglyVotedOut);
  });

  test('a Player list without some participants is tolerated', () {
    final t = computeStats(<Player>[players.first], fixture);
    expect(t.players.keys, [a]);
  });
}
