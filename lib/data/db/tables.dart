import 'package:drift/drift.dart';

/// Tables from docs/TECH_SPEC.md section 4.
@DataClassName('TripRow')
class Trips extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get questionLimit => integer()();
  IntColumn get discussionSeconds => integer()();
  BoolColumn get alertsOn => boolean()();
  BoolColumn get lastCarMode => boolean().withDefault(const Constant(false))();
}

@DataClassName('PlayerRow')
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer().references(Trips, #id)();
  TextColumn get name => text()();
  IntColumn get seatOrder => integer()();
  BoolColumn get canDrive => boolean()();
  DateTimeColumn get removedAt => dateTime().nullable()();
}

@DataClassName('RoundRow')
class Rounds extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer().references(Trips, #id)();
  IntColumn get number => integer()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  BoolColumn get carMode => boolean()();

  /// Null when Car mode is off.
  IntColumn get driverId => integer().nullable()();
  IntColumn get masterId => integer()();
  IntColumn get insiderId => integer()();
  TextColumn get wordId => text()();
  TextColumn get captionId => text().nullable()();

  /// A `RoundPhase` name.
  TextColumn get phase => text()();
  IntColumn get handoutIndex => integer().withDefault(const Constant(0))();
  IntColumn get voteIndex => integer().withDefault(const Constant(0))();
  IntColumn get questionsUsed => integer().withDefault(const Constant(0))();

  /// `caught` / `not_caught` / `not_found` / `abandoned`; null until the round ends.
  TextColumn get outcome => text().nullable()();
  IntColumn get guessedById => integer().nullable()();

  /// When the discussion countdown reaches zero, so it survives an app kill.
  DateTimeColumn get discussionEndsAt => dateTime().nullable()();
}

@DataClassName('VoteRow')
class Votes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get roundId => integer().references(Rounds, #id)();
  IntColumn get voterId => integer()();
  IntColumn get targetId => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {roundId, voterId},
      ];
}

/// One row per participant of a round (0 until the reveal), so "rounds
/// played" and removed players' stats come straight from here.
@DataClassName('RoundScoreRow')
class RoundScores extends Table {
  IntColumn get roundId => integer().references(Rounds, #id)();
  IntColumn get playerId => integer()();
  IntColumn get points => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {roundId, playerId};
}

@DataClassName('UsedWordRow')
class UsedWords extends Table {
  IntColumn get tripId => integer().references(Trips, #id)();
  TextColumn get wordId => text()();

  @override
  Set<Column> get primaryKey => {tripId, wordId};
}

@DataClassName('UsedCaptionRow')
class UsedCaptions extends Table {
  IntColumn get tripId => integer().references(Trips, #id)();
  TextColumn get captionId => text()();

  @override
  Set<Column> get primaryKey => {tripId, captionId};
}
