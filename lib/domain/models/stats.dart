import 'player.dart';

/// A ratio shown as "67% (2 of 3)".
class Rate {
  const Rate(this.hits, this.total);

  final int hits;
  final int total;

  int get percent => total == 0 ? 0 : (hits * 100 / total).round();

  String get display => '$percent% ($hits of $total)';

  /// Exact comparison without floating point.
  int compareTo(Rate other) => (hits * other.total).compareTo(other.hits * total);
}

class PlayerStats {
  PlayerStats(this.player);

  final Player player;
  int points = 0;
  int roundsPlayed = 0;
  int insiderRounds = 0;
  int insiderEscapes = 0;
  int cracks = 0;
  int? fastestCrack;
  int masterRounds = 0;
  int masterFound = 0;
  /// Rounds where the group voted this player out when they were not the Leak.
  int wronglyVotedOut = 0;

  /// Insider survival rate: escapes ÷ rounds as Insider.
  Rate get survival => Rate(insiderEscapes, insiderRounds);

  /// Master success rate: rounds as Master where the word was found ÷ rounds as Master.
  Rate get masterSuccess => Rate(masterFound, masterRounds);
}

enum AwardType {
  champion('Champion'),
  snake('The Snake'),
  wordCracker('Word Cracker'),
  speedDemon('Speed Demon'),
  bestHost('Best Host'),
  alwaysSuspected('Always Suspected');

  const AwardType(this.title);
  final String title;
}

class Award {
  const Award(this.type, this.winnerIds);

  final AwardType type;

  /// More than one id when still tied after points.
  final List<int> winnerIds;
}

class StandingRow {
  const StandingRow({required this.position, required this.stats});

  /// Shared by tied players (1, 1, 3…).
  final int position;
  final PlayerStats stats;
}

class TripStats {
  const TripStats({
    required this.players,
    required this.standings,
    required this.awards,
    required this.roundsPlayed,
    required this.caughtCount,
    required this.days,
  });

  final Map<int, PlayerStats> players;
  final List<StandingRow> standings;
  final List<Award> awards;
  final int roundsPlayed;

  /// Rounds where the Insider was caught ("leaks plugged").
  final int caughtCount;

  /// Distinct days with rounds played.
  final int days;

  Award? award(AwardType t) {
    for (final a in awards) {
      if (a.type == t) return a;
    }
    return null;
  }
}
