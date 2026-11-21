import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_leak/app/theme.dart';
import 'package:the_leak/application/providers.dart';
import 'package:the_leak/domain/engine/stats_calculator.dart';
import 'package:the_leak/domain/models/stats.dart';
import 'package:the_leak/domain/models/trip.dart';
import 'package:the_leak/presentation/screens/standings_screen.dart';
import 'package:the_leak/presentation/screens/wrapped_screen.dart';
import 'package:the_leak/presentation/stats_text.dart';
import 'package:the_leak/services/share_card.dart';

import '../domain/helpers.dart';
import '../domain/stats_test.dart' show fixture;

final players = makePlayers(5, drivers: {1}, removed: {5});
final stats = computeStats(players, fixture);
final trip = Trip(
  id: 1,
  name: 'South Trip',
  createdAt: DateTime(2026, 11, 20),
  endedAt: DateTime(2026, 11, 22, 23),
  questionLimit: 20,
  discussionSeconds: 120,
  alertsOn: true,
  lastCarMode: false,
);

Widget app(Widget child) => ProviderScope(
      overrides: [
        tripProvider(1).overrideWith((ref) => Stream.value(trip)),
        playersProvider(1).overrideWith((ref) => Stream.value(players)),
        roundRecordsProvider(1).overrideWith((ref) => Stream.value(fixture)),
      ],
      child: MaterialApp.router(
        theme: buildTheme(),
        routerConfig: GoRouter(routes: [GoRoute(path: '/', builder: (_, _) => child)]),
      ),
    );

void main() {
  test('award details and the wrapped deck', () {
    String d(AwardType t) => awardDetail(stats.award(t)!, stats);
    expect(d(AwardType.snake), '2 of 3 escapes');
    expect(d(AwardType.sherlock), '6 of 8 right');
    expect(d(AwardType.speedDemon), 'cracked in 4');
    expect(d(AwardType.wordCracker), '3 cracks');
    expect(d(AwardType.bestHost), '3 of 3 found');
    expect(d(AwardType.alwaysSuspected), '10 votes');
    expect(wrappedDeck(stats), '11 rounds, 5 suspects, 5 leaks plugged. P2 takes the crown.');
  });

  testWidgets('standings: points table, title holders, stats and history tabs', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(const StandingsScreen(tripId: 1)));
    await tester.pumpAndSettle();
    expect(find.text('SOUTH TRIP · 11 ROUNDS · DAY 3'), findsOneWidget);
    expect(find.text('STANDINGS'), findsOneWidget);
    expect(find.text('TITLE HOLDERS SO FAR'), findsOneWidget);
    expect(find.text('The Snake'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('TRIP WRAPPED'), findsOneWidget, reason: 'the trip has ended');

    await tester.tap(find.text('STATS'));
    await tester.pumpAndSettle();
    expect(find.text('INSIDER SURVIVAL RATE'), findsOneWidget);
    expect(find.text('67% (2 of 3)'), findsOneWidget);

    await tester.tap(find.text('HISTORY'));
    await tester.pumpAndSettle();
    expect(find.text('THE LEAK'), findsOneWidget);
    expect(find.text('CAUGHT'), findsNWidgets(5));
    expect(find.text('NOT FOUND'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('trip wrapped renders the front page and captures it at 3×', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(const WrappedScreen(tripId: 1)));
    await tester.pumpAndSettle();
    expect(find.text('CASE CLOSED'), findsOneWidget);
    expect(find.text('P2'), findsWidgets);
    expect(find.text('SHARE IMAGE'), findsOneWidget);
    expect(find.text('20 NOV – 22 NOV'), findsOneWidget);

    final key = GlobalKey();
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Center(child: RepaintBoundary(key: key, child: WrappedCard(trip: trip, stats: stats, records: fixture))),
    ));
    final png = await tester.runAsync(() => capturePng(key));
    expect(png, isNotNull);
    expect(png!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
    // PNG IHDR width/height: 342 × 608 at 3× = 1026 × 1824.
    int be(int o) => (png[o] << 24) | (png[o + 1] << 16) | (png[o + 2] << 8) | png[o + 3];
    expect([be(16), be(20)], [1026, 1824]);
  });
}
