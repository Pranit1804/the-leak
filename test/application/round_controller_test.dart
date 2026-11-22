import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/application/providers.dart';
import 'package:the_leak/application/round_controller.dart';
import 'package:the_leak/application/trip_controller.dart';
import 'package:the_leak/data/db/app_database.dart';
import 'package:the_leak/domain/engine/round_machine.dart';
import 'package:the_leak/domain/models/difficulty.dart';
import 'package:the_leak/domain/models/outcome.dart';
import 'package:the_leak/domain/models/round_phase.dart';
import 'package:the_leak/domain/models/vote.dart';

import '../support/harness.dart';

/// Records which events fired, without speaking anything.
class RecordingEvents extends RoundEvents {
  final calls = <String>[];
  @override
  Future<void> roundStarted(RoundView v) async => calls.add('roundStarted');
  @override
  void questionAsked(RoundView v) => calls.add('q${v.round.questionsUsed}');
  @override
  Future<void> wordGuessed(RoundView v) async => calls.add('wordGuessed');
  @override
  Future<void> voteStarted(RoundView v) async => calls.add('voteStarted');
  @override
  Future<void> revealed(RoundView v) async => calls.add('revealed:${v.round.outcome?.db}');
}

void main() {
  late Harness h;
  late RecordingEvents events;

  setUp(() async {
    events = RecordingEvents();
    h = await Harness.create(extra: [roundEventsProvider.overrideWithValue(events)]);
  });
  tearDown(() => h.dispose());

  Future<int> startRound({bool car = true}) async {
    final tripId = await h.trip(6);
    final players = await h.read(tripRepositoryProvider).players(tripId);
    return h.read(tripControllerProvider).startRound(
          tripId: tripId,
          carMode: car,
          driverId: car ? players.first.id : null,
          difficulty: DifficultyChoice.mixed,
        );
  }

  RoundController c(int id) => h.read(roundControllerProvider(id).notifier);
  Future<RoundView> view(int id) => h.container.read(roundControllerProvider(id).future);
  Future<RoundView> fresh(int id) async => (await h.read(roundRepositoryProvider).getRound(id)) == null
      ? throw StateError('missing')
      : view(id);

  test('a full caught round: every step is saved before the UI state changes', () async {
    final id = await startRound();
    final sub = h.container.listen(roundControllerProvider(id), (_, _) {});
    var v = await view(id);
    expect(v.handoutOrder.length, 5, reason: 'driver skipped');

    for (var i = 0; i < 5; i++) {
      await c(id).handoutDone();
      final stored = (await h.read(roundRepositoryProvider).getRound(id))!;
      v = h.container.read(roundControllerProvider(id)).requireValue;
      expect(stored.phase, v.round.phase);
      expect(stored.handoutIndex, v.round.handoutIndex);
    }
    expect(v.round.phase, RoundPhase.questioning);

    for (var i = 0; i < 7; i++) {
      await c(id).increment();
    }
    await c(id).undo();
    await c(id).increment();
    expect((await h.read(roundRepositoryProvider).getRound(id))!.questionsUsed, 7);

    await c(id).wordGuessed();
    final guesser = guessCandidates(h.container.read(roundControllerProvider(id)).requireValue.round).first;
    await c(id).pickGuesser(guesser);
    expect((await h.read(roundRepositoryProvider).getRound(id))!.phase, RoundPhase.discussion);
    await c(id).endDiscussion();

    v = h.container.read(roundControllerProvider(id)).requireValue;
    final insider = v.round.insiderId;
    expect(voteCandidates(v.round), contains(insider));
    await c(id).voteOut(insider);
    v = h.container.read(roundControllerProvider(id)).requireValue;
    expect(v.round.phase, RoundPhase.reveal);
    expect(v.round.outcome, Outcome.caught);
    expect(v.round.captionId, isNotNull);
    expect(v.points[v.round.masterId], 1);
    expect(v.points[insider], 0);
    expect(v.points[v.round.activeDriverId], 2, reason: 'the driver scores as a Common');

    final stored = (await h.read(roundRepositoryProvider).records(v.trip.id)).single;
    expect(stored.round.outcome, Outcome.caught);
    expect(stored.votes, [Vote(voterId: v.round.masterId, targetId: insider)], reason: 'one group vote, entered by the Master');
    expect(stored.points, v.points);

    await c(id).nextRound();
    expect((await h.read(roundRepositoryProvider).getRound(id))!.phase, RoundPhase.done);
    expect(events.calls, containsAllInOrder(['roundStarted', 'q1', 'wordGuessed', 'voteStarted', 'revealed:caught']));
    sub.close();
  });

  test('not guessed goes straight to the reveal with no points', () async {
    final id = await startRound(car: false);
    final sub = h.container.listen(roundControllerProvider(id), (_, _) {});
    final v = await view(id);
    for (var i = 0; i < v.handoutOrder.length; i++) {
      await c(id).handoutDone();
    }
    for (var i = 0; i < 25; i++) {
      await c(id).increment();
    }
    expect(h.container.read(roundControllerProvider(id)).requireValue.round.questionsUsed, 20, reason: 'stops at the limit');
    await c(id).notGuessed();
    final after = h.container.read(roundControllerProvider(id)).requireValue;
    expect(after.round.phase, RoundPhase.reveal);
    expect(after.round.outcome, Outcome.notFound);
    expect(after.points.values.every((p) => p == 0), isTrue);
    sub.close();
  });

  test('voting someone else out: escaped, the Leak scores 3, and a second vote is ignored', () async {
    final id = await startRound(car: false);
    final sub = h.container.listen(roundControllerProvider(id), (_, _) {});
    final v0 = await view(id);
    for (var i = 0; i < v0.handoutOrder.length; i++) {
      await c(id).handoutDone();
    }
    await c(id).increment();
    await c(id).wordGuessed();
    await c(id).pickGuesser(guessCandidates(v0.round).first);
    await c(id).endDiscussion();
    final v = h.container.read(roundControllerProvider(id)).requireValue;
    final wrong = voteCandidates(v.round).firstWhere((p) => p != v.round.insiderId);
    await c(id).voteOut(wrong);
    await c(id).voteOut(v.round.insiderId);
    final after = h.container.read(roundControllerProvider(id)).requireValue;
    expect(after.round.outcome, Outcome.notCaught);
    expect(after.points[v.round.insiderId], 3);
    expect(await h.read(roundRepositoryProvider).votes(id), [Vote(voterId: v.round.masterId, targetId: wrong)]);
    sub.close();
  });

  test('abandoning scores nothing', () async {
    final id = await startRound();
    final sub = h.container.listen(roundControllerProvider(id), (_, _) {});
    await view(id);
    await c(id).abandon();
    final r = (await h.read(roundRepositoryProvider).getRound(id))!;
    expect(r.phase, RoundPhase.done);
    expect(r.outcome, Outcome.abandoned);
    sub.close();
  });

  test('resume after an app kill: a new app on the same database opens the same phase and player', () async {
    final path = '${Directory.systemTemp.createTempSync('leak').path}/resume.sqlite';
    final db1 = AppDatabase(NativeDatabase(File(path)));
    final h1 = await Harness.create(db: db1);
    final tripId = await h1.trip(6);
    final players = await h1.read(tripRepositoryProvider).players(tripId);
    final id = await h1.read(tripControllerProvider).startRound(
          tripId: tripId,
          carMode: true,
          driverId: players.first.id,
          difficulty: DifficultyChoice.easy,
        );
    final sub = h1.container.listen(roundControllerProvider(id), (_, _) {});
    await h1.container.read(roundControllerProvider(id).future);
    final ctl = h1.read(roundControllerProvider(id).notifier);
    for (var i = 0; i < 5; i++) {
      await ctl.handoutDone();
    }
    for (var i = 0; i < 4; i++) {
      await ctl.increment();
    }
    await ctl.wordGuessed();
    final v1 = h1.container.read(roundControllerProvider(id)).requireValue;
    await ctl.pickGuesser(guessCandidates(v1.round).last);
    await ctl.endDiscussion();
    final v2 = h1.container.read(roundControllerProvider(id)).requireValue;
    sub.close();
    // "Kill" the app.
    h1.container.dispose();
    await db1.close();

    final db2 = AppDatabase(NativeDatabase(File(path)));
    final h2 = await Harness.create(db: db2);
    final open = await db2.roundDao.openRound();
    expect(open?.id, id, reason: 'launch opens /round/:id');
    final sub2 = h2.container.listen(roundControllerProvider(id), (_, _) {});
    final resumed = await h2.container.read(roundControllerProvider(id).future);
    expect(resumed.round.phase, RoundPhase.voting);
    expect(voteCandidates(resumed.round), voteCandidates(v2.round));
    expect(resumed.round.questionsUsed, 4);
    expect(resumed.round.guessedById, v2.round.guessedById);
    sub2.close();
    await h2.dispose();
  });

  test('every phase is restored from the database', () async {
    final id = await startRound();
    final sub = h.container.listen(roundControllerProvider(id), (_, _) {});
    await view(id);
    final phases = <RoundPhase>[];
    Future<void> snap() async => phases.add((await h.read(roundRepositoryProvider).getRound(id))!.phase);
    await snap();
    for (var i = 0; i < 5; i++) {
      await c(id).handoutDone();
    }
    await snap();
    await c(id).increment();
    await c(id).wordGuessed();
    await snap();
    await c(id).pickGuesser(guessCandidates(h.container.read(roundControllerProvider(id)).requireValue.round).first);
    await snap();
    await c(id).endDiscussion();
    await snap();
    expect(phases, [RoundPhase.handout, RoundPhase.questioning, RoundPhase.whoGuessed, RoundPhase.discussion, RoundPhase.voting]);
    // A fresh read of the stored round matches the in-memory view.
    final reloaded = await fresh(id);
    expect(reloaded.round.phase, RoundPhase.voting);
    sub.close();
  });
}
