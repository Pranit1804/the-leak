import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/presentation/widgets/hold_to_reveal.dart';
import 'package:the_leak/services/secure_screen.dart';

Widget harness() => MaterialApp(
      home: Scaffold(
        body: HoldToReveal(
          builder: (context, revealed, hold) => Column(children: [
            // The hold target is replaced by the secret while held, as on the handout.
            if (revealed) const Text('SECRET') else hold(const SizedBox(width: 200, height: 100, child: Text('HOLD'))),
            const SizedBox(height: 300, child: Text('elsewhere')),
          ]),
        ),
      ),
    );

void main() {
  testWidgets('hidden by default, shown while held, hidden the instant the finger lifts', (tester) async {
    await tester.pumpWidget(harness());
    expect(find.text('SECRET'), findsNothing);
    final g = await tester.startGesture(tester.getCenter(find.text('HOLD')));
    await tester.pump();
    expect(find.text('SECRET'), findsOneWidget);
    await g.up();
    await tester.pump();
    expect(find.text('SECRET'), findsNothing);
  });

  testWidgets('a tap elsewhere does not reveal', (tester) async {
    await tester.pumpWidget(harness());
    final g = await tester.startGesture(tester.getCenter(find.text('elsewhere')));
    await tester.pump();
    expect(find.text('SECRET'), findsNothing);
    await g.up();
  });

  testWidgets('releasing after the finger slides off still hides', (tester) async {
    await tester.pumpWidget(harness());
    final g = await tester.startGesture(tester.getCenter(find.text('HOLD')));
    await tester.pump();
    await g.moveBy(const Offset(0, 250));
    await tester.pump();
    expect(find.text('SECRET'), findsOneWidget);
    await g.up();
    await tester.pump();
    expect(find.text('SECRET'), findsNothing);
  });

  testWidgets('a second finger does not keep it open after the first lifts', (tester) async {
    await tester.pumpWidget(harness());
    final a = await tester.startGesture(tester.getCenter(find.text('HOLD')), pointer: 1);
    await tester.pump();
    final b = await tester.startGesture(tester.getCenter(find.text('elsewhere')), pointer: 2);
    await a.up();
    await tester.pump();
    expect(find.text('SECRET'), findsNothing);
    await b.up();
  });

  for (final state in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.paused]) {
    testWidgets('hides when the app goes ${state.name}', (tester) async {
      await tester.pumpWidget(harness());
      final g = await tester.startGesture(tester.getCenter(find.text('HOLD')));
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      if (state != AppLifecycleState.inactive) tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      if (state == AppLifecycleState.paused) tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(find.text('SECRET'), findsNothing);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await g.up();
    });
  }

  group('with maxDuration (role handout)', () {
    Widget timed(List<bool> hides) => MaterialApp(
          home: Scaffold(
            body: HoldToReveal(
              maxDuration: const Duration(seconds: 4),
              onHidden: hides.add,
              builder: (context, revealed, hold) => Column(children: [
                if (revealed) const Text('SECRET') else hold(const SizedBox(width: 200, height: 100, child: Text('HOLD'))),
              ]),
            ),
          ),
        );

    testWidgets('closes by itself after the time even while held, and reports it completed', (tester) async {
      final hides = <bool>[];
      await tester.pumpWidget(timed(hides));
      final g = await tester.startGesture(tester.getCenter(find.text('HOLD')));
      await tester.pump(const Duration(milliseconds: 3900));
      expect(find.text('SECRET'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('SECRET'), findsNothing);
      expect(hides, [true]);
      await g.up();
      await tester.pump();
      expect(hides, [true], reason: 'lifting afterwards does not count again');
    });

    testWidgets('the same finger cannot re-open it; a new press can', (tester) async {
      final hides = <bool>[];
      await tester.pumpWidget(timed(hides));
      final g = await tester.startGesture(tester.getCenter(find.text('HOLD')));
      await tester.pump(const Duration(seconds: 4));
      await g.moveBy(const Offset(1, 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('SECRET'), findsNothing);
      await g.up();
      final g2 = await tester.startGesture(tester.getCenter(find.text('HOLD')));
      await tester.pump();
      expect(find.text('SECRET'), findsOneWidget);
      await g2.up();
      await tester.pump();
      expect(hides, [true, false], reason: 'the second look was cut short');
    });
  });

  testWidgets('SecureArea turns FLAG_SECURE on while mounted, reference-counted', (tester) async {
    final calls = <bool>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(const MethodChannel('theleak/secure'), (call) async {
      calls.add(call.arguments as bool);
      return null;
    });
    await tester.pumpWidget(const Column(children: [SecureArea(child: SizedBox()), SecureArea(child: SizedBox())]));
    expect(SecureScreen.isSecure, isTrue);
    await tester.pumpWidget(const Column(children: [SecureArea(child: SizedBox())]));
    expect(SecureScreen.isSecure, isTrue);
    await tester.pumpWidget(const SizedBox());
    expect(SecureScreen.isSecure, isFalse);
    expect(calls, [true, false]);
  });
}
