import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../app/tokens.dart';

/// The stroke icons drawn in design/screens, as SVG path data on a 24×24 grid.
enum AppIcon {
  settings(['M4 7h10M18 7h2M4 17h4M12 17h8', 'M14 4v6M8 14v6'], 2, StrokeCap.square),
  back(['M15 5l-7 7 7 7'], 2.2, StrokeCap.square),
  eye(['M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z', 'M15 12a3 3 0 1 1-6 0a3 3 0 1 1 6 0z'], 2, StrokeCap.square),
  speaker(['M11 5L6 9H2v6h4l5 4V5z', 'M15.5 8.5a5 5 0 0 1 0 7', 'M19 5a10 10 0 0 1 0 14'], 2, StrokeCap.square),
  speakerMuted(['M11 5L6 9H2v6h4l5 4V5z', 'M16 9l6 6M22 9l-6 6'], 2, StrokeCap.square),
  fingerprint([
    'M12 11v4',
    'M8.5 8.5a5 5 0 0 1 8.5 3.5v2',
    'M7 12v1a5 5 0 0 0 1.5 3.6',
    'M4.5 9A8 8 0 0 1 20 12v1',
    'M10 12a2 2 0 0 1 4 0v3a6 6 0 0 1-1 3.3',
  ], 1.6, StrokeCap.round),
  check(['M5 12l5 5L20 7'], 2.6, StrokeCap.square);

  const AppIcon(this.paths, this.strokeWidth, this.cap);
  final List<String> paths;
  final double strokeWidth;
  final StrokeCap cap;
}

class StrokeIcon extends StatelessWidget {
  const StrokeIcon(this.icon, {super.key, this.size = 20, this.color = AppColors.ink, this.strokeWidth});

  final AppIcon icon;
  final double size;
  final Color color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _StrokeIconPainter(icon, color, strokeWidth ?? icon.strokeWidth)),
      );
}

class _StrokeIconPainter extends CustomPainter {
  _StrokeIconPainter(this.icon, this.color, this.strokeWidth);
  final AppIcon icon;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24, size.height / 24);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = icon.cap
      ..strokeJoin = icon.cap == StrokeCap.round ? StrokeJoin.round : StrokeJoin.miter;
    for (final d in icon.paths) {
      canvas.drawPath(parseSvgPath(d), paint);
    }
  }

  @override
  bool shouldRepaint(_StrokeIconPainter old) => old.icon != icon || old.color != color || old.strokeWidth != strokeWidth;
}

/// Minimal SVG path parser: M m L l H h V v C c S s A a Z z.
ui.Path parseSvgPath(String d) {
  final path = ui.Path();
  final tokens = RegExp(r'[MmLlHhVvCcSsAaZz]|-?(?:\d+\.?\d*|\.\d+)').allMatches(d).map((m) => m.group(0)!).toList();
  var i = 0;
  var cmd = '';
  var cx = 0.0, cy = 0.0, sx = 0.0, sy = 0.0;
  double? lastCtrlX, lastCtrlY;
  bool isCmd(String t) => RegExp(r'^[A-Za-z]$').hasMatch(t);
  double next() => double.parse(tokens[i++]);

  while (i < tokens.length) {
    if (isCmd(tokens[i])) cmd = tokens[i++];
    final rel = cmd == cmd.toLowerCase();
    final ox = rel ? cx : 0.0, oy = rel ? cy : 0.0;
    switch (cmd.toUpperCase()) {
      case 'M':
        cx = ox + next();
        cy = oy + next();
        path.moveTo(cx, cy);
        sx = cx;
        sy = cy;
        cmd = rel ? 'l' : 'L';
        lastCtrlX = null;
      case 'L':
        cx = ox + next();
        cy = oy + next();
        path.lineTo(cx, cy);
        lastCtrlX = null;
      case 'H':
        cx = ox + next();
        path.lineTo(cx, cy);
        lastCtrlX = null;
      case 'V':
        cy = (rel ? cy : 0.0) + next();
        path.lineTo(cx, cy);
        lastCtrlX = null;
      case 'C':
        final x1 = ox + next(), y1 = oy + next(), x2 = ox + next(), y2 = oy + next();
        cx = ox + next();
        cy = oy + next();
        path.cubicTo(x1, y1, x2, y2, cx, cy);
        lastCtrlX = x2;
        lastCtrlY = y2;
      case 'S':
        final x1 = lastCtrlX == null ? cx : 2 * cx - lastCtrlX;
        final y1 = lastCtrlY == null || lastCtrlX == null ? cy : 2 * cy - lastCtrlY;
        final x2 = ox + next(), y2 = oy + next();
        cx = ox + next();
        cy = oy + next();
        path.cubicTo(x1, y1, x2, y2, cx, cy);
        lastCtrlX = x2;
        lastCtrlY = y2;
      case 'A':
        final rx = next(), ry = next(), rot = next();
        final large = next() != 0, sweep = next() != 0;
        cx = ox + next();
        cy = oy + next();
        path.arcToPoint(Offset(cx, cy), radius: Radius.elliptical(rx, ry), rotation: rot, largeArc: large, clockwise: sweep);
        lastCtrlX = null;
      case 'Z':
        path.close();
        cx = sx;
        cy = sy;
        lastCtrlX = null;
      default:
        i++;
    }
  }
  return path;
}
