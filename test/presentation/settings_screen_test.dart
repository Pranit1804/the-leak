import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_leak/app/theme.dart';
import 'package:the_leak/application/settings_controller.dart';
import 'package:the_leak/presentation/screens/licences_screen.dart';
import 'package:the_leak/presentation/screens/settings_screen.dart';
import 'package:the_leak/services/announcer.dart';
import 'package:the_leak/services/announcer_lines.dart';

import '../services/announcer_test.dart' show FakeTts;
import '../support/harness.dart';

void main() {
  testWidgets('settings change the defaults and the test voice speaks even when muted', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final tts = FakeTts();
    final h = await tester.runAsync(() => Harness.create(extra: [ttsEngineProvider.overrideWithValue(tts)])) as Harness;
    await tester.pumpWidget(UncontrolledProviderScope(
      container: h.container,
      child: MaterialApp.router(
        theme: buildTheme(),
        routerConfig: GoRouter(routes: [GoRoute(path: '/', builder: (_, _) => const SettingsScreen())]),
      ),
    ));
    await tester.pump();
    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.text('QUESTION LIMIT'), findsOneWidget);

    await tester.tap(find.text('25'));
    await tester.pump();
    await tester.tap(find.text('Off'));
    await tester.pump();
    final s = h.read(settingsControllerProvider);
    expect(s.game.questionLimit, 25);
    expect(s.game.discussionSeconds, 0);
    expect(find.textContaining('the vote starts straight after'), findsOneWidget);

    await h.read(settingsControllerProvider.notifier).setMuted(true);
    await tester.tap(find.text('TEST VOICE'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 10));
    }
    expect(tts.lines, [AnnouncerLines.testVoice]);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(h.dispose);
  }, timeout: const Timeout(Duration(seconds: 60)));

  testWidgets('licences list the three font OFL licences first', (tester) async {
    registerFontLicences();
    await tester.pumpWidget(MaterialApp.router(
      theme: buildTheme(),
      routerConfig: GoRouter(routes: [GoRoute(path: '/', builder: (_, _) => const LicencesScreen())]),
    ));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pump();
    expect(find.text('LICENCES'), findsOneWidget);
    expect(find.text('ANTON (FONT)'), findsOneWidget);
    expect(find.textContaining('SIL Open Font License').first, findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 60)));
}
