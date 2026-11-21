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

/// Caught means the Insider has strictly the most votes. A tie is not caught.
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
