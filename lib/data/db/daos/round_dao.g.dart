// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round_dao.dart';

// ignore_for_file: type=lint
mixin _$RoundDaoMixin on DatabaseAccessor<AppDatabase> {
  $TripsTable get trips => attachedDatabase.trips;
  $RoundsTable get rounds => attachedDatabase.rounds;
  $VotesTable get votes => attachedDatabase.votes;
  $RoundScoresTable get roundScores => attachedDatabase.roundScores;
  $UsedWordsTable get usedWords => attachedDatabase.usedWords;
  $UsedCaptionsTable get usedCaptions => attachedDatabase.usedCaptions;
  RoundDaoManager get managers => RoundDaoManager(this);
}

class RoundDaoManager {
  final _$RoundDaoMixin _db;
  RoundDaoManager(this._db);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db.attachedDatabase, _db.trips);
  $$RoundsTableTableManager get rounds =>
      $$RoundsTableTableManager(_db.attachedDatabase, _db.rounds);
  $$VotesTableTableManager get votes =>
      $$VotesTableTableManager(_db.attachedDatabase, _db.votes);
  $$RoundScoresTableTableManager get roundScores =>
      $$RoundScoresTableTableManager(_db.attachedDatabase, _db.roundScores);
  $$UsedWordsTableTableManager get usedWords =>
      $$UsedWordsTableTableManager(_db.attachedDatabase, _db.usedWords);
  $$UsedCaptionsTableTableManager get usedCaptions =>
      $$UsedCaptionsTableTableManager(_db.attachedDatabase, _db.usedCaptions);
}
