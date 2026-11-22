import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/trip_repository.dart';
import '../domain/engine/role_assigner.dart';
import '../domain/engine/round_machine.dart';
import '../domain/engine/word_picker.dart';
import '../domain/models/difficulty.dart';
import '../domain/models/outcome.dart';
import '../domain/models/round_phase.dart';
import 'providers.dart';
import 'settings_controller.dart';
import 'telemetry.dart';

/// Randomness and time, overridable in tests.
final rngProvider = Provider<Random>((ref) => Random());
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Word ids already played on a trip.
final usedWordIdsProvider = FutureProvider.autoDispose.family<Set<String>, int>(
  (ref, tripId) => ref.watch(roundRepositoryProvider).usedWordIds(tripId),
);

/// Number of the next round: completed (not abandoned) rounds + 1.
int nextRoundNumber(Iterable<Outcome?> outcomes) => outcomes.where((o) => o != Outcome.abandoned).length + 1;

class TripController {
  TripController(this.ref);

  final Ref ref;

  Future<int> createTrip({required String name, required List<PlayerDraft> players}) async {
    final trips = ref.read(tripRepositoryProvider);
    final open = await trips.openTrip();
    if (open != null) await endTrip(open.id);
    final id = await trips.createTrip(
      name: name,
      players: players,
      settings: ref.read(settingsControllerProvider).game,
      now: ref.read(clockProvider)(),
    );
    ref.read(telemetryProvider).tripStarted(players: players.length, drivers: players.where((p) => p.canDrive).length);
    return id;
  }

  Future<void> updateTrip(int tripId, {required String name, required List<PlayerDraft> players}) =>
      ref.read(tripRepositoryProvider).updateTrip(tripId, name: name, players: players, now: ref.read(clockProvider)());

  /// Ends a trip; an unfinished round is abandoned first.
  Future<void> endTrip(int tripId) async {
    final rounds = ref.read(roundRepositoryProvider);
    final now = ref.read(clockProvider)();
    final open = await rounds.openRoundOfTrip(tripId);
    if (open != null) {
      if (open.phase == RoundPhase.reveal) {
        await rounds.save(RoundMachine.close(open, now));
      } else {
        ref.read(telemetryProvider).roundAbandoned(phase: open.phase.name);
        await rounds.abandon(RoundMachine.abandon(open, now));
      }
    }
    await ref.read(tripRepositoryProvider).endTrip(tripId, now: now);
    final scored = (await rounds.records(tripId)).where((r) => r.round.outcome?.scored ?? false).length;
    ref.read(telemetryProvider).tripEnded(rounds: scored);
  }

  /// Assigns roles, picks a word and saves a new round in `handout`.
  /// Returns the new round id.
  Future<int> startRound({
    required int tripId,
    required bool carMode,
    int? driverId,
    required DifficultyChoice difficulty,
  }) =>
      ref.read(telemetryProvider).trace('start_round', () => _startRound(tripId: tripId, carMode: carMode, driverId: driverId, difficulty: difficulty));

  Future<int> _startRound({
    required int tripId,
    required bool carMode,
    int? driverId,
    required DifficultyChoice difficulty,
  }) async {
    final trips = ref.read(tripRepositoryProvider);
    final rounds = ref.read(roundRepositoryProvider);
    final rng = ref.read(rngProvider);
    final now = ref.read(clockProvider)();

    final players = await trips.players(tripId);
    final records = await rounds.records(tripId);
    final last = records.isEmpty ? null : records.last.round;
    final roles = assignRoles(
      players: players,
      carMode: carMode,
      driverId: carMode ? driverId : null,
      previousInsiderId: last?.insiderId,
      previousMasterId: last?.masterId,
      rng: rng,
    );
    final deck = await ref.read(deckRepositoryProvider).load();
    final pick = pickWord(deck: deck, choice: difficulty, usedWordIds: await rounds.usedWordIds(tripId), rng: rng);
    final round = await rounds.createRound(
      tripId: tripId,
      number: nextRoundNumber(records.map((r) => r.round.outcome)),
      startedAt: now,
      carMode: carMode,
      driverId: carMode ? driverId : null,
      masterId: roles.masterId,
      insiderId: roles.insiderId,
      wordId: pick.word.id,
      participantIds: activeInSeatOrder(players).map((p) => p.id).toList(),
      clearUsedWordIds: pick.clearedIds,
    );
    await ref.read(settingsRepositoryProvider).setLastDifficulty(difficulty);
    ref.invalidate(usedWordIdsProvider(tripId));
    ref.read(telemetryProvider).roundStarted(
      number: round.number,
      players: round.participantIds.length,
      carMode: carMode,
      difficulty: difficulty.name,
    );
    return round.id;
  }
}

final tripControllerProvider = Provider((ref) => TripController(ref));
