import 'package:drift/drift.dart';

import '../../domain/models/outcome.dart';
import '../../domain/models/round.dart';
import '../../domain/models/round_phase.dart';
import '../../domain/models/vote.dart';
import '../db/app_database.dart';

class RoundRepository {
  RoundRepository(this._db);

  final AppDatabase _db;

  /// Creates a round in `handout`, its participants' score rows (0 until the
  /// reveal) and marks the word used, in one transaction.
  Future<Round> createRound({
    required int tripId,
    required int number,
    required DateTime startedAt,
    required bool carMode,
    int? driverId,
    required int masterId,
    required int insiderId,
    required String wordId,
    required List<int> participantIds,
    Set<String> clearUsedWordIds = const {},
  }) {
    return _db.transaction(() async {
      final id = await _db.roundDao.insertRound(RoundsCompanion.insert(
        tripId: tripId,
        number: number,
        startedAt: startedAt,
        carMode: carMode,
        driverId: Value(carMode ? driverId : null),
        masterId: masterId,
        insiderId: insiderId,
        wordId: wordId,
        phase: RoundPhase.handout.name,
      ));
      await _db.roundDao.insertScores([for (final p in participantIds) RoundScoresCompanion.insert(roundId: id, playerId: p)]);
      if (clearUsedWordIds.isNotEmpty) await _db.roundDao.clearUsedWords(tripId, clearUsedWordIds);
      await _db.roundDao.addUsedWord(tripId, wordId);
      await _db.tripDao.updateTrip(tripId, TripsCompanion(lastCarMode: Value(carMode)));
      return (await getRound(id))!;
    });
  }

  Future<Round?> getRound(int id) async {
    final row = await _db.roundDao.getRound(id);
    if (row == null) return null;
    return _toRound(row, await _participants(row));
  }

  Future<List<int>> _participants(RoundRow row) async {
    final scores = await _db.roundDao.scoresOf(row.id);
    final players = await _db.tripDao.playersOf(row.tripId);
    final seat = {for (final p in players) p.id: p.seatOrder};
    final ids = scores.map((s) => s.playerId).toList()
      ..sort((a, b) {
        final c = (seat[a] ?? 0).compareTo(seat[b] ?? 0);
        return c != 0 ? c : a.compareTo(b);
      });
    return ids;
  }

  Round _toRound(RoundRow r, List<int> participants) => Round(
        id: r.id,
        tripId: r.tripId,
        number: r.number,
        startedAt: r.startedAt,
        endedAt: r.endedAt,
        carMode: r.carMode,
        driverId: r.driverId,
        masterId: r.masterId,
        insiderId: r.insiderId,
        wordId: r.wordId,
        captionId: r.captionId,
        phase: RoundPhase.parse(r.phase),
        handoutIndex: r.handoutIndex,
        voteIndex: r.voteIndex,
        questionsUsed: r.questionsUsed,
        outcome: r.outcome == null ? null : Outcome.parse(r.outcome!),
        guessedById: r.guessedById,
        discussionEndsAt: r.discussionEndsAt,
        participantIds: participants,
      );

  RoundsCompanion _companion(Round r) => RoundsCompanion(
        phase: Value(r.phase.name),
        handoutIndex: Value(r.handoutIndex),
        voteIndex: Value(r.voteIndex),
        questionsUsed: Value(r.questionsUsed),
        outcome: Value(r.outcome?.db),
        guessedById: Value(r.guessedById),
        discussionEndsAt: Value(r.discussionEndsAt),
        captionId: Value(r.captionId),
        endedAt: Value(r.endedAt),
      );

  /// Writes the round's mutable state (phase, indexes, counter, outcome…).
  Future<void> save(Round r) => _db.roundDao.updateRound(r.id, _companion(r));

  /// Saves the reveal: outcome, points, caption and the round state together.
  Future<void> saveReveal(Round next, Map<int, int> points, {Vote? lastVote, Set<String> clearUsedCaptionIds = const {}}) =>
      _db.transaction(() async {
        if (lastVote != null) {
          // The group vote is the only vote of a round; clear any left from an
          // older build that took one vote per player.
          await _db.roundDao.deleteVotes(next.id);
          await _db.roundDao.insertVote(VotesCompanion.insert(roundId: next.id, voterId: lastVote.voterId, targetId: lastVote.targetId));
        }
        for (final e in points.entries) {
          await _db.roundDao.setScore(next.id, e.key, e.value);
        }
        if (clearUsedCaptionIds.isNotEmpty) await _db.roundDao.clearUsedCaptions(next.tripId, clearUsedCaptionIds);
        if (next.captionId != null) await _db.roundDao.addUsedCaption(next.tripId, next.captionId!);
        await save(next);
      });

  /// Abandons a round: nothing is scored.
  Future<void> abandon(Round next) => _db.transaction(() async {
        for (final id in next.participantIds) {
          await _db.roundDao.setScore(next.id, id, 0);
        }
        await save(next);
      });

  Future<List<Vote>> votes(int roundId) async =>
      (await _db.roundDao.votesOf(roundId)).map((v) => Vote(voterId: v.voterId, targetId: v.targetId)).toList();

  Future<Round?> openRoundOfTrip(int tripId) async {
    final r = await _db.roundDao.openRoundOfTrip(tripId);
    return r == null ? null : getRound(r.id);
  }

  Future<Round?> lastRound(int tripId) async {
    final r = await _db.roundDao.lastRound(tripId);
    return r == null ? null : getRound(r.id);
  }

  Future<Set<String>> usedWordIds(int tripId) => _db.roundDao.usedWordIds(tripId);

  Future<Set<String>> usedCaptionIds(int tripId) => _db.roundDao.usedCaptionIds(tripId);

  /// Every round of a trip with votes and points.
  Future<List<RoundRecord>> records(int tripId) async {
    final rows = await _db.roundDao.roundsOf(tripId);
    final votes = await _db.roundDao.votesOfTrip(tripId);
    final scores = await _db.roundDao.scoresOfTrip(tripId);
    final players = await _db.tripDao.playersOf(tripId);
    final seat = {for (final p in players) p.id: p.seatOrder};
    return [
      for (final r in rows)
        () {
          final s = scores.where((x) => x.roundId == r.id).toList()
            ..sort((a, b) => (seat[a.playerId] ?? 0).compareTo(seat[b.playerId] ?? 0));
          return RoundRecord(
            round: _toRound(r, s.map((x) => x.playerId).toList()),
            votes: votes.where((v) => v.roundId == r.id).map((v) => Vote(voterId: v.voterId, targetId: v.targetId)).toList(),
            points: {for (final x in s) x.playerId: x.points},
          );
        }(),
    ];
  }

  /// Re-emits [records] whenever the trip's rounds change.
  Stream<List<RoundRecord>> watchRecords(int tripId) => _db.roundDao.watchRoundsOf(tripId).asyncMap((_) => records(tripId));
}
