import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/domain/engine/role_assigner.dart';
import 'package:the_leak/domain/models/player.dart';

import 'helpers.dart';

/// Independent reference for "rotate in seat order, skipping the driver".
int expectedMaster(List<Player> players, bool carMode, int? driver, int? previousMaster) {
  final eligible = players.where((p) => p.active && !(carMode && p.id == driver)).toList()
    ..sort((a, b) => a.seatOrder.compareTo(b.seatOrder));
  if (previousMaster == null) return eligible.first.id;
  final prevSeat = players.firstWhere((p) => p.id == previousMaster).seatOrder;
  return eligible.firstWhere((p) => p.seatOrder > prevSeat, orElse: () => eligible.first).id;
}

void main() {
  group('assignRoles, 1,000 seeded rounds', () {
    test('driver never Master or Insider, Insider never repeats, Master rotates in seat order', () {
      final rng = Random(20261120);
      var rounds = 0;
      var carRounds = 0;
      while (rounds < 1000) {
        // A fresh trip every 25 rounds with 4–8 players and 1–3 drivers.
        final n = 4 + rng.nextInt(5);
        final drivers = <int>{1 + rng.nextInt(n), 1 + rng.nextInt(n), 1 + rng.nextInt(n)};
        final players = makePlayers(n, drivers: drivers);
        int? prevMaster;
        int? prevInsider;
        for (var r = 0; r < 25 && rounds < 1000; r++, rounds++) {
          final carMode = rng.nextBool();
          final driver = carMode ? drivers.elementAt(rng.nextInt(drivers.length)) : null;
          final a = assignRoles(
            players: players,
            carMode: carMode,
            driverId: driver,
            previousInsiderId: prevInsider,
            previousMasterId: prevMaster,
            rng: Random(rounds),
          );
          if (carMode) {
            carRounds++;
            expect(a.masterId, isNot(driver), reason: 'round $rounds: driver became Master');
            expect(a.insiderId, isNot(driver), reason: 'round $rounds: driver became Insider');
          }
          expect(a.insiderId, isNot(a.masterId));
          if (prevInsider != null) expect(a.insiderId, isNot(prevInsider), reason: 'round $rounds: Insider repeated');
          expect(a.masterId, expectedMaster(players, carMode, driver, prevMaster), reason: 'round $rounds: Master out of seat order');
          prevMaster = a.masterId;
          prevInsider = a.insiderId;
        }
      }
      expect(rounds, 1000);
      expect(carRounds, greaterThan(300));
    });

    test('same seed gives the same assignment', () {
      final players = makePlayers(6, drivers: {1});
      final a = assignRoles(players: players, carMode: true, driverId: 1, rng: Random(7));
      final b = assignRoles(players: players, carMode: true, driverId: 1, rng: Random(7));
      expect([a.masterId, a.insiderId], [b.masterId, b.insiderId]);
    });
  });

  group('Master rotation', () {
    test('round one: the first eligible player in seat order', () {
      final players = makePlayers(5, drivers: {1});
      expect(nextMaster(players, carMode: false), 1);
      expect(nextMaster(players, carMode: true, driverId: 1), 2);
    });

    test('wraps round and skips the driver', () {
      final players = makePlayers(5, drivers: {1, 3});
      expect(nextMaster(players, carMode: false, previousMasterId: 5), 1);
      expect(nextMaster(players, carMode: true, driverId: 1, previousMasterId: 5), 2);
      expect(nextMaster(players, carMode: true, driverId: 3, previousMasterId: 2), 4);
    });

    test('Car mode off: everyone takes a turn as Master', () {
      final players = makePlayers(6);
      int? prev;
      final seen = <int>[];
      for (var i = 0; i < 6; i++) {
        prev = nextMaster(players, carMode: false, previousMasterId: prev);
        seen.add(prev);
      }
      expect(seen, [1, 2, 3, 4, 5, 6]);
    });

    test('a removed previous Master still anchors the rotation', () {
      final players = makePlayers(6, removed: {3});
      expect(nextMaster(players, carMode: false, previousMasterId: 3), 4);
      expect(nextMaster(players, carMode: false, previousMasterId: 2), 4);
    });
  });

  group('Insider', () {
    test('Car mode off: every non-Master player can be the Insider', () {
      final players = makePlayers(5);
      final seen = <int>{};
      for (var s = 0; s < 200; s++) {
        seen.add(assignRoles(players: players, carMode: false, previousMasterId: 5, rng: Random(s)).insiderId);
      }
      expect(seen, {2, 3, 4, 5});
    });

    test('smallest Car mode game: Insider is the passenger who is neither Master nor last Insider', () {
      final players = makePlayers(4, drivers: {1});
      // Eligible 2,3,4; previous Master 2 gives Master 3; previous Insider 4 leaves only 2.
      for (var s = 0; s < 50; s++) {
        final a = assignRoles(
            players: players, carMode: true, driverId: 1, previousMasterId: 2, previousInsiderId: 4, rng: Random(s));
        expect(a.masterId, 3);
        expect(a.insiderId, 2);
      }
    });
  });

  group('checkRoundSetup', () {
    test('4 to 8 players', () {
      expect(checkRoundSetup(makePlayers(3), carMode: false), contains(SetupProblem.tooFewPlayers));
      expect(checkRoundSetup(makePlayers(4), carMode: false), isEmpty);
      expect(checkRoundSetup(makePlayers(8), carMode: false), isEmpty);
      expect(checkRoundSetup(makePlayers(9), carMode: false), contains(SetupProblem.tooManyPlayers));
      expect(checkRoundSetup(makePlayers(5, removed: {1, 2}), carMode: false), contains(SetupProblem.tooFewPlayers));
    });

    test('Car mode needs a driver who can drive and at least 3 non-driving players', () {
      final players = makePlayers(4, drivers: {1});
      expect(checkRoundSetup(players, carMode: true), contains(SetupProblem.noDriverChosen));
      expect(checkRoundSetup(players, carMode: true, driverId: 2), contains(SetupProblem.driverNotEligible));
      expect(checkRoundSetup(players, carMode: true, driverId: 1), isEmpty);
      expect(checkRoundSetup(makePlayers(4, drivers: {1}, removed: {4}), carMode: true, driverId: 1),
          containsAll([SetupProblem.tooFewPlayers, SetupProblem.tooFewPassengers]));
    });

    test('assignRoles refuses an invalid setup', () {
      expect(() => assignRoles(players: makePlayers(3), carMode: false, rng: Random(1)), throwsArgumentError);
    });
  });
}
