import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/app/app.dart';
import 'package:the_leak/app/router.dart';
import 'package:the_leak/application/providers.dart';
import 'package:the_leak/domain/models/round_phase.dart';
import 'package:the_leak/presentation/widgets/square_field.dart';
import 'package:the_leak/presentation/widgets/square_toggle.dart';

import '../support/harness.dart';

Finder keyed(String prefix) =>
    find.byWidgetPredicate((w) => w.key is ValueKey<String> && (w.key! as ValueKey<String>).value.startsWith(prefix));

/// Acceptance (PRD 9): 6 players finish 10 rounds in a row with no crash or
/// stuck screen, driving the real router and screens over an in-memory database.
void main() {
  testWidgets('6 players, 10 rounds in a row, then Trip Wrapped unlocks', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final h = await tester.runAsync(() => Harness.create()) as Harness;
    await tester.pumpWidget(UncontrolledProviderScope(container: h.container, child: TheLeakApp(router: buildRouter())));

    Future<void> settle() async {
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    Future<void> tap(Finder f) async {
      await tester.ensureVisible(f.first);
      await tester.tap(f.first);
      await settle();
    }

    await settle();
    expect(find.text('START YOUR FIRST TRIP'), findsOneWidget, reason: 'empty state');
    await tap(find.text('START YOUR FIRST TRIP'));
    expect(find.text('NEW TRIP'), findsOneWidget);

    for (final n in ['Rohan', 'Priya', 'Amit', 'Sneha', 'Kunal', 'Neha']) {
      await tester.enterText(find.widgetWithText(TextField, 'Add a player'), n);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await settle();
    }
    expect(find.text('PLAYERS (6) · IN SEAT ORDER'), findsOneWidget);
    await tap(find.byType(SquareCheckbox)); // Rohan drives
    await tap(find.text('SAVE AND CONTINUE'));

    for (var round = 1; round <= 10; round++) {
      expect(find.text('ROUND $round'), findsOneWidget);
      // Car mode on for odd rounds, off for even ones.
      final carOn = find.text("WHO'S DRIVING NOW?").evaluate().isNotEmpty;
      if (carOn != round.isOdd) await tap(find.byType(SquareToggle));
      await tap(find.text('START ROUND'));

      // Handout until the Master is done.
      var steps = 0;
      while (find.text('ROLE HANDOUT').evaluate().isNotEmpty) {
        final g = await tester.startGesture(tester.getCenter(find.textContaining('HOLD TO SEE')));
        await tester.pump();
        expect(find.text('TOP SECRET · FOR YOUR EYES ONLY'), findsOneWidget);
        await g.up();
        await tester.pump();
        expect(find.text('TOP SECRET · FOR YOUR EYES ONLY'), findsNothing);
        await tap(find.textContaining('DONE ·'));
        expect(++steps, lessThanOrEqualTo(6));
      }
      expect(steps, round.isOdd ? 5 : 6, reason: 'the driver is skipped in Car mode');
      expect(find.text('QUESTIONS ASKED'), findsOneWidget);

      if (round == 4) {
        // A round nobody cracks.
        await tap(find.text('NOT GUESSED'));
        await tap(find.text('REVEAL THE WORD'));
      } else {
        for (var q = 0; q < round + 2; q++) {
          await tester.tap(find.text('+1'));
          await tester.pump();
        }
        await settle();
        await tap(find.text('WORD GUESSED'));
        await tap(keyed('guesser-'));
        await tap(find.textContaining('CRACKED IT'));
        await tap(find.text('SKIP TO THE VOTE'));
        var votes = 0;
        while (find.text('SECRET VOTE').evaluate().isNotEmpty) {
          if (find.textContaining('TAP TO VOTE').evaluate().isNotEmpty) await tap(find.textContaining('TAP TO VOTE'));
          // Vote for a different candidate each round.
          final cands = keyed('candidate-');
          await tap(cands.at(round % cands.evaluate().length));
          await tap(find.text('LOCK VOTE'));
          expect(++votes, lessThanOrEqualTo(6));
        }
        expect(votes, round.isOdd ? 6 : 6, reason: 'passengers plus the driver, or all six');
      }
      expect(find.text('EXCLUSIVE'), findsOneWidget);
      if (round < 10) await tap(find.textContaining('CONTINUED IN ROUND ${round + 1}'));
    }

    // After 10 rounds Standings offers Trip Wrapped.
    await tap(find.text('STANDINGS'));
    expect(find.textContaining('10 ROUNDS'), findsOneWidget);
    expect(find.text('TRIP WRAPPED'), findsOneWidget);
    await tap(find.text('TRIP WRAPPED'));
    expect(find.text('CASE CLOSED'), findsOneWidget);

    final records = await tester.runAsync(() => h.read(roundRepositoryProvider).records(1));
    expect(records!.length, 10);
    expect(records.where((r) => r.round.phase == RoundPhase.reveal).length, 1, reason: 'round 10 is still on its reveal');
    expect(records.where((r) => r.round.phase == RoundPhase.done).length, 9);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(h.dispose);
  });
}
