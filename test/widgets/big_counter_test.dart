import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_leak/app/theme.dart';
import 'package:the_leak/presentation/widgets/big_counter.dart';

/// Holds the count the way the round controller does: clamped by the pad.
class CounterHarness extends StatefulWidget {
  const CounterHarness({super.key, required this.limit, this.start = 0});

  final int limit;
  final int start;

  @override
  State<CounterHarness> createState() => _CounterHarnessState();
}

class _CounterHarnessState extends State<CounterHarness> {
  late int value = widget.start;
  int outOfQuestions = 0;

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: buildTheme(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
              BigCounter(value: value, limit: widget.limit),
              CounterPad(
                value: value,
                limit: widget.limit,
                onIncrement: () => setState(() => value++),
                onUndo: () => setState(() => value--),
                onOutOfQuestions: () => outOfQuestions++,
              ),
            ]),
          ),
        ),
      );
}

int shown(WidgetTester t) => int.parse((t.widget(find.byKey(const Key('counter-value'))) as Text).data!);

void main() {
  testWidgets('counts up and stops at the limit, then asks "Out of questions?"', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const CounterHarness(limit: 10, start: 8));
    expect(find.text('2 questions left'), findsOneWidget);
    await tester.tap(find.byKey(const Key('plus-one')));
    await tester.pump();
    expect(find.text('1 question left'), findsOneWidget);
    await tester.tap(find.byKey(const Key('plus-one')));
    await tester.pump();
    expect(shown(tester), 10);
    expect(find.text('OUT OF QUESTIONS?'), findsOneWidget);
    await tester.tap(find.byKey(const Key('plus-one')));
    await tester.pump();
    expect(shown(tester), 10, reason: '+1 is disabled at the limit');
    final state = tester.state<_CounterHarnessState>(find.byType(CounterHarness));
    expect(state.outOfQuestions, 1);
  });

  testWidgets('Undo stops at zero', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const CounterHarness(limit: 20, start: 1));
    await tester.tap(find.byKey(const Key('undo')));
    await tester.pump();
    expect(shown(tester), 0);
    await tester.tap(find.byKey(const Key('undo')));
    await tester.pump();
    expect(shown(tester), 0);
    expect(find.text('20 questions left'), findsOneWidget);
  });
}
