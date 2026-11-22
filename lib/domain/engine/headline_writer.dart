import '../models/outcome.dart';
import '../models/round.dart';
import '../models/vote.dart';
import 'number_words.dart';
import 'scorer.dart';
import 'vote_resolver.dart';

class Headline {
  const Headline({required this.title, required this.deck, required this.outcome});

  /// "CAUGHT!", "ESCAPED!" or "NOT FOUND".
  final String title;

  /// The one-sentence story under the headline.
  final String deck;
  final Outcome outcome;
}

String headlineTitle(Outcome o) => switch (o) {
      Outcome.caught => 'CAUGHT!',
      Outcome.notCaught => 'ESCAPED!',
      Outcome.notFound || Outcome.abandoned => 'NOT FOUND',
    };

/// Headline and deck sentence for the Reveal (PRD section 3.1). Counts under
/// ten are written as words; vote splits stay as scores ("4–2").
///
/// [names] maps player id to display name. [group] is "car" in Car mode and
/// "group" otherwise.
Headline writeHeadline(Round round, List<Vote> votes, {required Map<int, String> names, required int questionLimit}) {
  final outcome = round.outcome == Outcome.abandoned ? Outcome.abandoned : decideOutcome(round, votes);
  final group = round.carMode ? 'car' : 'group';
  final insider = names[round.insiderId] ?? 'The leak';
  final n = round.questionsUsed;
  final String deck;
  switch (outcome) {
    case Outcome.caught:
      final just = n < 10 ? 'just ' : '';
      deck = '$insider exposed as the leak and voted out after the $group cracked the word in $just${questionsPhrase(n)}.';
    case Outcome.notCaught:
      final out = groupVerdict(votes, masterId: round.masterId);
      final suspect = out == null ? null : names[out];
      deck = suspect == null
          ? '$insider walked free after the $group cracked the word in ${questionsPhrase(n)}.'
          : '$insider walked free as the $group voted out $suspect, after cracking the word in ${questionsPhrase(n)}.';
    case Outcome.notFound:
    case Outcome.abandoned:
      if (n >= questionLimit) {
        deck = 'The $group burned through all ${questionsPhrase(questionLimit)} without cracking the word. $insider kept the secret.';
      } else if (n == 0) {
        deck = 'The $group gave up without asking a single question. $insider kept the secret.';
      } else {
        deck = 'The $group gave up after ${questionsPhrase(n)}. $insider kept the secret all along.';
      }
  }
  return Headline(title: headlineTitle(outcome), deck: deck, outcome: outcome);
}
