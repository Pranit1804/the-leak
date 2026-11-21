import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'round_dao.g.dart';

@DriftAccessor(tables: [Rounds, Votes, RoundScores, UsedWords, UsedCaptions])
class RoundDao extends DatabaseAccessor<AppDatabase> with _$RoundDaoMixin {
  RoundDao(super.db);

  Future<int> insertRound(RoundsCompanion r) => into(rounds).insert(r);

  Future<RoundRow?> getRound(int id) => (select(rounds)..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<void> updateRound(int id, RoundsCompanion data) => (update(rounds)..where((r) => r.id.equals(id))).write(data);

  /// The most recent round that is not `done`, if any.
  Future<RoundRow?> openRound() => (select(rounds)
        ..where((r) => r.phase.equals('done').not())
        ..orderBy([(r) => OrderingTerm.desc(r.id)])
        ..limit(1))
      .getSingleOrNull();

  Future<RoundRow?> openRoundOfTrip(int tripId) => (select(rounds)
        ..where((r) => r.tripId.equals(tripId) & r.phase.equals('done').not())
        ..orderBy([(r) => OrderingTerm.desc(r.id)])
        ..limit(1))
      .getSingleOrNull();

  SimpleSelectStatement<$RoundsTable, RoundRow> _ofTrip(int tripId) => select(rounds)
    ..where((r) => r.tripId.equals(tripId))
    ..orderBy([(r) => OrderingTerm.asc(r.id)]);

  Future<List<RoundRow>> roundsOf(int tripId) => _ofTrip(tripId).get();

  Stream<List<RoundRow>> watchRoundsOf(int tripId) => _ofTrip(tripId).watch();

  Future<RoundRow?> lastRound(int tripId) => (select(rounds)
        ..where((r) => r.tripId.equals(tripId))
        ..orderBy([(r) => OrderingTerm.desc(r.id)])
        ..limit(1))
      .getSingleOrNull();

  Future<void> insertVote(VotesCompanion v) => into(votes).insert(v);

  Future<List<VoteRow>> votesOf(int roundId) =>
      (select(votes)..where((v) => v.roundId.equals(roundId))..orderBy([(v) => OrderingTerm.asc(v.id)])).get();

  Future<List<VoteRow>> votesOfTrip(int tripId) {
    final q = select(votes).join([innerJoin(rounds, rounds.id.equalsExp(votes.roundId))])
      ..where(rounds.tripId.equals(tripId))
      ..orderBy([OrderingTerm.asc(votes.id)]);
    return q.map((row) => row.readTable(votes)).get();
  }

  Future<void> insertScores(List<RoundScoresCompanion> rows) => batch((b) => b.insertAll(roundScores, rows));

  Future<void> setScore(int roundId, int playerId, int points) =>
      (update(roundScores)..where((s) => s.roundId.equals(roundId) & s.playerId.equals(playerId)))
          .write(RoundScoresCompanion(points: Value(points)));

  Future<List<RoundScoreRow>> scoresOf(int roundId) => (select(roundScores)..where((s) => s.roundId.equals(roundId))).get();

  Future<List<RoundScoreRow>> scoresOfTrip(int tripId) {
    final q = select(roundScores).join([innerJoin(rounds, rounds.id.equalsExp(roundScores.roundId))])
      ..where(rounds.tripId.equals(tripId));
    return q.map((row) => row.readTable(roundScores)).get();
  }

  Future<Set<String>> usedWordIds(int tripId) async =>
      (await (select(usedWords)..where((u) => u.tripId.equals(tripId))).get()).map((u) => u.wordId).toSet();

  Future<void> addUsedWord(int tripId, String wordId) =>
      into(usedWords).insert(UsedWordsCompanion.insert(tripId: tripId, wordId: wordId), mode: InsertMode.insertOrIgnore);

  Future<void> clearUsedWords(int tripId, Iterable<String> wordIds) =>
      (delete(usedWords)..where((u) => u.tripId.equals(tripId) & u.wordId.isIn(wordIds))).go();

  Future<Set<String>> usedCaptionIds(int tripId) async =>
      (await (select(usedCaptions)..where((u) => u.tripId.equals(tripId))).get()).map((u) => u.captionId).toSet();

  Future<void> addUsedCaption(int tripId, String captionId) => into(usedCaptions)
      .insert(UsedCaptionsCompanion.insert(tripId: tripId, captionId: captionId), mode: InsertMode.insertOrIgnore);

  Future<void> clearUsedCaptions(int tripId, Iterable<String> captionIds) =>
      (delete(usedCaptions)..where((u) => u.tripId.equals(tripId) & u.captionId.isIn(captionIds))).go();
}
