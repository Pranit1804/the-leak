import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'trip_dao.g.dart';

@DriftAccessor(tables: [Trips, Players])
class TripDao extends DatabaseAccessor<AppDatabase> with _$TripDaoMixin {
  TripDao(super.db);

  Future<int> insertTrip(TripsCompanion trip) => into(trips).insert(trip);

  Future<TripRow?> getTrip(int id) => (select(trips)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<TripRow?> watchTrip(int id) => (select(trips)..where((t) => t.id.equals(id))).watchSingleOrNull();

  SimpleSelectStatement<$TripsTable, TripRow> _open() => select(trips)
    ..where((t) => t.endedAt.isNull())
    ..orderBy([(t) => OrderingTerm.desc(t.createdAt), (t) => OrderingTerm.desc(t.id)])
    ..limit(1);

  Future<TripRow?> openTrip() => _open().getSingleOrNull();

  Stream<TripRow?> watchOpenTrip() => _open().watchSingleOrNull();

  SimpleSelectStatement<$TripsTable, TripRow> _latest() => select(trips)
    ..orderBy([(t) => OrderingTerm.desc(t.createdAt), (t) => OrderingTerm.desc(t.id)])
    ..limit(1);

  Stream<TripRow?> watchLatestTrip() => _latest().watchSingleOrNull();

  Future<void> updateTrip(int id, TripsCompanion data) => (update(trips)..where((t) => t.id.equals(id))).write(data);

  Future<int> insertPlayer(PlayersCompanion p) => into(players).insert(p);

  Future<void> updatePlayer(int id, PlayersCompanion data) => (update(players)..where((p) => p.id.equals(id))).write(data);

  Future<void> deletePlayer(int id) => (delete(players)..where((p) => p.id.equals(id))).go();

  SimpleSelectStatement<$PlayersTable, PlayerRow> _players(int tripId) => select(players)
    ..where((p) => p.tripId.equals(tripId))
    ..orderBy([(p) => OrderingTerm.asc(p.seatOrder), (p) => OrderingTerm.asc(p.id)]);

  /// All players of a trip, removed ones included, in seat order.
  Future<List<PlayerRow>> playersOf(int tripId) => _players(tripId).get();

  Stream<List<PlayerRow>> watchPlayers(int tripId) => _players(tripId).watch();
}
