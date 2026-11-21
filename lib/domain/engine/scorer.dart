import '../models/outcome.dart';
import '../models/round.dart';
import '../models/vote.dart';
import 'vote_resolver.dart';

class RoundScore {
  const RoundScore({required this.outcome, required this.points});

  final Outcome outcome;

  /// Points for every participant (0 included).
  final Map<int, int> points;
}

/// Outcome of a round from its data: abandoned stays abandoned, no guesser
/// means the word was not found, otherwise the vote decides.
Outcome decideOutcome(Round round, List<Vote> votes) {
  if (round.outcome == Outcome.abandoned) return Outcome.abandoned;
  if (round.guessedById == null) return Outcome.notFound;
  return resolveVote(votes, round.insiderId).caught ? Outcome.caught : Outcome.notCaught;
}

/// Points per player from the PRD scoring table (section 2.3).
///
/// | Outcome                        | Commons  | Insider | Master |
/// | Word found, Insider caught     | +2 each  | 0       | +1     |
/// | Word found, Insider not caught | 0        | +3      | 0      |
/// | Word not found                 | 0        | 0       | 0      |
///
/// The Car mode driver scores as a Common.
RoundScore scoreRound(Round round, List<Vote> votes) {
  final outcome = decideOutcome(round, votes);
  final points = <int, int>{for (final id in round.participantIds) id: 0};
  switch (outcome) {
    case Outcome.caught:
      for (final id in round.participantIds) {
        points[id] = id == round.masterId ? 1 : (id == round.insiderId ? 0 : 2);
      }
    case Outcome.notCaught:
      points[round.insiderId] = 3;
    case Outcome.notFound:
    case Outcome.abandoned:
      break;
  }
  return RoundScore(outcome: outcome, points: points);
}
