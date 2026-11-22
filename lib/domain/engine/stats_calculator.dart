import '../models/outcome.dart';
import '../models/player.dart';
import '../models/round.dart';
import '../models/stats.dart';
import 'vote_resolver.dart';

/// Every trip stat from PRD section 5, computed on demand from saved rounds.
/// Abandoned and unfinished rounds are ignored.
TripStats computeStats(List<Player> players, List<RoundRecord> records) {
  final byId = <int, PlayerStats>{for (final p in players) p.id: PlayerStats(p)};
  final scored = records.where((r) => r.round.outcome != null && r.round.outcome!.scored).toList();
  var caught = 0;

  for (final rec in scored) {
    final r = rec.round;
    final outcome = r.outcome!;
    if (outcome == Outcome.caught) caught++;
    for (final id in r.participantIds) {
      final s = byId[id];
      if (s == null) continue;
      s.roundsPlayed++;
      s.points += rec.points[id] ?? 0;
    }
    final insider = byId[r.insiderId];
    if (insider != null) {
      insider.insiderRounds++;
      if (outcome == Outcome.notCaught) insider.insiderEscapes++;
    }
    final master = byId[r.masterId];
    if (master != null) {
      master.masterRounds++;
      if (outcome.wordFound) master.masterFound++;
    }
    if (outcome.wordFound && r.guessedById != null) {
      final cracker = byId[r.guessedById];
      if (cracker != null) {
        cracker.cracks++;
        final f = cracker.fastestCrack;
        if (f == null || r.questionsUsed < f) cracker.fastestCrack = r.questionsUsed;
      }
    }
    // Always Suspected: rounds where the group voted you out and you were not the Leak.
    final out = groupVerdict(rec.votes, masterId: r.masterId);
    if (out != null && out != r.insiderId) byId[out]?.wronglyVotedOut++;
  }

  final all = byId.values.toList();
  final awards = <Award>[];
  void add(AwardType type, bool Function(PlayerStats) qualifies, int Function(PlayerStats a, PlayerStats b) better) {
    final winners = _pick(all.where(qualifies).toList(), better);
    if (winners.isNotEmpty) awards.add(Award(type, winners));
  }

  add(AwardType.champion, (s) => s.points > 0, (a, b) => 0);
  add(AwardType.snake, (s) => s.insiderRounds >= 2 && s.insiderEscapes > 0, (a, b) => a.survival.compareTo(b.survival));
  add(AwardType.wordCracker, (s) => s.cracks >= 1, (a, b) => a.cracks.compareTo(b.cracks));
  add(AwardType.speedDemon, (s) => s.fastestCrack != null, (a, b) => b.fastestCrack!.compareTo(a.fastestCrack!));
  add(AwardType.bestHost, (s) => s.masterRounds >= 2 && s.masterFound > 0, (a, b) => a.masterSuccess.compareTo(b.masterSuccess));
  add(AwardType.alwaysSuspected, (s) => s.wronglyVotedOut >= 1, (a, b) => a.wronglyVotedOut.compareTo(b.wronglyVotedOut));

  final days = scored.map((r) => _day(r.round.startedAt)).toSet().length;
  return TripStats(
    players: byId,
    standings: _standings(all),
    awards: awards,
    roundsPlayed: scored.length,
    caughtCount: caught,
    days: days,
  );
}

/// Best by [better] (positive when a beats b); ties go to higher points;
/// still tied, all of them win.
List<int> _pick(List<PlayerStats> qualifiers, int Function(PlayerStats a, PlayerStats b) better) {
  if (qualifiers.isEmpty) return const [];
  var best = <PlayerStats>[qualifiers.first];
  for (final s in qualifiers.skip(1)) {
    final c = better(s, best.first);
    if (c > 0) {
      best = [s];
    } else if (c == 0) {
      best.add(s);
    }
  }
  final topPoints = best.map((s) => s.points).reduce((a, b) => a > b ? a : b);
  final winners = best.where((s) => s.points == topPoints).toList()..sort((a, b) => a.player.seatOrder.compareTo(b.player.seatOrder));
  return winners.map((s) => s.player.id).toList();
}

List<StandingRow> _standings(List<PlayerStats> all) {
  final shown = all.where((s) => s.player.active || s.roundsPlayed > 0).toList()
    ..sort((a, b) {
      final c = b.points.compareTo(a.points);
      if (c != 0) return c;
      return a.player.seatOrder.compareTo(b.player.seatOrder);
    });
  final rows = <StandingRow>[];
  for (var i = 0; i < shown.length; i++) {
    final pos = i > 0 && shown[i].points == shown[i - 1].points ? rows[i - 1].position : i + 1;
    rows.add(StandingRow(position: pos, stats: shown[i]));
  }
  return rows;
}

DateTime _day(DateTime t) => DateTime(t.year, t.month, t.day);

/// The day number of a trip: distinct local dates with rounds started.
int dayNumber(Iterable<DateTime> roundStarts) => roundStarts.map(_day).toSet().length;

/// Whether a round starting at [now] is the first of a new day (Day 2 on),
/// given the start times of the trip's earlier scored rounds.
bool isFirstRoundOfNewDay(Iterable<DateTime> earlierStarts, DateTime now) {
  final days = earlierStarts.map(_day).toSet();
  return days.isNotEmpty && !days.contains(_day(now));
}
