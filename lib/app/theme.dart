import 'package:flutter/material.dart';

import 'tokens.dart';

/// ThemeData built from docs/DESIGN.md: paper background, square corners,
/// no elevation, tabloid type.
ThemeData buildTheme() {
  const square = RoundedRectangleBorder(borderRadius: BorderRadius.zero);
  final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.paper,
    canvasColor: AppColors.paper,
    colorScheme: const ColorScheme.light(
      primary: AppColors.ink,
      onPrimary: AppColors.onInk,
      secondary: AppColors.red,
      onSecondary: AppColors.onInk,
      error: AppColors.red,
      surface: AppColors.paper,
      onSurface: AppColors.ink,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    textTheme: base.textTheme.apply(fontFamily: AppFonts.ui, bodyColor: AppColors.ink, displayColor: AppColors.ink).copyWith(
          displayLarge: AppText.display(68),
          displayMedium: AppText.display(48),
          displaySmall: AppText.display(36),
          headlineMedium: AppText.display(28),
          titleMedium: AppText.ui(17, weight: 700),
          bodyLarge: AppText.ui(17, weight: 600),
          bodyMedium: AppText.ui(15),
          bodySmall: AppText.ui(13, color: AppColors.inkMuted),
          labelSmall: AppText.label(),
        ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.ink,
      selectionColor: AppColors.ruleLight,
      selectionHandleColor: AppColors.ink,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: AppColors.ink, width: AppSpace.heavyRule),
      ),
      elevation: 0,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: square,
      side: const BorderSide(color: AppColors.ink, width: AppSpace.control),
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.ink : Colors.transparent),
      checkColor: const WidgetStatePropertyAll(AppColors.onInk),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: AppText.ui(14, weight: 600, color: AppColors.onInk),
      shape: square,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.paper, elevation: 0, scrolledUnderElevation: 0, foregroundColor: AppColors.ink),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(backgroundColor: AppColors.paper),
      TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(backgroundColor: AppColors.paper),
    }),
  );
}
