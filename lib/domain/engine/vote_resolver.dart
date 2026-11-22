import '../models/vote.dart';

class VoteResult {
  const VoteResult({required this.caught, required this.tally, required this.insiderVotes, required this.topTargets});

  /// The Insider got strictly the most votes.
  final bool caught;

  /// Votes received per target id.
  final Map<int, int> tally;
  final int insiderVotes;

  /// Everyone tied on the highest vote count.
  final List<int> topTargets;

  int get totalVotes => tally.values.fold(0, (a, b) => a + b);

  /// Votes for anyone other than the Insider.
  int get otherVotes => totalVotes - insiderVotes;

  bool get topIsTie => topTargets.length > 1;
}

/// The player the group voted out. The group agrees on one name and the
/// Master enters it, so a round has a single vote with the Master as voter.
/// Rounds saved before the group vote may hold one vote per player; for
/// those, the clear top target counts as the group's pick (null on a tie).
int? groupVerdict(List<Vote> votes, {required int masterId}) {
  if (votes.length == 1) return votes.first.targetId;
  final r = resolveVote(votes, -1);
  return r.topTargets.length == 1 ? r.topTargets.first : null;
}

/// Caught means the Insider has strictly the most votes. With the group vote
/// there is one vote, so caught means the group voted out the Insider.
/// (A tie, possible only in rounds saved before the group vote, is not caught.)
VoteResult resolveVote(List<Vote> votes, int insiderId) {
  final tally = <int, int>{};
  for (final v in votes) {
    tally[v.targetId] = (tally[v.targetId] ?? 0) + 1;
  }
  final top = tally.values.fold(0, (a, b) => a > b ? a : b);
  final topTargets = tally.entries.where((e) => e.value == top && top > 0).map((e) => e.key).toList()..sort();
  final insiderVotes = tally[insiderId] ?? 0;
  final caught = insiderVotes > 0 && topTargets.length == 1 && topTargets.first == insiderId;
  return VoteResult(caught: caught, tally: tally, insiderVotes: insiderVotes, topTargets: topTargets);
}
