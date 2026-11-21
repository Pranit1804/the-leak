import 'package:flutter/material.dart';

import '../../app/tokens.dart';

/// Label on the left (and optional label on the right), 8 px below, 1 px ink rule.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.left,
    this.right,
    this.rightColor = AppColors.ink,
    this.leading,
    this.trailing,
    this.ruleWidth = AppSpace.lightRule,
    this.bottomPadding = 8,
  });

  final String left;
  final String? right;
  final Color rightColor;
  final Widget? leading;
  final Widget? trailing;
  final double ruleWidth;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ink, width: ruleWidth))),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(child: Text(left.toUpperCase(), style: AppText.label(), overflow: TextOverflow.ellipsis)),
          if (right != null) Text(right!.toUpperCase(), style: AppText.label(color: rightColor)),
          ?trailing,
        ],
      ),
    );
  }
}

/// A rule spanning the width: 3 px heavy above sections, 1 px light between rows.
class Rule extends StatelessWidget {
  const Rule.heavy({super.key})
      : height = AppSpace.heavyRule,
        color = AppColors.ink;
  const Rule.ink({super.key})
      : height = AppSpace.lightRule,
        color = AppColors.ink;
  const Rule.light({super.key})
      : height = AppSpace.lightRule,
        color = AppColors.ruleLight;

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(height: height, color: color);
}

/// Red (or ink) label inline before muted body text, with 1 px rules.
class NoteLine extends StatelessWidget {
  const NoteLine({
    super.key,
    required this.label,
    required this.text,
    this.labelColor = AppColors.red,
    this.topRule = true,
    this.bottomRule = false,
    this.inline = false,
  });

  final String label;
  final String text;
  final Color labelColor;
  final bool topRule;
  final bool bottomRule;

  /// Inline variant (03 Round setup): no rules, label flows into the text.
  final bool inline;

  @override
  Widget build(BuildContext context) {
    if (inline) {
      return Text.rich(
        TextSpan(children: [
          TextSpan(text: '${label.toUpperCase()} ', style: AppText.label(color: labelColor)),
          TextSpan(text: text, style: AppText.ui(14, color: AppColors.inkMuted, height: 1.5)),
        ]),
      );
    }
    const side = BorderSide(color: AppColors.ink, width: AppSpace.lightRule);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(top: topRule ? side : BorderSide.none, bottom: bottomRule ? side : BorderSide.none)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(label.toUpperCase(), style: AppText.label(color: labelColor)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppText.ui(14, color: AppColors.inkMuted, height: 1.4))),
        ],
      ),
    );
  }
}
