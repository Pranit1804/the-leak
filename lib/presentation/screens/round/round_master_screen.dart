import 'package:flutter/material.dart';

import '../../../app/tokens.dart';
import '../../../application/round_controller.dart';
import '../../widgets/big_counter.dart';
import '../../widgets/hold_to_reveal.dart';
import '../../widgets/ink_button.dart';
import '../../widgets/screen_scaffold.dart';
import '../../widgets/stroke_icon.dart';

/// Round, Master view (05): counter, +1, Undo, Word guessed / Not guessed.
class RoundMasterScreen extends StatelessWidget {
  const RoundMasterScreen({
    super.key,
    required this.view,
    required this.muted,
    required this.onToggleMute,
    required this.onIncrement,
    required this.onUndo,
    required this.onWordGuessed,
    required this.onNotGuessed,
  });

  final RoundView view;
  final bool muted;
  final VoidCallback onToggleMute;
  final VoidCallback onIncrement;
  final VoidCallback onUndo;
  final VoidCallback onWordGuessed;
  final VoidCallback onNotGuessed;

  @override
  Widget build(BuildContext context) {
    final r = view.round;
    return HoldToReveal(
      builder: (context, peeking, holdTarget) => PaperScreen(
        gap: 14,
        body: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ink, width: AppSpace.lightRule))),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('ROUND ${r.number}', style: AppText.label()),
                  const SizedBox(height: 2),
                  Text('Master: ${view.name(r.masterId)}', style: AppText.voice(16), overflow: TextOverflow.ellipsis),
                ]),
              ),
              holdTarget(IconSquareButton(icon: AppIcon.eye, semanticLabel: 'Hold to peek at the word', filled: peeking)),
              const SizedBox(width: 8),
              IconSquareButton(
                icon: muted ? AppIcon.speakerMuted : AppIcon.speaker,
                semanticLabel: muted ? 'Unmute announcements' : 'Mute announcements',
                onPressed: onToggleMute,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: peeking ? _Peek(word: view.word.word) : BigCounter(value: r.questionsUsed, limit: view.questionLimit),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: CounterPad(
              value: r.questionsUsed,
              limit: view.questionLimit,
              onIncrement: onIncrement,
              onUndo: onUndo,
              onOutOfQuestions: onNotGuessed,
            ),
          ),
        ],
        bottom: [
          Row(children: [
            Expanded(
              child: InkButton.highlight(
                label: 'Word guessed',
                fontSize: 19,
                letterSpacingEm: 0.06,
                onPressed: r.questionsUsed > 0 ? onWordGuessed : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlineInkButton(
                label: 'Not guessed',
                height: 56,
                style: OutlineStyle.anton,
                fontSize: 19,
                letterSpacingEm: 0.06,
                onPressed: onNotGuessed,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

/// Shown in place of the counter only while the eye icon is held.
class _Peek extends StatelessWidget {
  const _Peek({required this.word});

  final String word;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('SECRET WORD', style: AppText.label()),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(word.toUpperCase(), style: AppText.display(44, height: 1.05)),
          ),
          const SizedBox(height: 14),
          Text('LIFT YOUR FINGER TO HIDE', style: AppText.label(color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}
