import 'package:flutter/material.dart';

import '../../app/tokens.dart';
import 'ink_button.dart';

/// Square confirm dialog: paper background, 3 px ink border, Anton title,
/// black (or red) confirm button and an outline cancel button.
Future<bool> confirmSquare(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  String cancelLabel = 'Cancel',
  bool red = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: AppColors.ink.withValues(alpha: 0.55),
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title.toUpperCase(), style: AppText.display(32)),
            const SizedBox(height: 10),
            Text(body, style: AppText.ui(15, color: AppColors.inkMuted, height: 1.45)),
            const SizedBox(height: 20),
            InkButton(
              label: confirmLabel,
              color: red ? AppColors.red : AppColors.ink,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 10),
            OutlineInkButton(label: cancelLabel, height: 46, onPressed: () => Navigator.of(context).pop(false)),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}

/// Square one-button notice dialog.
Future<void> noticeSquare(BuildContext context, {required String title, required String body, String okLabel = 'OK'}) {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.ink.withValues(alpha: 0.55),
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title.toUpperCase(), style: AppText.display(32)),
            const SizedBox(height: 10),
            Text(body, style: AppText.ui(15, color: AppColors.inkMuted, height: 1.45)),
            const SizedBox(height: 20),
            InkButton(label: okLabel, onPressed: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    ),
  );
}
