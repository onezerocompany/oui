import 'dart:math';
import 'dart:ui' as ui show Color;

import 'package:oui/src/core/colors/manipulatable_color.dart';
import 'package:oui/src/core/shared/interpolation.dart';

import '../shared/dynamic_container.dart';
import '../shared/leveled_container.dart';
import 'hsl_color.dart';
import 'hsv_color.dart';

/// Enum representing different RGB color spaces.
enum RgbColorSpace {
  sRGB,
  extendedSRGB,
  displayP3,
}

/// A class representing a color with red, green, blue, and alpha components.
class Color implements Interpolable<Color>, ManipulatableColor<Color> {
  // The red component of the color. A value between 0.0 and 1.0.
  final double red;

  // The green component of the color. A value between 0.0 and 1.0.
  final double green;

  // The blue component of the color. A value between 0.0 and 1.0.
  final double blue;

  // The alpha component of the color. A value between 0.0 and 1.0.
  final double alpha;

  // The color space of the color.
  final RgbColorSpace colorSpace;

  /// Private constructor for creating a color.
  const Color(
    this.red,
    this.green,
    this.blue, [
    this.alpha = 1.0,
    this.colorSpace = RgbColorSpace.sRGB,
  ])  : assert(
          red >= 0.0 && red <= 1.0,
          'Red value must be between 0.0 and 1.0, but was $red',
        ),
        assert(
          green >= 0.0 && green <= 1.0,
          'Green value must be between 0.0 and 1.0, but was $green',
        ),
        assert(
          blue >= 0.0 && blue <= 1.0,
          'Blue value must be between 0.0 and 1.0, but was $blue',
        ),
        assert(
          alpha >= 0.0 && alpha <= 1.0,
          'Alpha value must be between 0.0 and 1.0, but was $alpha',
        );

  static const Color clear = Color(0, 0, 0, 0, RgbColorSpace.sRGB);
  static const Color black = Color(0, 0, 0, 1, RgbColorSpace.sRGB);
  static const Color white = Color(1, 1, 1, 1, RgbColorSpace.sRGB);

  /// Factory constructor for creating a color from RGB components.
  ///
  /// [red], [green], and [blue] are values between 0.0 and 1.0.
  /// [alpha] is an optional value between 0.0 and 1.0, defaulting to 1.0.
  /// [colorSpace] is an optional value specifying the color space, defaulting to sRGB.
  const Color.fromRGB(
    double red,
    double green,
    double blue, [
    double alpha = 1.0,
    RgbColorSpace colorSpace = RgbColorSpace.sRGB,
  ]) : this(red, green, blue, alpha, colorSpace);

  /// Factory constructor for creating a color from an HSV color.
  factory Color.fromHSV(HsvColor hsv) {
    return hsv.color;
  }

  /// Factory constructor for creating a color from an HSL color.
  factory Color.fromHSL(HslColor hsl) {
    return hsl.color;
  }

  /// Factory constructor for creating a color from a hex string.
  ///
  /// The [hex] string can be in the format "RRGGBB" or "AARRGGBB".
  /// It can optionally start with a "#" character.
  factory Color.fromHex(
    String hex, [
    double? alpha,
    RgbColorSpace colorSpace = RgbColorSpace.sRGB,
  ]) {
    // Remove the leading '#' if present
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }

