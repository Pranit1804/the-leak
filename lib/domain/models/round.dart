import 'outcome.dart';
import 'round_phase.dart';
import 'vote.dart';

const Object _unset = Object();

/// A round as stored, plus the ids of the players who took part.
class Round {
  const Round({
    required this.id,
    required this.tripId,
    required this.number,
    required this.startedAt,
    this.endedAt,
    required this.carMode,
    this.driverId,
    required this.masterId,
    required this.insiderId,
    required this.wordId,
    this.captionId,
    required this.phase,
    this.handoutIndex = 0,
    this.voteIndex = 0,
    this.questionsUsed = 0,
    this.outcome,
    this.guessedById,
    this.discussionEndsAt,
    required this.participantIds,
  });

  final int id;
  final int tripId;
  final int number;
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool carMode;
  final int? driverId;
  final int masterId;
  final int insiderId;
  final String wordId;
  final String? captionId;
  final RoundPhase phase;
  final int handoutIndex;
  final int voteIndex;
  final int questionsUsed;
  final Outcome? outcome;
  final int? guessedById;
  final DateTime? discussionEndsAt;

  /// Players in this round, in seat order (driver included).
  final List<int> participantIds;

  /// The current driver when Car mode is on.
  int? get activeDriverId => carMode ? driverId : null;

  Round copyWith({
    RoundPhase? phase,
    int? handoutIndex,
    int? voteIndex,
    int? questionsUsed,
    Object? endedAt = _unset,
    Object? captionId = _unset,
    Object? outcome = _unset,
    Object? guessedById = _unset,
    Object? discussionEndsAt = _unset,
  }) =>
      Round(
        id: id,
        tripId: tripId,
        number: number,
        startedAt: startedAt,
        endedAt: identical(endedAt, _unset) ? this.endedAt : endedAt as DateTime?,
        carMode: carMode,
        driverId: driverId,
        masterId: masterId,
        insiderId: insiderId,
        wordId: wordId,
        captionId: identical(captionId, _unset) ? this.captionId : captionId as String?,
        phase: phase ?? this.phase,
        handoutIndex: handoutIndex ?? this.handoutIndex,
        voteIndex: voteIndex ?? this.voteIndex,
        questionsUsed: questionsUsed ?? this.questionsUsed,
        outcome: identical(outcome, _unset) ? this.outcome : outcome as Outcome?,
        guessedById: identical(guessedById, _unset) ? this.guessedById : guessedById as int?,
        discussionEndsAt: identical(discussionEndsAt, _unset) ? this.discussionEndsAt : discussionEndsAt as DateTime?,
        participantIds: participantIds,
      );
}

/// A finished (or revealing) round with its votes and points, used by stats.
class RoundRecord {
  const RoundRecord({required this.round, required this.votes, required this.points});

  final Round round;
  final List<Vote> votes;

  /// Points per participant id.
  final Map<int, int> points;
}
