import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/data/db/app_database.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('all tables exist and a trip with players round-trips', () async {
    final tripId = await db.tripDao.insertTrip(TripsCompanion.insert(
      name: 'Test trip',
      createdAt: DateTime(2026, 11, 20),
      questionLimit: 20,
      discussionSeconds: 120,
      alertsOn: true,
    ));
    for (var i = 0; i < 4; i++) {
      await db.tripDao.insertPlayer(PlayersCompanion.insert(tripId: tripId, name: 'P$i', seatOrder: i, canDrive: i == 0));
    }
    expect((await db.tripDao.playersOf(tripId)).length, 4);
    expect((await db.tripDao.openTrip())?.id, tripId);
    expect(await db.roundDao.openRound(), isNull);
    final tables = db.allTables.map((t) => t.actualTableName).toSet();
    expect(tables, containsAll(['trips', 'players', 'rounds', 'votes', 'round_scores', 'used_words', 'used_captions']));
  });

  test('a voter can vote only once per round', () async {
    final tripId = await db.tripDao.insertTrip(TripsCompanion.insert(
        name: 'T', createdAt: DateTime(2026), questionLimit: 20, discussionSeconds: 120, alertsOn: true));
    final roundId = await db.roundDao.insertRound(RoundsCompanion.insert(
      tripId: tripId,
      number: 1,
      startedAt: DateTime(2026),
      carMode: false,
      masterId: 1,
      insiderId: 2,
      wordId: 'x_001',
      phase: 'voting',
    ));
    await db.roundDao.insertVote(VotesCompanion.insert(roundId: roundId, voterId: 1, targetId: 2));
    expect(() => db.roundDao.insertVote(VotesCompanion(roundId: Value(roundId), voterId: const Value(1), targetId: const Value(3))),
        throwsA(isA<SqliteException>()));
  });
}
