class Vote {
  const Vote({required this.voterId, required this.targetId});

  final int voterId;
  final int targetId;

  @override
  bool operator ==(Object other) => other is Vote && other.voterId == voterId && other.targetId == targetId;

  @override
  int get hashCode => Object.hash(voterId, targetId);

  @override
  String toString() => 'Vote($voterId→$targetId)';
}
