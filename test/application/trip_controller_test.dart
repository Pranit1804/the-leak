import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/application/providers.dart';
import 'package:the_leak/application/settings_controller.dart';
import 'package:the_leak/application/trip_controller.dart';
import 'package:the_leak/data/repositories/trip_repository.dart';
import 'package:the_leak/domain/models/difficulty.dart';
import 'package:the_leak/domain/models/round_phase.dart';

import '../support/harness.dart';

void main() {
  late Harness h;
  setUp(() async => h = await Harness.create());
  tearDown(() => h.dispose());

  test('creating a trip copies the game settings and keeps seat order', () async {
    await h.read(settingsControllerProvider.notifier).setQuestionLimit(25);
    final id = await h.trip(6);
    final trip = (await h.read(tripRepositoryProvider).getTrip(id))!;
    expect(trip.questionLimit, 25);
    expect(trip.discussionSeconds, 120);
    final players = await h.read(tripRepositoryProvider).players(id);
    expect(players.map((p) => p.name), ['P1', 'P2', 'P3', 'P4', 'P5', 'P6']);
    expect(players.map((p) => p.seatOrder), [0, 1, 2, 3, 4, 5]);
  });

  test('a new trip ends the open one', () async {
    final first = await h.trip(4);
    final second = await h.trip(5);
    expect((await h.read(tripRepositoryProvider).getTrip(first))!.isOpen, isFalse);
    expect((await h.read(tripRepositoryProvider).openTrip())!.id, second);
  });

  test('startRound saves a handout round with roles, participants and a used word', () async {
    final tripId = await h.trip(6);
    final ids = (await h.read(tripRepositoryProvider).players(tripId)).map((p) => p.id).toList();
    final roundId = await h.read(tripControllerProvider).startRound(
          tripId: tripId,
          carMode: true,
          driverId: ids.first,
          difficulty: DifficultyChoice.medium,
        );
    final round = (await h.read(roundRepositoryProvider).getRound(roundId))!;
    expect(round.phase, RoundPhase.handout);
    expect(round.number, 1);
    expect(round.participantIds, ids);
    expect(round.masterId, ids[1], reason: 'first eligible player in seat order, the driver is skipped');
    expect(round.insiderId, isNot(ids.first));
    expect(round.insiderId, isNot(round.masterId));
    expect(round.driverId, ids.first);
    expect(await h.read(roundRepositoryProvider).usedWordIds(tripId), {round.wordId});
    expect((await h.read(tripRepositoryProvider).getTrip(tripId))!.lastCarMode, isTrue);
  });

  test('editing players soft-removes someone who has played and deletes someone who has not', () async {
    final tripId = await h.trip(5);
    final repo = h.read(tripRepositoryProvider);
    await h.read(tripControllerProvider).startRound(tripId: tripId, carMode: false, difficulty: DifficultyChoice.easy);
    final players = await repo.players(tripId);
    // Abandon the round so the trip can be edited.
    final round = (await h.read(roundRepositoryProvider).openRoundOfTrip(tripId))!;
    await h.read(roundRepositoryProvider).save(round.copyWith(phase: RoundPhase.done));

    final drafts = [
      for (final p in players.skip(1)) PlayerDraft(id: p.id, name: p.name, canDrive: p.canDrive),
      const PlayerDraft(name: 'New', canDrive: false),
    ];
    await h.read(tripControllerProvider).updateTrip(tripId, name: 'Renamed', players: drafts.reversed.toList());
    final after = await repo.players(tripId);
    final removed = after.firstWhere((p) => p.id == players.first.id);
    expect(removed.active, isFalse, reason: 'P1 played round 1, so keeps a removed row');
    final active = after.where((p) => p.active).toList();
    expect(active.map((p) => p.name), ['New', 'P5', 'P4', 'P3', 'P2']);
    expect((await repo.getTrip(tripId))!.name, 'Renamed');
  });

  test('ending a trip abandons an unfinished round', () async {
    final tripId = await h.trip(4);
    final roundId = await h.read(tripControllerProvider).startRound(tripId: tripId, carMode: false, difficulty: DifficultyChoice.hard);
    await h.read(tripControllerProvider).endTrip(tripId);
    final r = (await h.read(roundRepositoryProvider).getRound(roundId))!;
    expect(r.phase, RoundPhase.done);
    expect(r.outcome?.db, 'abandoned');
    expect(await h.read(tripRepositoryProvider).openTrip(), isNull);
  });

  test('settings changes also update the open trip', () async {
    final tripId = await h.trip(4);
    await h.read(settingsControllerProvider.notifier).setDiscussionSeconds(0);
    expect((await h.read(tripRepositoryProvider).getTrip(tripId))!.discussionSeconds, 0);
  });
}
