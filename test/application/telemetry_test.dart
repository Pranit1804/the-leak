import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/application/providers.dart';
import 'package:the_leak/application/round_controller.dart';
import 'package:the_leak/application/telemetry.dart';
import 'package:the_leak/application/trip_controller.dart';
import 'package:the_leak/domain/engine/round_machine.dart';
import 'package:the_leak/domain/models/difficulty.dart';

import '../support/harness.dart';

class RecordingTelemetry extends Telemetry {
  final events = <(String, Map<String, Object>)>[];
  final phases = <String>[];
  final traces = <String>[];

  @override
  void tripStarted({required int players, required int drivers}) => events.add(('trip_started', {'players': players, 'drivers': drivers}));
  @override
  void roundStarted({required int number, required int players, required bool carMode, required String difficulty}) =>
      events.add(('round_started', {'round_number': number, 'players': players, 'car_mode': carMode, 'difficulty': difficulty}));
  @override
  void roundEnded({required String outcome, required int questionsUsed, required int questionLimit, required bool carMode}) => events
      .add(('round_ended', {'outcome': outcome, 'questions_used': questionsUsed, 'question_limit': questionLimit, 'car_mode': carMode}));
  @override
  void roundAbandoned({required String phase}) => events.add(('round_abandoned', {'phase': phase}));
  @override
  void tripEnded({required int rounds}) => events.add(('trip_ended', {'rounds': rounds}));
  @override
  void wrappedExported({required String action}) => events.add(('wrapped_exported', {'action': action}));
  @override
  void setRoundPhase(String phase) => phases.add(phase);
  @override
  Future<T> trace<T>(String name, Future<T> Function() body) {
    traces.add(name);
    return body();
  }
}

void main() {
  late Harness h;
  late RecordingTelemetry t;

  setUp(() async {
    t = RecordingTelemetry();
    h = await Harness.create(extra: [telemetryProvider.overrideWithValue(t)]);
  });
  tearDown(() => h.dispose());

  test('a played round logs anonymous events only: no names, trip name, word or word id', () async {
    final tripId = await h.trip(5);
    final players = await h.read(tripRepositoryProvider).players(tripId);
    final id = await h.read(tripControllerProvider).startRound(
          tripId: tripId,
          carMode: true,
          driverId: players.first.id,
          difficulty: DifficultyChoice.hard,
        );
    final sub = h.container.listen(roundControllerProvider(id), (_, _) {});
    final v = await h.container.read(roundControllerProvider(id).future);
    final c = h.read(roundControllerProvider(id).notifier);
    for (var i = 0; i < v.handoutOrder.length; i++) {
      await c.handoutDone();
    }
    for (var i = 0; i < 6; i++) {
      await c.increment();
    }
    await c.wordGuessed();
    await c.pickGuesser(guessCandidates(v.round).first);
    await c.endDiscussion();
    await c.voteOut(v.round.insiderId);
    await c.endTrip();
    sub.close();

    expect(t.events.map((e) => e.$1).toList(), ['trip_started', 'round_started', 'round_ended', 'trip_ended']);
    expect(t.events[0].$2, {'players': 5, 'drivers': 1});
    expect(t.events[1].$2, {'round_number': 1, 'players': 5, 'car_mode': true, 'difficulty': 'hard'});
    expect(t.events[2].$2, {'outcome': 'caught', 'questions_used': 6, 'question_limit': 20, 'car_mode': true});
    expect(t.events[3].$2, {'rounds': 1});
    expect(t.traces, ['start_round']);
    expect(t.phases, containsAllInOrder(['questioning', 'whoGuessed', 'discussion', 'voting', 'reveal', 'done']));

    // Nothing identifying or secret, in any value.
    final forbidden = [...players.map((p) => p.name), 'Test trip', v.word.word, v.word.id].map((s) => s.toLowerCase());
    final values = [for (final e in t.events) ...e.$2.values.map((x) => '$x'.toLowerCase()), ...t.phases];
    final leaks = values.where((x) => forbidden.any(x.contains)).length;
    expect(leaks, 0, reason: 'telemetry values containing a name, the trip name or the word');
  });

  test('abandoning a round logs the phase it was in', () async {
    final tripId = await h.trip(4);
    final id = await h.read(tripControllerProvider).startRound(tripId: tripId, carMode: false, difficulty: DifficultyChoice.easy);
    final sub = h.container.listen(roundControllerProvider(id), (_, _) {});
    await h.container.read(roundControllerProvider(id).future);
    await h.read(roundControllerProvider(id).notifier).abandon();
    sub.close();
    expect(t.events.last.$1, 'round_abandoned');
    expect(t.events.last.$2, {'phase': 'handout'});
  });
}
