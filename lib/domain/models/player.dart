class Player {
  const Player({required this.id, required this.name, required this.seatOrder, required this.canDrive, this.removedAt});

  final int id;
  final String name;
  final int seatOrder;
  final bool canDrive;

  /// Set when a player is removed between rounds; they keep their past stats.
  final DateTime? removedAt;

  bool get active => removedAt == null;

  @override
  String toString() => 'Player($id, seat $seatOrder)';
}
