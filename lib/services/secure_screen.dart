import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Toggles Android's FLAG_SECURE. Reference-counted so overlapping secure
/// screens (during a phase change) never clear it early. No-op elsewhere.
class SecureScreen {
  SecureScreen._();

  static const _channel = MethodChannel('theleak/secure');
  static int _count = 0;

  static bool get isSecure => _count > 0;

  static Future<void> acquire() async {
    _count++;
    if (_count == 1) await _set(true);
  }

  static Future<void> release() async {
    if (_count == 0) return;
    _count--;
    if (_count == 0) await _set(false);
  }

  static Future<void> _set(bool on) async {
    try {
      await _channel.invokeMethod<void>('setSecure', on);
    } on MissingPluginException {
      // iOS and tests: nothing to do.
    } on PlatformException {
      // Never block the game on this.
    }
  }
}

/// Marks its subtree as secret: FLAG_SECURE is on while it is mounted.
class SecureArea extends StatefulWidget {
  const SecureArea({super.key, required this.child});

  final Widget child;

  @override
  State<SecureArea> createState() => _SecureAreaState();
}

class _SecureAreaState extends State<SecureArea> {
  @override
  void initState() {
    super.initState();
    SecureScreen.acquire();
  }

  @override
  void dispose() {
    SecureScreen.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
