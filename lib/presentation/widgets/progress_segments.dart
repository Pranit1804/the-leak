import 'package:flutter/material.dart';

import '../../app/tokens.dart';

/// 5 px bars with 4 px gaps; done = ink, pending = ruleLight.
class ProgressSegments extends StatelessWidget {
  const ProgressSegments({super.key, required this.total, required this.done});

  final int total;
  final int done;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Row(
        children: [
          for (var i = 0; i < total; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(child: Container(height: 5, color: i < done ? AppColors.ink : AppColors.ruleLight)),
          ],
        ],
      ),
    );
  }
}

/// 12 px tall, 2 px ink border, ink fill.
class InkProgressBar extends StatelessWidget {
  const InkProgressBar({super.key, required this.fraction, this.semanticLabel});

  final double fraction;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Container(
        height: 12,
        decoration: BoxDecoration(border: Border.all(color: AppColors.ink, width: AppSpace.control)),
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: fraction.clamp(0.0, 1.0),
          heightFactor: 1,
          child: Container(color: AppColors.ink),
        ),
      ),
    );
  }
}

/// Header used by the handout and vote screens: label, "2 OF 5", segments.
class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.label, required this.index, required this.total});

  final String label;

  /// Zero-based index of the current step.
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ink, width: AppSpace.lightRule))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label.toUpperCase(), style: AppText.label()),
              Text('${index + 1} OF $total', style: AppText.label()),
            ],
          ),
          const SizedBox(height: 8),
          ProgressSegments(total: total, done: index + 1),
        ],
      ),
    );
  }
}
