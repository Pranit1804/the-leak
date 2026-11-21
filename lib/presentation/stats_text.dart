import '../domain/models/stats.dart';

/// "Amit & Neha" for shared awards.
String winnersText(Award a, TripStats s) => a.winnerIds.map((id) => s.players[id]!.player.name).join(' & ');

/// The short detail after a title holder's name on Standings ("3 of 4 escapes").
String awardDetail(Award a, TripStats s) {
  final p = s.players[a.winnerIds.first]!;
  return switch (a.type) {
    AwardType.champion => '${p.points} pts',
    AwardType.snake => '${p.insiderEscapes} of ${p.insiderRounds} escapes',
    AwardType.sherlock => '${p.correctVotes} of ${p.votesCast} right',
    AwardType.wordCracker => p.cracks == 1 ? '1 crack' : '${p.cracks} cracks',
    AwardType.speedDemon => 'cracked in ${p.fastestCrack}',
    AwardType.bestHost => '${p.masterFound} of ${p.masterRounds} found',
    AwardType.alwaysSuspected => p.falseVotes == 1 ? '1 vote' : '${p.falseVotes} votes',
  };
}

/// One row of the Stats tab: the stat and how to show each player's value.
class StatLine {
  const StatLine(this.title, this.award, this.value);

  final String title;
  final AwardType award;
  final String Function(PlayerStats p) value;
}

String _rate(Rate r) => r.total == 0 ? '—' : r.display;

/// Every stat from PRD section 5, in table order.
final statLines = <StatLine>[
  StatLine('Points', AwardType.champion, (p) => '${p.points}'),
  StatLine('Insider survival rate', AwardType.snake, (p) => _rate(p.survival)),
  StatLine('Detective accuracy', AwardType.sherlock, (p) => _rate(p.detective)),
  StatLine('Word cracker', AwardType.wordCracker, (p) => '${p.cracks}'),
  StatLine('Fastest crack', AwardType.speedDemon, (p) => p.fastestCrack == null ? '—' : '${p.fastestCrack} questions'),
  StatLine('Master success rate', AwardType.bestHost, (p) => _rate(p.masterSuccess)),
  StatLine('Most falsely accused', AwardType.alwaysSuspected, (p) => '${p.falseVotes}'),
];

/// "48 rounds, 6 suspects, 31 leaks plugged. Rohan takes the crown."
String wrappedDeck(TripStats s) {
  String n(int v, String one, String many) => '$v ${v == 1 ? one : many}';
  final suspects = s.standings.length;
  final champ = s.award(AwardType.champion);
  final crown = champ == null
      ? 'Nobody takes the crown.'
      : champ.winnerIds.length == 1
          ? '${winnersText(champ, s)} takes the crown.'
          : '${champ.winnerIds.map((id) => s.players[id]!.player.name).join(' and ')} share the crown.';
  return '${n(s.roundsPlayed, 'round', 'rounds')}, ${n(suspects, 'suspect', 'suspects')}, '
      '${n(s.caughtCount, 'leak plugged', 'leaks plugged')}. $crown';
}

/// Trip Wrapped unlocks after 10 rounds or when the trip is ended.
const wrappedAfterRounds = 10;
