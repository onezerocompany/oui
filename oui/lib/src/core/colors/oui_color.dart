import 'dart:ui';

import 'package:oui/src/core/colors/oui_color_hsv.dart';

import 'oui_color_hsl.dart';

enum OuiRgbColorSpace {
  sRGB,
  extendedSRGB,
  displayP3,
}

class OuiColor {
  // The red component of the color. A value between 0.0 and 1.0.
  final double red;

  // The green component of the color. A value between 0.0 and 1.0.
  final double green;

  // The blue component of the color. A value between 0.0 and 1.0.
  final double blue;

  // The alpha component of the color. A value between 0.0 and 1.0.
  final double alpha;

  // The color space of the color.
  final OuiRgbColorSpace colorSpace;

  const OuiColor._(
    this.red,
    this.green,
    this.blue, [
    this.alpha = 1.0,
    this.colorSpace = OuiRgbColorSpace.sRGB,
  ]);

  static const OuiColor clear = OuiColor._(0, 0, 0, 0, OuiRgbColorSpace.sRGB);

  factory OuiColor.fromRGB(
    double red,
    double green,
    double blue, [
    double alpha = 1.0,
    OuiRgbColorSpace colorSpace = OuiRgbColorSpace.sRGB,
  ]) {
    return OuiColor._(red, green, blue, alpha, colorSpace);
  }

  factory OuiColor.fromHSV(OuiColorHsv hsv) {
    return hsv.color;
  }

  factory OuiColor.fromHSL(OuiColorHsl hsl) {
    return hsl.color;
  }

  bool get isOpaque => alpha == 1.0;

  bool get isVisible => alpha > 0;

  Color get flutterColor {
    return Color.fromARGB(
      (alpha * 255).round(),
      (red * 255).round(),
      (green * 255).round(),
      (blue * 255).round(),
    );
  }
}

extension OuiColorExtension on Color {
  OuiColor get ouiColor {
    return OuiColor.fromRGB(
      red / 255,
      green / 255,
      blue / 255,
      alpha / 255,
    );
  }
}
