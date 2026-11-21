import '../models/outcome.dart';
import '../models/round.dart';
import '../models/round_phase.dart';

/// Handout order: eligible players in seat order, starting after the Master
/// and wrapping round, with the Master last. The Car mode driver is skipped.
///
/// [participantIds] must be in seat order.
List<int> handoutOrder(List<int> participantIds, {required int masterId, int? driverId}) {
  final eligible = participantIds.where((id) => id != driverId).toList();
  final m = eligible.indexOf(masterId);
  if (m < 0) throw ArgumentError('Master is not an eligible participant');
  return [...eligible.sublist(m + 1), ...eligible.sublist(0, m), masterId];
}

List<int> handoutOrderOf(Round r) => handoutOrder(r.participantIds, masterId: r.masterId, driverId: r.activeDriverId);

/// Vote order: every passenger in handout order (the Master votes in their own
/// turn, last of the passengers), then the Car mode driver, who says the vote
/// aloud while the Master enters it.
List<int> voteOrderOf(Round r) => [...handoutOrderOf(r), ?r.activeDriverId];

/// Who [voterId] may vote for: everyone except themselves, the Master and the
/// Car mode driver, in seat order.
List<int> voteCandidates(Round r, int voterId) =>
    r.participantIds.where((id) => id != voterId && id != r.masterId && id != r.activeDriverId).toList();

/// Players who can be picked on Who guessed: everyone except the Master.
List<int> guessCandidates(Round r) => r.participantIds.where((id) => id != r.masterId).toList();

/// Pure transitions of the round state machine (TECH_SPEC section 6).
/// Each returns the next stored state; the caller persists it before the UI updates.
abstract final class RoundMachine {
  static void _expect(Round r, RoundPhase p) {
    if (r.phase != p) throw StateError('Expected phase ${p.name}, was ${r.phase.name}');
  }

  /// "Done · pass to …": next player, or `questioning` after the last one.
  static Round handoutDone(Round r) {
    _expect(r, RoundPhase.handout);
    final count = handoutOrderOf(r).length;
    if (r.handoutIndex + 1 < count) return r.copyWith(handoutIndex: r.handoutIndex + 1);
    return r.copyWith(phase: RoundPhase.questioning, handoutIndex: count);
  }

  /// +1, stopping at the limit.
  static Round increment(Round r, int limit) {
    _expect(r, RoundPhase.questioning);
    return r.questionsUsed >= limit ? r : r.copyWith(questionsUsed: r.questionsUsed + 1);
  }

  /// Undo, stopping at zero.
  static Round undo(Round r) {
    _expect(r, RoundPhase.questioning);
    return r.questionsUsed <= 0 ? r : r.copyWith(questionsUsed: r.questionsUsed - 1);
  }

  /// Word guessed → Who guessed. A guess counts as a question, so at least one is needed.
  static Round wordGuessed(Round r) {
    _expect(r, RoundPhase.questioning);
    if (r.questionsUsed < 1) throw StateError('No questions asked yet');
    return r.copyWith(phase: RoundPhase.whoGuessed);
  }

  /// Back from Who guessed (a mis-tap on Word guessed).
  static Round backToQuestioning(Round r) {
    _expect(r, RoundPhase.whoGuessed);
    return r.copyWith(phase: RoundPhase.questioning);
  }

  /// Guesser picked → Discussion, or straight to Voting when the timer is off.
  static Round guesserPicked(Round r, int guesserId, {required int discussionSeconds, required DateTime now}) {
    _expect(r, RoundPhase.whoGuessed);
    if (!guessCandidates(r).contains(guesserId)) throw ArgumentError('Not a valid guesser');
    if (discussionSeconds <= 0) {
      return r.copyWith(phase: RoundPhase.voting, guessedById: guesserId, voteIndex: 0, discussionEndsAt: null);
    }
    return r.copyWith(
      phase: RoundPhase.discussion,
      guessedById: guesserId,
      discussionEndsAt: now.add(Duration(seconds: discussionSeconds)),
    );
  }

  /// Discussion reached zero or was skipped.
  static Round discussionEnded(Round r) {
    _expect(r, RoundPhase.discussion);
    return r.copyWith(phase: RoundPhase.voting, voteIndex: 0);
  }

  /// A vote was locked: next voter, or `reveal` after the last one.
  /// The caller fills in the outcome and scores for the reveal.
  static Round voteLocked(Round r) {
    _expect(r, RoundPhase.voting);
    final count = voteOrderOf(r).length;
    if (r.voteIndex + 1 < count) return r.copyWith(voteIndex: r.voteIndex + 1);
    return r.copyWith(phase: RoundPhase.reveal, voteIndex: count);
  }

  /// Not guessed → straight to the reveal; discussion and vote are skipped.
  static Round notGuessed(Round r) {
    _expect(r, RoundPhase.questioning);
    return r.copyWith(phase: RoundPhase.reveal, guessedById: null, outcome: Outcome.notFound);
  }

  /// Next round or End trip from the reveal.
  static Round close(Round r, DateTime now) {
    _expect(r, RoundPhase.reveal);
    return r.copyWith(phase: RoundPhase.done, endedAt: r.endedAt ?? now);
  }

  /// A confirmed back-out from any phase: nothing is scored.
  static Round abandon(Round r, DateTime now) {
    if (r.phase == RoundPhase.done) return r;
    return r.copyWith(phase: RoundPhase.done, outcome: Outcome.abandoned, endedAt: now);
  }
}
