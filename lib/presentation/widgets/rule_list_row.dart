import 'package:flutter/material.dart';

import '../../app/tokens.dart';
import 'stroke_icon.dart';

enum RowSelection { none, ink, red }

/// 50–64 px list row with a 1 px ruleLight bottom border.
/// Selected rows fill with ink (and a check) or red (vote pick).
class RuleListRow extends StatelessWidget {
  const RuleListRow({
    super.key,
    required this.title,
    this.onTap,
    this.height = 60,
    this.fontSize = 18,
    this.selection = RowSelection.none,
    this.tag,
    this.selectedTag,
  });

  final String title;
  final VoidCallback? onTap;
  final double height;
  final double fontSize;
  final RowSelection selection;

  /// Small label on the right of an unselected row (e.g. "DRIVER").
  final String? tag;

  /// Label on the right of a selected red row (e.g. "YOUR PICK"). Ink rows show a check.
  final String? selectedTag;

  @override
  Widget build(BuildContext context) {
    final selected = selection != RowSelection.none;
    final Widget? trailing = switch (selection) {
      RowSelection.ink => const StrokeIcon(AppIcon.check, size: 22, color: AppColors.onInk),
      RowSelection.red => selectedTag == null ? null : Text(selectedTag!, style: AppText.label(color: AppColors.onInk)),
      RowSelection.none => tag == null ? null : Text(tag!, style: AppText.label(color: AppColors.inkMuted)),
    };
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: title,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: selected ? 14 : 4),
          decoration: BoxDecoration(
            color: switch (selection) {
              RowSelection.ink => AppColors.ink,
              RowSelection.red => AppColors.red,
              RowSelection.none => Colors.transparent,
            },
            border: selected ? null : const Border(bottom: BorderSide(color: AppColors.ruleLight, width: AppSpace.lightRule)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.ui(fontSize, weight: selected ? 700 : 600, color: selected ? AppColors.onInk : AppColors.ink),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
