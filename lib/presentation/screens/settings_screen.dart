import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/tokens.dart';
import '../../application/settings_controller.dart';
import '../../domain/models/trip.dart';
import '../../services/announcer.dart';
import '../../services/announcer_lines.dart';
import '../widgets/ink_button.dart';
import '../widgets/screen_scaffold.dart';
import '../widgets/section_header.dart';
import '../widgets/segmented_square.dart';
import '../widgets/square_toggle.dart';

/// Settings: question limit, discussion timer, spoken alerts, test voice.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider);
    final c = ref.read(settingsControllerProvider.notifier);
    Widget block(String label, String hint, Widget control) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label.toUpperCase(), style: AppText.label()),
            const SizedBox(height: 10),
            control,
            const SizedBox(height: 8),
            Text(hint, style: AppText.ui(14, color: AppColors.inkMuted)),
          ],
        );

    return PaperScreen(
      body: [
        BackHeader(label: 'The Leak', onBack: () => context.canPop() ? context.pop() : context.go(Routes.home)),
        const Headline('Settings'),
        const Rule.heavy(),
        block(
          'Question limit',
          'Questions per round, guesses included.',
          SegmentedSquare<int>(
            options: GameSettings.questionLimitOptions,
            selected: s.game.questionLimit,
            labelOf: (v) => '$v',
            onChanged: c.setQuestionLimit,
          ),
        ),
        block(
          'Discussion timer',
          s.game.discussionSeconds == 0 ? 'Off: the vote starts straight after the word is guessed.' : 'Minutes to argue about the leak before the vote.',
          SegmentedSquare<int>(
            options: GameSettings.discussionOptions,
            selected: s.game.discussionSeconds,
            labelOf: (v) => v == 0 ? 'Off' : '${v ~/ 60} min',
            onChanged: c.setDiscussionSeconds,
          ),
        ),
        ToggleRow(
          title: 'Spoken alerts',
          subtitle: 'Ten, five and one questions left',
          value: s.game.alertsOn,
          onChanged: c.setAlertsOn,
        ),
        ToggleRow(
          title: 'Announcements',
          subtitle: 'Round start, vote and reveal, read aloud',
          value: !s.muted,
          heavyTop: false,
          onChanged: (on) {
            c.setMuted(!on);
            if (!on) ref.read(announcerProvider).stopAll();
          },
        ),
        OutlineInkButton(
          label: 'Test voice',
          onPressed: () => ref.read(announcerProvider).say(AnnouncerLines.testVoice, force: true),
        ),
        Text('Turn the volume up and connect to the car over Bluetooth to hear it on the speakers. Changes apply from the next round.',
            style: AppText.ui(13, color: AppColors.inkMuted, height: 1.45)),
      ],
      bottom: [
        Center(child: TextInkButton(label: 'Licences', onPressed: () => context.push(Routes.licences))),
      ],
    );
  }
}
