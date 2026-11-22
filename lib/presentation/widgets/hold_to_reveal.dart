import 'dart:async';

import 'package:flutter/widgets.dart';

/// Wraps a child so that a hold target can reveal secret content.
///
/// The outer [Listener] stays mounted for the whole screen, so the release is
/// caught even when the hold target itself is swapped out for the revealed
/// content. Content is hidden the instant the finger lifts or the pointer is
/// cancelled, and whenever the app leaves the foreground (TECH_SPEC section 9).
///
/// With [maxDuration], the content also closes by itself after that time even
/// if the finger is still down, so every player's look takes the same time
/// and a slow read can't give the Leak away.
typedef HoldTargetWrapper = Widget Function(Widget target);

class HoldToReveal extends StatefulWidget {
  const HoldToReveal({super.key, required this.builder, this.onRevealed, this.onHidden, this.maxDuration});

  final Widget Function(BuildContext context, bool revealed, HoldTargetWrapper holdTarget) builder;
  final VoidCallback? onRevealed;

  /// Called when the content hides. [completed] is true when it closed by
  /// itself after [maxDuration], false when the finger lifted or the app paused first.
  final void Function(bool completed)? onHidden;
  final Duration? maxDuration;

  @override
  State<HoldToReveal> createState() => HoldToRevealState();
}

class HoldToRevealState extends State<HoldToReveal> with WidgetsBindingObserver {
  int? _pointer;

  /// A pointer whose timed reveal already ran out; it must lift before the next reveal.
  int? _spentPointer;
  Timer? _timer;

  bool get revealed => _pointer != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) hide();
  }

  void _down(PointerDownEvent e) {
    if (_pointer != null || _spentPointer != null) return;
    setState(() => _pointer = e.pointer);
    final max = widget.maxDuration;
    if (max != null) _timer = Timer(max, _timeUp);
    widget.onRevealed?.call();
  }

  void _timeUp() {
    if (_pointer == null || !mounted) return;
    _spentPointer = _pointer;
    _hide(completed: true);
  }

  void _up(PointerEvent e) {
    if (e.pointer == _spentPointer) _spentPointer = null;
    if (e.pointer == _pointer) hide();
  }

  /// Hides the content immediately.
  void hide() => _hide(completed: false);

  void _hide({required bool completed}) {
    _timer?.cancel();
    _timer = null;
    if (_pointer == null || !mounted) return;
    setState(() => _pointer = null);
    widget.onHidden?.call(completed);
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
