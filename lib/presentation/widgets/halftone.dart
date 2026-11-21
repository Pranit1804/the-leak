import 'package:flutter/material.dart';

import '../../app/tokens.dart';

/// Repeating dot texture: 1 px dots on a grid (default 5 px at 6% ink).
class HalftonePainter extends CustomPainter {
  const HalftonePainter({this.spacing = 5, this.radius = 1, this.color = const Color(0x0F141210)});

  final double spacing;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var y = spacing / 2; y < size.height; y += spacing) {
      for (var x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(HalftonePainter old) => old.spacing != spacing || old.radius != radius || old.color != color;
}

/// The loud newsprint background used on Reveal: halftone over a soft gradient.
class LoudBackground extends StatelessWidget {
  const LoudBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.loudTop, AppColors.loudBottom]),
      ),
      child: CustomPaint(painter: const HalftonePainter(), child: child),
    );
  }
}

/// Halftone "photo" of the leak: a head-and-shoulders silhouette in dots.
class HalftonePhoto extends StatelessWidget {
  const HalftonePhoto({super.key, this.width = 146, this.height = 170, this.tag = 'THE LEAK'});

  final double width;
  final double height;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColors.photoGrey),
          CustomPaint(painter: const HalftonePainter(spacing: 4, radius: 1.1, color: Color(0x8C141210))),
          CustomPaint(painter: _SilhouettePainter()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: AppColors.red,
              alignment: Alignment.center,
              child: Text(tag, style: AppText.display(15, color: AppColors.onInk, letterSpacingEm: 0.14, height: 1.2)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 146, sy = size.height / 170;
    final mask = Path()
      ..addOval(Rect.fromCircle(center: Offset(73 * sx, 64 * sy), radius: 32 * sx))
      ..moveTo(14 * sx, 170 * sy)
      ..cubicTo(18 * sx, 128 * sy, 44 * sx, 108 * sy, 73 * sx, 108 * sy)
      ..cubicTo(102 * sx, 108 * sy, 128 * sx, 128 * sy, 132 * sx, 170 * sy)
      ..close();
    canvas.save();
    canvas.clipPath(mask);
    final dot = Paint()..color = AppColors.ink;
    for (var y = 2.0; y < size.height; y += 4) {
      for (var x = 2.0; x < size.width; x += 4) {
        canvas.drawCircle(Offset(x, y), 1.7, dot);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
