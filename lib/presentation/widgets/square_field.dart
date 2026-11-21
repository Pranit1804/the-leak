import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/tokens.dart';
import 'stroke_icon.dart';

/// 50 px text input: 2 px ink border on paperRaised, or a 2 px dashed
/// inkFaint "add" input on a transparent background.
class SquareTextField extends StatelessWidget {
  const SquareTextField({
    super.key,
    required this.controller,
    this.hint,
    this.dashed = false,
    this.fontSize = 17,
    this.weight = 600,
    this.maxLength,
    this.onSubmitted,
    this.focusNode,
    this.semanticLabel,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String? hint;
  final bool dashed;
  final double fontSize;
  final int weight;
  final int? maxLength;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      style: AppText.ui(fontSize, weight: weight),
      cursorColor: AppColors.ink,
      textCapitalization: TextCapitalization.words,
      textInputAction: textInputAction,
      inputFormatters: [if (maxLength != null) LengthLimitingTextInputFormatter(maxLength)],
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: AppText.ui(fontSize, weight: 500, color: AppColors.inkFaint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
    final box = SizedBox(height: 50, child: Center(child: field));
    final decorated = dashed
        ? CustomPaint(painter: const DashedRectPainter(color: AppColors.inkFaint, width: AppSpace.control), child: box)
        : DecoratedBox(
            decoration: BoxDecoration(color: AppColors.paperRaised, border: Border.all(color: AppColors.ink, width: AppSpace.control)),
            child: box,
          );
    return Semantics(textField: true, label: semanticLabel, child: decorated);
  }
}

class DashedRectPainter extends CustomPainter {
  const DashedRectPainter({required this.color, this.width = 2, this.dash = 6, this.gap = 4});

  final Color color;
  final double width;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;
    final h = width / 2;
    void line(Offset a, Offset b) {
      final len = (b - a).distance;
      final dir = (b - a) / len;
      for (var t = 0.0; t < len; t += dash + gap) {
        canvas.drawLine(a + dir * t, a + dir * (t + dash).clamp(0, len), p);
      }
    }

    line(Offset(0, h), Offset(size.width, h));
    line(Offset(size.width - h, 0), Offset(size.width - h, size.height));
    line(Offset(size.width, size.height - h), Offset(0, size.height - h));
    line(Offset(h, size.height), Offset(h, 0));
  }

  @override
  bool shouldRepaint(DashedRectPainter old) => old.color != color || old.width != width;
}

/// 22 × 22 square checkbox in ink.
class SquareCheckbox extends StatelessWidget {
  const SquareCheckbox({super.key, required this.value, required this.onChanged, required this.semanticLabel});

  final bool value;
  final ValueChanged<bool> onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      label: semanticLabel,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value ? AppColors.ink : AppColors.paperRaised,
                border: Border.all(color: AppColors.ink, width: AppSpace.control),
              ),
              child: value ? const Center(child: StrokeIcon(AppIcon.check, size: 16, color: AppColors.onInk)) : null,
            ),
          ),
        ),
      ),
    );
  }
}
