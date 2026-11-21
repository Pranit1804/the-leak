import 'package:flutter/material.dart';

import '../../app/tokens.dart';
import 'stroke_icon.dart';

/// Full-width primary button: 56 px, ink (or red) fill, Anton uppercase.
class InkButton extends StatelessWidget {
  const InkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.ink,
    this.height = AppSpace.buttonPrimary,
    this.fontSize = 21,
    this.letterSpacingEm = 0.08,
  });

  /// Red fill: Word guessed, Share image.
  const InkButton.highlight({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = AppSpace.buttonPrimary,
    this.fontSize = 21,
    this.letterSpacingEm = 0.08,
  }) : color = AppColors.red;

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double height;
  final double fontSize;
  final double letterSpacingEm;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          height: height,
          width: double.infinity,
          color: enabled ? color : AppColors.ruleLight,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label.toUpperCase(),
                maxLines: 1,
                style: AppText.button(size: fontSize, letterSpacingEm: letterSpacingEm, color: enabled ? AppColors.onInk : AppColors.inkMuted)),
          ),
        ),
      ),
    );
  }
}

enum OutlineStyle { franklin, anton }

/// 2 px ink border, transparent. Franklin 13–14/800 or Anton for big ones.
class OutlineInkButton extends StatelessWidget {
  const OutlineInkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
    this.style = OutlineStyle.franklin,
    this.fontSize,
    this.color = AppColors.ink,
    this.letterSpacingEm,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final OutlineStyle style;
  final double? fontSize;
  final Color color;
  final double? letterSpacingEm;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final c = enabled ? color : AppColors.inkFaint;
    final text = style == OutlineStyle.anton
        ? AppText.button(size: fontSize ?? 21, color: c, letterSpacingEm: letterSpacingEm ?? 0.08)
        : AppText.ui(fontSize ?? 14, weight: 800, color: c, letterSpacingEm: letterSpacingEm ?? 0.12);
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          height: height,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(border: Border.all(color: c, width: AppSpace.control)),
          child: FittedBox(fit: BoxFit.scaleDown, child: Text(label.toUpperCase(), maxLines: 1, style: text)),
        ),
      ),
    );
  }
}

/// Franklin 13/800 uppercase with a 4 px underline offset (Undo).
class TextInkButton extends StatelessWidget {
  const TextInkButton({super.key, required this.label, required this.onPressed, this.color = AppColors.ink});

  final String label;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final c = enabled ? color : AppColors.inkFaint;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          height: AppSpace.minTouch,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: c, width: 1.2))),
            child: Text(label.toUpperCase(), style: AppText.ui(13, weight: 800, color: c, letterSpacingEm: 0.16)),
          ),
        ),
      ),
    );
  }
}

/// 44 × 44 square icon button with a 2 px ink border.
class IconSquareButton extends StatelessWidget {
  const IconSquareButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
    this.filled = false,
    this.onPointerDown,
    this.onPointerUp,
  });

  final AppIcon icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool filled;
  final VoidCallback? onPointerDown;
  final VoidCallback? onPointerUp;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          width: AppSpace.iconButton,
          height: AppSpace.iconButton,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled ? AppColors.ink : Colors.transparent,
            border: Border.all(color: AppColors.ink, width: AppSpace.control),
          ),
          child: StrokeIcon(icon, color: filled ? AppColors.onInk : AppColors.ink),
        ),
      ),
    );
  }
}
