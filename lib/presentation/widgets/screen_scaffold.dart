import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/tokens.dart';
import 'ink_button.dart';
import 'section_header.dart';
import 'stroke_icon.dart';

/// Screen layout from docs/DESIGN.md section 4: 20 px sides, 44 px top,
/// 24 px bottom, a fixed gap between blocks, and the main action pushed to
/// the bottom. On short screens everything scrolls.
class PaperScreen extends StatelessWidget {
  const PaperScreen({
    super.key,
    required this.children,
    this.bottom = const [],
    this.gap = 16,
    this.background = AppColors.paper,
    this.decoration,
    this.padding = const EdgeInsets.fromLTRB(AppSpace.screenX, AppSpace.screenTop, AppSpace.screenX, AppSpace.screenBottom),
  });

  final List<Widget> children;
  final List<Widget> bottom;
  final double gap;
  final Color background;
  final Decoration? decoration;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final top = math.max(padding.top, media.viewPadding.top + 12);
    final bottomPad = padding.bottom + media.viewPadding.bottom;
    Widget body = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(padding.left, top, padding.right, 0),
          sliver: SliverList.list(children: _withGaps(children)),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding.left, bottom.isEmpty ? 0 : gap, padding.right, bottomPad),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _withGaps(bottom),
            ),
          ),
        ),
      ],
    );
    if (decoration != null) body = DecoratedBox(decoration: decoration!, child: body);
    return Scaffold(backgroundColor: background, body: body);
  }

  List<Widget> _withGaps(List<Widget> items) => [
        for (var i = 0; i < items.length; i++) ...[if (i > 0) SizedBox(height: gap), items[i]],
      ];
}

/// Back button + small label header with a 1 px ink rule (02, 03, 10).
class BackHeader extends StatelessWidget {
  const BackHeader({super.key, required this.label, required this.onBack, this.trailing});

  final String label;
  final VoidCallback onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => SectionHeader(
        left: label,
        leading: IconSquareButton(icon: AppIcon.back, semanticLabel: 'Back', onPressed: onBack),
        trailing: trailing,
      );
}

/// Big Anton heading; shrinks to stay on one line when needed.
class Headline extends StatelessWidget {
  const Headline(this.text, {super.key, this.size = 48, this.color = AppColors.ink, this.height = 1.0, this.fit = true});

  final String text;
  final double size;
  final Color color;
  final double height;
  final bool fit;

  @override
  Widget build(BuildContext context) {
    final t = Text(text.toUpperCase(), style: AppText.display(size, color: color, height: height), maxLines: fit ? 1 : null);
    if (!fit) return Semantics(header: true, child: t);
    return Semantics(
      header: true,
      child: Align(alignment: Alignment.centerLeft, child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: t)),
    );
  }
}
