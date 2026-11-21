import 'package:flutter/material.dart';

import '../../app/tokens.dart';
import 'stroke_icon.dart';

/// The 04a block: "Pass the phone to" (voice), NAME at Anton 112, a short red
/// rule and the privacy line.
class PassPhoneName extends StatelessWidget {
  const PassPhoneName({super.key, required this.name, this.lead = 'Pass the phone to', required this.body});

  final String name;
  final String lead;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lead, style: AppText.voice(20)),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(name.toUpperCase(), maxLines: 1, style: AppText.display(112, height: 0.92)),
          ),
          const SizedBox(height: 14),
          Container(height: 8, width: 120, color: AppColors.red),
          const SizedBox(height: 16),
          Text(body, style: AppText.ui(15, color: AppColors.inkMuted, height: 1.45)),
        ],
      ),
    );
  }
}

/// The 180 px black button with the fingerprint icon ("I'M SNEHA · HOLD TO SEE").
class GateButton extends StatelessWidget {
  const GateButton({super.key, required this.label, this.onTap, this.height = 180});

  final String label;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: height,
          color: AppColors.ink,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const StrokeIcon(AppIcon.fingerprint, size: 44, color: AppColors.onInk),
              const SizedBox(height: 12),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label.toUpperCase(), maxLines: 1, style: AppText.button(size: 22)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
