import 'package:flutter/material.dart';

import '../../app/tokens.dart';

class Dateline extends StatelessWidget {
  const Dateline({super.key, required this.left, required this.middle, required this.right, this.fontSize = 10, this.weight = 700});

  final String left;
  final String middle;
  final String right;
  final double fontSize;
  final int weight;

  @override
  Widget build(BuildContext context) {
    final s = AppText.ui(fontSize, weight: weight, letterSpacingEm: 0.12);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.ink, width: AppSpace.heavyRule), bottom: BorderSide(color: AppColors.ink)),
      ),
      child: Row(children: [
        Expanded(child: Text(left.toUpperCase(), style: s, overflow: TextOverflow.ellipsis)),
        Text(middle.toUpperCase(), style: s),
        Expanded(child: Text(right.toUpperCase(), style: s, textAlign: TextAlign.right)),
      ]),
    );
  }
}

/// A 1 px dotted rule in inkFaint (dotted leaders on the loud screens).
class DottedRule extends StatelessWidget {
  const DottedRule({super.key, this.color = AppColors.inkFaint});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(height: 1, width: double.infinity, child: CustomPaint(painter: _DotPainter(color)));
}

class _DotPainter extends CustomPainter {
  _DotPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    for (var x = 0.0; x < size.width; x += 3) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 1, 1), p);
    }
  }

  @override
  bool shouldRepaint(_DotPainter old) => old.color != color;
}

