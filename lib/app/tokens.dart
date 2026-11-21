import 'package:flutter/painting.dart';

/// Colour tokens from docs/DESIGN.md section 2 (and design/tokens.json).
abstract final class AppColors {
  static const paper = Color(0xFFF1ECDF);
  static const paperRaised = Color(0xFFFBF8F0);
  static const paperLoud = Color(0xFFEDE7D7);
  static const ink = Color(0xFF141210);
  static const inkMuted = Color(0xFF4F493E);
  static const inkFaint = Color(0xFF8A8270);
  static const ruleLight = Color(0xFFC9C0AC);
  static const counterSuffix = Color(0xFFA39A86);
  static const red = Color(0xFFC8201A);
  static const onInk = Color(0xFFFFFFFF);
  static const desk = Color(0xFF2A2722);

  // Tints used only inside the loud screens' mockups (09, 11).
  static const loudTop = Color(0xFFF1EBDC);
  static const loudBottom = Color(0xFFE6DFCC);
  static const mastheadSmall = Color(0xFFF6E9E4);
  static const photoGrey = Color(0xFFBDB5A1);
  static const deskLabel = Color(0xFFD9D1BF);
}

/// Spacing and sizing tokens from docs/DESIGN.md section 4 and 5.
abstract final class AppSpace {
  static const screenX = 20.0;
  static const screenTop = 44.0;
  static const screenBottom = 24.0;
  static const minTouch = 44.0;
  static const buttonPrimary = 56.0;
  static const plusOneButton = 168.0;
  static const iconButton = 44.0;
  static const heavyRule = 3.0;
  static const lightRule = 1.0;
  static const control = 2.0;
}

abstract final class AppFonts {
  static const display = 'Anton';
  static const ui = 'LibreFranklin';
  static const voice = 'LibreCaslonText';
}

/// The tabloid type system from docs/DESIGN.md section 3.
abstract final class AppText {
  static TextStyle display(double size, {Color color = AppColors.ink, double height = 1.0, double letterSpacingEm = 0}) =>
      TextStyle(
        fontFamily: AppFonts.display,
        fontSize: size,
        height: height,
        color: color,
        fontWeight: FontWeight.w400,
        letterSpacing: size * letterSpacingEm,
      );

  static TextStyle button({double size = 21, Color color = AppColors.onInk, double letterSpacingEm = 0.08}) =>
      display(size, color: color, letterSpacingEm: letterSpacingEm, height: 1.1);

  static TextStyle label({Color color = AppColors.ink, double size = 11, double letterSpacingEm = 0.16, int weight = 800}) =>
      ui(size, weight: weight, color: color, letterSpacingEm: letterSpacingEm);

  static TextStyle ui(double size, {int weight = 500, Color color = AppColors.ink, double letterSpacingEm = 0, double? height}) =>
      TextStyle(
        fontFamily: AppFonts.ui,
        fontSize: size,
        fontWeight: _weight(weight),
        fontVariations: [FontVariation('wght', weight.toDouble())],
        color: color,
        letterSpacing: size * letterSpacingEm,
        height: height,
      );

  static TextStyle voice(double size, {Color color = AppColors.ink, bool italic = true, double height = 1.35}) => TextStyle(
        fontFamily: AppFonts.voice,
        fontSize: size,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontWeight: FontWeight.w400,
        fontVariations: const [FontVariation('wght', 400)],
        // Libre Caslon's default ligatures turn "st" into a historical
        // ligature; the mockups read as plain text.
        fontFeatures: const [FontFeature.disable('liga')],
        color: color,
        height: height,
      );

  static FontWeight _weight(int w) {
    final index = ((w / 100).round() - 1).clamp(0, 8);
    return FontWeight.values[index];
  }
}
