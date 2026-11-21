import 'dart:math';

import '../models/player.dart';

/// Minimum and maximum players (PRD section 3.2).
const minPlayers = 4;
const maxPlayers = 8;

/// Car mode needs a Master, an Insider and one non-driving Common.
const minNonDrivingPlayers = 3;

class RoleAssignment {
  const RoleAssignment({required this.masterId, required this.insiderId});

  final int masterId;
  final int insiderId;
}

enum SetupProblem { tooFewPlayers, tooManyPlayers, noDriverChosen, driverNotEligible, tooFewPassengers }

/// Active players in seat order.
List<Player> activeInSeatOrder(List<Player> players) {
  final list = players.where((p) => p.active).toList()
    ..sort((a, b) => a.seatOrder != b.seatOrder ? a.seatOrder.compareTo(b.seatOrder) : a.id.compareTo(b.id));
  return list;
}

/// Players who can be Master or Insider: everyone active, minus the Car mode driver.
List<Player> eligiblePlayers(List<Player> players, {required bool carMode, int? driverId}) =>
    activeInSeatOrder(players).where((p) => !(carMode && p.id == driverId)).toList();

/// What stops a round from starting, if anything.
List<SetupProblem> checkRoundSetup(List<Player> players, {required bool carMode, int? driverId}) {
  final active = activeInSeatOrder(players);
  final problems = <SetupProblem>[];
  if (active.length < minPlayers) problems.add(SetupProblem.tooFewPlayers);
  if (active.length > maxPlayers) problems.add(SetupProblem.tooManyPlayers);
  if (carMode) {
    if (driverId == null) {
      problems.add(SetupProblem.noDriverChosen);
    } else if (!active.any((p) => p.id == driverId && p.canDrive)) {
      problems.add(SetupProblem.driverNotEligible);
    }
    if (eligiblePlayers(players, carMode: true, driverId: driverId).length < minNonDrivingPlayers) {
      problems.add(SetupProblem.tooFewPassengers);
    }
  }
  return problems;
}

/// The Master rotates through eligible players in seat order: the first
/// eligible player in round one, then the next eligible player after the
/// previous Master (wrapping round), skipping the Car mode driver.
///
/// [players] should include removed players so a removed previous Master's
/// seat still anchors the rotation.
int nextMaster(List<Player> players, {required bool carMode, int? driverId, int? previousMasterId}) {
  final eligible = eligiblePlayers(players, carMode: carMode, driverId: driverId);
  if (eligible.isEmpty) throw StateError('No eligible players');
  if (previousMasterId == null) return eligible.first.id;
  Player? previous;
  for (final p in players) {
    if (p.id == previousMasterId) previous = p;
  }
  if (previous == null) return eligible.first.id;
  final prev = previous;
  for (final p in eligible) {
    if (p.seatOrder > prev.seatOrder || (p.seatOrder == prev.seatOrder && p.id > prev.id)) return p.id;
  }
  return eligible.first.id;
}

/// Picks the Master and Insider for a round (PRD section 2.1).
///
/// - Car mode on: the driver is never Master or Insider.
/// - The Master follows [nextMaster].
/// - The Insider is random among eligible players other than the Master and
///   is never the previous round's Insider.
RoleAssignment assignRoles({
  required List<Player> players,
  required bool carMode,
  int? driverId,
  int? previousInsiderId,
  int? previousMasterId,
  required Random rng,
}) {
  final problems = checkRoundSetup(players, carMode: carMode, driverId: driverId);
  if (problems.isNotEmpty) throw ArgumentError('Round cannot start: $problems');
  final masterId = nextMaster(players, carMode: carMode, driverId: driverId, previousMasterId: previousMasterId);
  final eligible = eligiblePlayers(players, carMode: carMode, driverId: driverId);
  var candidates = eligible.where((p) => p.id != masterId && p.id != previousInsiderId).toList();
  if (candidates.isEmpty) candidates = eligible.where((p) => p.id != masterId).toList();
  final insider = candidates[rng.nextInt(candidates.length)];
  return RoleAssignment(masterId: masterId, insiderId: insider.id);
}
