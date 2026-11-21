import 'package:flutter/material.dart';

import '../../app/tokens.dart';

/// 60 × 32 square toggle, 2 px ink border; on = ink fill with a paper knob on the right.
class SquareToggle extends StatelessWidget {
  const SquareToggle({super.key, required this.value, required this.onChanged, required this.semanticLabel});

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    final border = enabled ? AppColors.ink : AppColors.inkFaint;
    return Semantics(
      toggled: value,
      enabled: enabled,
      label: semanticLabel,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged!(!value) : null,
        child: Container(
          width: 60,
          height: 32,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: value ? border : Colors.transparent,
            border: Border.all(color: border, width: AppSpace.control),
          ),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(width: 24, height: 24, color: value ? AppColors.paper : border),
        ),
      ),
    );
  }
}

/// A settings-style row: bold title, muted subtitle, toggle on the right,
/// 3 px heavy rule above and 1 px ink rule below (03 Round setup).
class ToggleRow extends StatelessWidget {
  const ToggleRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.heavyTop = true,
    this.topRule = true,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool heavyTop;

  /// False when the row sits directly under another row that already has a rule.
  final bool topRule;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          top: topRule ? BorderSide(color: AppColors.ink, width: heavyTop ? AppSpace.heavyRule : AppSpace.lightRule) : BorderSide.none,
          bottom: const BorderSide(color: AppColors.ink, width: AppSpace.lightRule),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.ui(17, weight: 700, color: onChanged == null ? AppColors.inkFaint : AppColors.ink)),
                const SizedBox(height: 3),
                Text(subtitle, style: AppText.ui(14, color: AppColors.inkMuted)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          SquareToggle(value: value, onChanged: onChanged, semanticLabel: title),
        ],
      ),
    );
  }
}