    // Ensure the hex string is either 6 or 8 characters long
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add default alpha value if not provided
    } else if (hex.length != 8) {
      throw ArgumentError('Invalid hex string: $hex');
    }

    // Parse the hex string
    int value = int.parse(hex, radix: 16);
    int hexAlpha = (value & 0xFF000000) >> 24;
    int red = (value & 0x00FF0000) >> 16;
    int green = (value & 0x0000FF00) >> 8;
    int blue = value & 0x000000FF;

    // Create and return the Color object
    return Color.fromRGB(
      red / 255,
      green / 255,
      blue / 255,
      alpha ?? hexAlpha / 255,
      colorSpace,
    );
  }

  HslColor get hsl => HslColor.fromColor(this);
  HsvColor get hsv => HsvColor.fromColor(this);

  /// Returns true if the color is fully opaque.
  bool get isOpaque => alpha == 1.0;

  /// Returns true if the color is visible (alpha > 0).
  bool get isVisible => alpha > 0;

  bool get isDark => y < 0.5;
  bool get isLight => y >= 0.5;

  /// Calculates the luminance of the color and maps it to a range of -100 to 100.
  double get y {
    double linearize(double rgbComponent) {
      if (rgbComponent <= 0.040449936) {
        return rgbComponent / 12.92 * 100.0;
      } else {
        return pow((rgbComponent + 0.055) / 1.055, 2.4).toDouble() * 100.0;
      }
    }

    // Normalize and linearize each color channel
    double rLinear = linearize(red);
    double gLinear = linearize(green);
    double bLinear = linearize(blue);

    // Calculate relative luminance
    return (0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear) / 100;
  }

  double contrastAgainst(Color other) {
    double l1 = y;
    double l2 = other.y;
    return (max(l1, l2) + 0.05) / (min(l1, l2) + 0.05);
  }

  Color copyWith({
    double? red,
    double? green,
    double? blue,
    double? alpha,
    RgbColorSpace? colorSpace,
  }) {
    return Color.fromRGB(
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
      alpha ?? this.alpha,
      colorSpace ?? this.colorSpace,
    );
  }

  /// Returns a copy of the color with the alpha component set to the given value.
  Color withAlpha(double alpha) {
    return copyWith(alpha: alpha);
  }

  /// Returns a copy of the color with the red component set to the given value.
  Color withRed(double red) {
    return copyWith(red: red);
  }

  /// Returns a copy of the color with the green component set to the given value.
  Color withGreen(double green) {
    return copyWith(green: green);
  }

  /// Returns a copy of the color with the blue component set to the given value.
  Color withBlue(double blue) {
    return copyWith(blue: blue);
  }

  /// Returns a copy of the color with the color space set to the given value.
  Color withColorSpace(RgbColorSpace colorSpace) {
    return copyWith(colorSpace: colorSpace);
  }

  /// Converts the color to a Flutter [Color] object.
  ui.Color get uiColor {
    return ui.Color.fromARGB(
      (alpha * 255).round(),
      (red * 255).round(),
      (green * 255).round(),
      (blue * 255).round(),
    );
  }

  /// Linearly interpolates between two [Color] objects.
  static Color lerp(Color a, Color b, double t) => a.hsl.lerpTo(b.hsl, t).color;

  @override
  Color lerpFrom(Color other, double t) => lerp(other, this, t);

  @override
  Color lerpTo(Color other, double t) => lerp(this, other, t);

  @override
  int get hashCode => Object.hash(red, green, blue, alpha, colorSpace);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Color) return false;
    return red == other.red &&
        green == other.green &&
        blue == other.blue &&
        alpha == other.alpha &&
        colorSpace == other.colorSpace;
  }

  @override
  String toString() {
    return 'Color($red, $green, $blue, $alpha)';
  }

  @override
  Color clampingHue(double start, double end) {
    return hsl.clampingHue(start, end).color;
  }

  @override
  Color clampingLightness(
    double start,
    double end, {
    LightnessMode mode = LightnessMode.lightness,
  }) {
    return hsl.clampingLightness(start, end, mode: mode).color;
  }

  @override
  Color clampingSaturation(double start, double end) {
    return hsl.clampingSaturation(start, end).color;
  }

  @override
  Color darken(double amount, {LightnessMode mode = LightnessMode.lightness}) {
    return hsl.darken(amount, mode: mode).color;
  }

  @override
  Color desaturate(double amount) {
    return hsl.desaturate(amount).color;
  }

  @override
  Color lighten(double amount, {LightnessMode mode = LightnessMode.lightness}) {
    return hsl.lighten(amount, mode: mode).color;
  }

  @override
  Color rotateHue(double amount) {
    return hsl.rotateHue(amount).color;
  }

  @override
  Color saturate(double amount) {
    return hsl.saturate(amount).color;
  }

  @override
  Color withHue(double hue) {
    return hsl.withHue(hue).color;
  }

  @override
  Color withLightness(
    double lightness, {
    LightnessMode mode = LightnessMode.lightness,
  }) {
    if (mode == LightnessMode.value) {
      return hsv.withLightness(lightness, mode: mode).color;
    }
    return copyWith(red: red, green: green, blue: blue, alpha: alpha);
  }

  @override
  Color withSaturation(double saturation) {
    return hsl.withSaturation(saturation).color;
  }
}

/// Extension on Flutter's [Color] class to convert it to an [Color].
extension ColorExtension on ui.Color {
  /// Converts a Flutter [Color] to a [Color].
  Color get ouiColor {
    return Color.fromRGB(
      red / 255,
      green / 255,
      blue / 255,
      alpha / 255,
    );
  }
}

typedef DynamicColor = DynamicContainer<Color>;
typedef TieredColor = LeveledContainer<Color>;

enum LightnessMode {
  lightness,
  value,
}
