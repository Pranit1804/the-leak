import 'package:flutter/material.dart';

import '../../app/tokens.dart';
import 'ink_button.dart';
import 'progress_segments.dart';

/// "QUESTIONS ASKED" block: Anton 190 count, "/ 20", progress bar, "13 questions left".
class BigCounter extends StatelessWidget {
  const BigCounter({super.key, required this.value, required this.limit});

  final int value;
  final int limit;

  @override
  Widget build(BuildContext context) {
    final left = (limit - value).clamp(0, limit);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('QUESTIONS ASKED', style: AppText.label()),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$value',
                  key: const Key('counter-value'),
                  style: AppText.display(190, height: 0.9).copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
              const SizedBox(width: 10),
              Text('/ $limit', style: AppText.display(52, color: AppColors.counterSuffix)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        InkProgressBar(fraction: limit == 0 ? 0 : value / limit, semanticLabel: '$value of $limit questions asked'),
        const SizedBox(height: 6),
        Text(left == 1 ? '1 question left' : '$left questions left', style: AppText.ui(14, weight: 600, color: AppColors.inkMuted)),
      ],
    );
  }
}

/// The 168 px "+1 QUESTION ASKED" button and the Undo text button.
/// +1 is disabled at the limit and Undo at zero.
class CounterPad extends StatelessWidget {
  const CounterPad({
    super.key,
    required this.value,
    required this.limit,
    required this.onIncrement,
    required this.onUndo,
    this.onOutOfQuestions,
  });

  final int value;
  final int limit;
  final VoidCallback onIncrement;
  final VoidCallback onUndo;

  /// Tapped when the limit is reached ("Out of questions?").
  final VoidCallback? onOutOfQuestions;

  @override
  Widget build(BuildContext context) {
    final atLimit = value >= limit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          enabled: true,
          label: atLimit ? 'Out of questions. Tap Not guessed.' : 'Plus one, question asked',
          excludeSemantics: true,
          child: GestureDetector(
            key: const Key('plus-one'),
            behavior: HitTestBehavior.opaque,
            onTap: atLimit ? onOutOfQuestions : onIncrement,
            child: Container(
              height: AppSpace.plusOneButton,
              color: atLimit ? AppColors.ruleLight : AppColors.ink,
              alignment: Alignment.center,
              child: atLimit
                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('OUT OF QUESTIONS?', style: AppText.display(40, color: AppColors.ink)),
                      const SizedBox(height: 6),
                      Text('TAP NOT GUESSED', style: AppText.ui(12, weight: 800, letterSpacingEm: 0.2, color: AppColors.inkMuted)),
                    ])
                  : Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('+1', style: AppText.display(80, color: AppColors.onInk)),
                      const SizedBox(height: 4),
                      Text('QUESTION ASKED', style: AppText.ui(12, weight: 800, letterSpacingEm: 0.2, color: AppColors.onInk)),
                    ]),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Center(child: TextInkButton(key: const Key('undo'), label: 'Undo', onPressed: value > 0 ? onUndo : null)),
      ],
    );
  }
}
