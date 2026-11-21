import 'package:flutter/widgets.dart';

/// Wraps a child so that a hold target can reveal secret content.
///
/// The outer [Listener] stays mounted for the whole screen, so the release is
/// caught even when the hold target itself is swapped out for the revealed
/// content. Content is hidden the instant the finger lifts or the pointer is
/// cancelled, and whenever the app leaves the foreground (TECH_SPEC section 9).
typedef HoldTargetWrapper = Widget Function(Widget target);

class HoldToReveal extends StatefulWidget {
  const HoldToReveal({super.key, required this.builder, this.onRevealed, this.onHidden});

  final Widget Function(BuildContext context, bool revealed, HoldTargetWrapper holdTarget) builder;
  final VoidCallback? onRevealed;
  final VoidCallback? onHidden;

  @override
  State<HoldToReveal> createState() => HoldToRevealState();
}

class HoldToRevealState extends State<HoldToReveal> with WidgetsBindingObserver {
  int? _pointer;

  bool get revealed => _pointer != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) hide();
  }

  void _down(PointerDownEvent e) {
    if (_pointer != null) return;
    setState(() => _pointer = e.pointer);
    widget.onRevealed?.call();
  }

  void _up(PointerEvent e) {
    if (e.pointer == _pointer) hide();
  }

  /// Hides the content immediately.
  void hide() {
    if (_pointer == null || !mounted) return;
    setState(() => _pointer = null);
    widget.onHidden?.call();
  }

  Widget _wrap(Widget target) => Listener(behavior: HitTestBehavior.opaque, onPointerDown: _down, child: target);

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerUp: _up,
      onPointerCancel: _up,
      child: widget.builder(context, revealed, _wrap),
    );
  }
}
