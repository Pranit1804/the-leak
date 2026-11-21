import 'package:drift/drift.dart';

import '../../domain/models/player.dart';
import '../../domain/models/trip.dart';
import '../db/app_database.dart';

/// A player as edited on Trip setup. [id] is null for a new player.
class PlayerDraft {
  const PlayerDraft({this.id, required this.name, required this.canDrive});

  final int? id;
  final String name;
  final bool canDrive;

  PlayerDraft copyWith({String? name, bool? canDrive}) => PlayerDraft(id: id, name: name ?? this.name, canDrive: canDrive ?? this.canDrive);
}

Trip tripFromRow(TripRow r) => Trip(
      id: r.id,
      name: r.name,
      createdAt: r.createdAt,
      endedAt: r.endedAt,
      questionLimit: r.questionLimit,
      discussionSeconds: r.discussionSeconds,
      alertsOn: r.alertsOn,
      lastCarMode: r.lastCarMode,
    );

Player playerFromRow(PlayerRow r) =>
    Player(id: r.id, name: r.name, seatOrder: r.seatOrder, canDrive: r.canDrive, removedAt: r.removedAt);

class TripRepository {
  TripRepository(this._db);

  final AppDatabase _db;

  Future<int> createTrip({required String name, required List<PlayerDraft> players, required GameSettings settings, DateTime? now}) {
    return _db.transaction(() async {
      final id = await _db.tripDao.insertTrip(TripsCompanion.insert(
        name: name,
        createdAt: now ?? DateTime.now(),
        questionLimit: settings.questionLimit,
        discussionSeconds: settings.discussionSeconds,
        alertsOn: settings.alertsOn,
      ));
      for (var i = 0; i < players.length; i++) {
        await _db.tripDao.insertPlayer(
            PlayersCompanion.insert(tripId: id, name: players[i].name, seatOrder: i, canDrive: players[i].canDrive));
      }
      return id;
    });
  }

  /// Saves edited players between rounds. Removed players who have played
  /// keep their row (and stats) with `removedAt`; others are deleted.
  Future<void> updateTrip(int tripId, {required String name, required List<PlayerDraft> players, DateTime? now}) {
    return _db.transaction(() async {
      await _db.tripDao.updateTrip(tripId, TripsCompanion(name: Value(name)));
      final existing = await _db.tripDao.playersOf(tripId);
      final keptIds = players.map((p) => p.id).whereType<int>().toSet();
      final played = (await _db.roundDao.scoresOfTrip(tripId)).map((s) => s.playerId).toSet();
      var seat = 0;
      for (final p in players) {
        if (p.id == null) {
          await _db.tripDao.insertPlayer(PlayersCompanion.insert(tripId: tripId, name: p.name, seatOrder: seat, canDrive: p.canDrive));
        } else {
          await _db.tripDao.updatePlayer(
              p.id!, PlayersCompanion(name: Value(p.name), seatOrder: Value(seat), canDrive: Value(p.canDrive), removedAt: const Value(null)));
        }
        seat++;
      }
      for (final old in existing.where((e) => e.removedAt == null && !keptIds.contains(e.id))) {
        if (played.contains(old.id)) {
          await _db.tripDao.updatePlayer(old.id, PlayersCompanion(removedAt: Value(now ?? DateTime.now()), seatOrder: Value(seat++)));
        } else {
          await _db.tripDao.deletePlayer(old.id);
        }
      }
    });
  }

  Future<Trip?> getTrip(int id) async {
    final r = await _db.tripDao.getTrip(id);
    return r == null ? null : tripFromRow(r);
  }

  Stream<Trip?> watchTrip(int id) => _db.tripDao.watchTrip(id).map((r) => r == null ? null : tripFromRow(r));

  Future<Trip?> openTrip() async {
    final r = await _db.tripDao.openTrip();
    return r == null ? null : tripFromRow(r);
  }

  Stream<Trip?> watchOpenTrip() => _db.tripDao.watchOpenTrip().map((r) => r == null ? null : tripFromRow(r));

  Stream<Trip?> watchLatestTrip() => _db.tripDao.watchLatestTrip().map((r) => r == null ? null : tripFromRow(r));

  /// All players, removed ones included, in seat order.
  Future<List<Player>> players(int tripId) async => (await _db.tripDao.playersOf(tripId)).map(playerFromRow).toList();

  Stream<List<Player>> watchPlayers(int tripId) => _db.tripDao.watchPlayers(tripId).map((rows) => rows.map(playerFromRow).toList());

  Future<void> endTrip(int tripId, {DateTime? now}) =>
      _db.tripDao.updateTrip(tripId, TripsCompanion(endedAt: Value(now ?? DateTime.now())));

  Future<void> setLastCarMode(int tripId, bool on) => _db.tripDao.updateTrip(tripId, TripsCompanion(lastCarMode: Value(on)));

  Future<void> applySettings(int tripId, GameSettings s) => _db.tripDao.updateTrip(
        tripId,
        TripsCompanion(questionLimit: Value(s.questionLimit), discussionSeconds: Value(s.discussionSeconds), alertsOn: Value(s.alertsOn)),
      );
}
