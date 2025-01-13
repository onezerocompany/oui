import 'dart:math';
import 'dart:ui' as ui show Color, Brightness;

import 'package:flutter/rendering.dart' as rendering
    show Gradient, SweepGradient, LinearGradient, RadialGradient, Offset;
import 'package:flutter/widgets.dart'
    show BuildContext, InheritedWidget, MediaQuery, Widget;
import 'package:oui/oui.dart';
import 'package:oui/src/core/interpolation.dart';

/// Enum representing different RGB color spaces.
enum RgbColorSpace {
  sRGB,
  extendedSRGB,
  displayP3,
}

/// A class representing a color with red, green, blue, and alpha components.
class Color with Interpolable<Color> implements ManipulatableColor<Color> {
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
  @override
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
    assert(
      red == null || (red >= 0.0 && red <= 1.0),
      'Red value must be between 0.0 and 1.0, but was $red',
    );
    assert(
      green == null || (green >= 0.0 && green <= 1.0),
      'Green value must be between 0.0 and 1.0, but was $green',
    );
    assert(
      blue == null || (blue >= 0.0 && blue <= 1.0),
      'Blue value must be between 0.0 and 1.0, but was $blue',
    );
    assert(
      alpha == null || (alpha >= 0.0 && alpha <= 1.0),
      'Alpha value must be between 0.0 and 1.0, but was $alpha',
    );
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

  @override
  Color lerp(Color a, Color b, double t) {
    return a.hsl.lerpTo(b.hsl, t).color;
  }
}

/// Extension on Flutter's [Color] class to convert it to an [Color].
extension ColorExtension on ui.Color {
  /// Converts a Flutter [Color] to a [Color].
  Color get ouiColor {
    return Color.fromRGB(
      r,
      g,
      b,
      a,
    );
  }
}

enum LightnessMode {
  lightness,
  value,
}

/// A class representing a color in the HSL (Hue, Saturation, Lightness) color space.
class HslColor
    with Interpolable<HslColor>
    implements ManipulatableColor<HslColor> {
  /// The hue of the color, in degrees [0, 360).
  ///
  /// Hue represents the color type and is measured in degrees on the color wheel.
  /// 0° is red, 120° is green, and 240° is blue.
  final double hue;

  /// The saturation of the color, as a percentage [0, 1].
  ///
  /// Saturation represents the intensity of the color.
  /// 0% is a shade of gray, and 100% is the full color.
  final double saturation;

  /// The lightness of the color, as a percentage [0, 1].
  ///
  /// Lightness represents the brightness of the color.
  /// 0% is black, 50% is neither light nor dark, and 100% is white.
  final double lightness;

  const HslColor._(
    this.hue, [
    this.saturation = 1.0,
    this.lightness = 0.5,
  ]);

  /// Creates an HSL color from the given hue, saturation, and lightness.
  ///
  /// The [hue] parameter must be in the range [0, 360) and represents the color's hue.
  /// It determines the type of color (e.g., red, green, blue) and is measured in degrees.
  ///
  /// The [saturation] parameter must be in the range [0, 1] and represents the intensity of the color.
  /// A saturation of 0 means the color is a shade of gray, and 1 means the color is fully saturated.
  ///
  /// The [lightness] parameter must be in the range [0, 1] and represents the brightness of the color.
  /// A lightness of 0 means the color is black, 0.5 means it is neither dark nor light, and 1 means it is white.
  ///
  /// Example:
  /// ```dart
  /// var color = HSLColor.fromAHSL(1.0, 120.0, 0.5, 0.5);
  /// ```
  /// [hue] must be in the range [0, 360).
  /// [saturation] and [lightness] must be in the range [0, 1].
  factory HslColor.fromHSL(
    double hue, [
    double saturation = 1.0,
    double lightness = 0.5,
  ]) {
    assert(hue >= 0 && hue < 360, 'Hue must be in the range [0, 360)');
    assert(
      saturation >= 0 && saturation <= 1,
      'Saturation must be in the range [0, 1]',
    );
    assert(
      lightness >= 0 && lightness <= 1,
      'Lightness must be in the range [0, 1]',
    );
    return HslColor._(hue, saturation, lightness);
  }

  /// Creates an HSL color from an RGB color.
  ///
  /// Converts the given [Color] from the RGB color space to the HSL color space.
  factory HslColor.fromColor(Color color) {
    final double red = color.red;
    final double green = color.green;
    final double blue = color.blue;

    final double max =
        red > green ? (red > blue ? red : blue) : (green > blue ? green : blue);
    final double min =
        red < green ? (red < blue ? red : blue) : (green < blue ? green : blue);

    double hue;
    if (max == min) {
      hue = 0.0;
    } else if (max == red) {
      hue = (60 * ((green - blue) / (max - min)) + 360) % 360;
    } else if (max == green) {
      hue = (60 * ((blue - red) / (max - min)) + 120) % 360;
    } else {
      hue = (60 * ((red - green) / (max - min)) + 240) % 360;
    }

    final double lightness = (max + min) / 2;
    final double saturation =
        max == min ? 0 : (max - min) / (1 - (2 * lightness - 1).abs());

    return HslColor._(hue, saturation, lightness);
  }

  /// Creates an HSL color from an HSV color.
  ///
  /// Converts the given [HsvColor] from the HSV color space to the HSL color space.
  factory HslColor.fromHSV(HsvColor hsv) {
    final double hue = hsv.hue;
    final double saturation = hsv.saturation;
    final double value = hsv.value;

    final double lightness = (2 - saturation) * value / 2;
    final double newSaturation = lightness == 0 || lightness == 1
        ? 0
        : (saturation * value) /
            (lightness < 0.5 ? lightness * 2 : 2 - lightness * 2);

    return HslColor._(hue, newSaturation, lightness);
  }

  /// Converts the HSL color to an RGB color and returns it as an [Color].
  ///
  /// The conversion is done using the HSL to RGB conversion formula.
  Color get color {
    final double c = (1 - (2 * lightness - 1).abs()) * saturation;
    final double x = c * (1 - ((hue / 60) % 2 - 1).abs());
    final double m = lightness - c / 2;

    double r, g, b;
    if (hue < 60) {
      r = c;
      g = x;
      b = 0;
    } else if (hue < 120) {
      r = x;
      g = c;
      b = 0;
    } else if (hue < 180) {
      r = 0;
      g = c;
      b = x;
    } else if (hue < 240) {
      r = 0;
      g = x;
      b = c;
    } else if (hue < 300) {
      r = x;
      g = 0;
      b = c;
    } else {
      r = c;
      g = 0;
      b = x;
    }

    return Color.fromRGB(r + m, g + m, b + m);
  }

  /// Converts the HSL color to an HSV color.
  ///
  /// The conversion is done using the HSL to HSV conversion formula.
  HsvColor get hsv => HsvColor.fromColor(color);

  /// Rotates the hue by the given amount.
  ///
  /// [amount] is in degrees and can be positive or negative.
  /// The resulting hue is wrapped around to stay within the range [0, 360).
  @override
  HslColor rotateHue(double amount) {
    return HslColor._(
      (hue + amount) % 360,
      saturation,
      lightness,
    );
  }

  /// Increases the saturation by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting saturation is clamped to stay within the range [0, 1].
  @override
  HslColor saturate(double amount) {
    return HslColor._(
      hue,
      (saturation + amount).clamp(0.0, 1.0),
      lightness,
    );
  }

  /// Decreases the saturation by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting saturation is clamped to stay within the range [0, 1].
  @override
  HslColor desaturate(double amount) {
    return HslColor._(
      hue,
      (saturation - amount).clamp(0.0, 1.0),
      lightness,
    );
  }

  /// Increases the lightness by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting lightness is clamped to stay within the range [0, 1].
  @override
  HslColor lighten(
    double amount, {
    LightnessMode mode = LightnessMode.lightness,
  }) {
    if (mode == LightnessMode.value) {
      return hsv.lighten(amount).hsl;
    }

    return HslColor._(
      hue,
      saturation,
      (lightness + amount).clamp(0.0, 1.0),
    );
  }

  /// Decreases the lightness by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting lightness is clamped to stay within the range [0, 1].
  @override
  HslColor darken(
    double amount, {
    LightnessMode mode = LightnessMode.lightness,
  }) {
    if (mode == LightnessMode.value) {
      return hsv.darken(amount).hsl;
    }
    return HslColor._(
      hue,
      saturation,
      (lightness - amount).clamp(0.0, 1.0),
    );
  }

  /// Linearly interpolates between two HSL colors.
  ///
  /// [a] and [b] are the colors to interpolate between.
  /// [t] is the interpolation factor and must be in the range [0, 1].
  /// The interpolation is done separately for hue, saturation, and lightness.
  // static HslColor lerp(HslColor a, HslColor b, double t) {
  //   double lerpHue(double a, double b, double t) {
  //     final double delta = ((b - a + 180) % 360) - 180;
  //     return a + delta * t;
  //   }

  //   return HslColor._(
  //     lerpHue(a.hue, b.hue, t),
  //     lerpDouble(a.saturation, b.saturation, t),
  //     lerpDouble(a.lightness, b.lightness, t),
  //   );
  // }

  /// Creates a copy of this color but with the given fields replaced with the new values.
  HslColor copyWith({
    double? hue,
    double? saturation,
    double? lightness,
  }) {
    return HslColor._(
      hue ?? this.hue,
      saturation ?? this.saturation,
      lightness ?? this.lightness,
    );
  }

  /// Creates a copy of this color but with the lightness replaced with the given value.
  @override
  HslColor withLightness(
    double lightness, {
    LightnessMode mode = LightnessMode.lightness,
  }) {
    if (mode == LightnessMode.value) {
      return hsv.withLightness(lightness, mode: mode).hsl;
    }
    return copyWith(lightness: lightness);
  }

  /// Creates a copy of this color but with the hue replaced with the given value.
  @override
  HslColor withHue(double hue) {
    return copyWith(hue: hue);
  }

  /// Creates a copy of this color but with the saturation replaced with the given value.
  @override
  HslColor withSaturation(double saturation) {
    return copyWith(saturation: saturation);
  }

  @override
  int get hashCode => Object.hash(hue, saturation, lightness);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HslColor) return false;
    return hue == other.hue &&
        saturation == other.saturation &&
        lightness == other.lightness;
  }

  @override
  HslColor clampingHue(double start, double end) {
    return HslColor._(
      hue.clamp(start, end),
      saturation,
      lightness,
    );
  }

  @override
  HslColor clampingLightness(
    double start,
    double end, {
    LightnessMode mode = LightnessMode.lightness,
  }) {
    if (mode == LightnessMode.value) {
      return hsv.clampingLightness(start, end).hsl;
    }
    return HslColor._(
      hue,
      saturation,
      lightness.clamp(start, end),
    );
  }

  @override
  HslColor clampingSaturation(double start, double end) {
    return HslColor._(
      hue,
      saturation.clamp(start, end),
      lightness,
    );
  }

  @override
  String toString() {
    return 'HslColor($hue, $saturation, $lightness)';
  }

  @override
  bool get isLight {
    return lightness > 0.5;
  }

  @override
  HslColor lerp(HslColor a, HslColor b, double t) {
    return HslColor._(
      const HueInterpolator().resolve(a.hue, b.hue, t),
      const DoubleInterpolator().resolve(a.saturation, b.saturation, t),
      const DoubleInterpolator().resolve(a.lightness, b.lightness, t),
    );
  }
}

/// A class representing a color in the HSV (Hue, Saturation, Value) color space.
class HsvColor
    with Interpolable<HsvColor>
    implements ManipulatableColor<HsvColor> {
  /// The hue of the color, in degrees [0, 360).
  ///
  /// Hue represents the color type and is measured in degrees on the color wheel.
  /// 0° is red, 120° is green, and 240° is blue.
  final double hue;

  /// The saturation of the color, as a percentage [0, 1].
  ///
  /// Saturation represents the intensity of the color.
  /// 0% is a shade of gray, and 100% is the full color.
  final double saturation;

  /// The value (brightness) of the color, as a percentage [0, 1].
  ///
  /// Value represents the brightness of the color.
  /// 0% is black, and 100% is the brightest color.
  final double value;

  const HsvColor._(
    this.hue, [
    this.saturation = 1.0,
    this.value = 1.0,
  ]);

  /// Creates an HSV color from the given hue, saturation, and value.
  ///
  /// [hue] must be in the range [0, 360).
  /// [saturation] and [value] must be in the range [0, 1].
  factory HsvColor.fromHSV(
    double hue, [
    double saturation = 1.0,
    double value = 1.0,
  ]) {
    assert(hue >= 0 && hue < 360, 'Hue must be in the range [0, 360)');
    assert(
      saturation >= 0 && saturation <= 1,
      'Saturation must be in the range [0, 1]',
    );
    assert(value >= 0 && value <= 1, 'Value must be in the range [0, 1]');
    return HsvColor._(hue, saturation, value);
  }

  /// Creates an HSV color from an HSL color.
  ///
  /// Converts the given [HslColor] from the HSL color space to the HSV color space.
  factory HsvColor.fromHSL(HslColor hsl) {
    final double hue = hsl.hue;
    final double lightness = hsl.lightness;
    final double saturation = hsl.saturation;

    final double value =
        lightness + saturation * (1 - (2 * lightness - 1).abs()) / 2;
    final double newSaturation = value == 0 ? 0 : 2 * (1 - lightness / value);

    return HsvColor._(hue, newSaturation, value);
  }

  /// Creates an HSV color from an RGB color.
  ///
  /// Converts the given [Color] from the RGB color space to the HSV color space.
  factory HsvColor.fromColor(Color color) {
    final double red = color.red;
    final double green = color.green;
    final double blue = color.blue;

    final double max =
        red > green ? (red > blue ? red : blue) : (green > blue ? green : blue);
    final double min =
        red < green ? (red < blue ? red : blue) : (green < blue ? green : blue);

    double hue;
    if (max == min) {
      hue = 0.0;
    } else if (max == red) {
      hue = (60 * ((green - blue) / (max - min)) + 360) % 360;
    } else if (max == green) {
      hue = (60 * ((blue - red) / (max - min)) + 120) % 360;
    } else {
      hue = (60 * ((red - green) / (max - min)) + 240) % 360;
    }

    final double saturation = max == 0 ? 0 : 1 - min / max;
    final double value = max;

    return HsvColor._(hue, saturation, value);
  }

  /// Converts the HSV color to an RGB color and returns it as an [Color].
  ///
  /// The conversion is done using the HSV to RGB conversion formula.
  Color get color {
    final int hi = ((hue / 60) % 6).floor();
    final double f = hue / 60 - hi;
    final double p = value * (1 - saturation);
    final double q = value * (1 - f * saturation);
    final double t = value * (1 - (1 - f) * saturation);

    switch (hi) {
      case 0:
        return Color.fromRGB(value, t, p);
      case 1:
        return Color.fromRGB(q, value, p);
      case 2:
        return Color.fromRGB(p, value, t);
      case 3:
        return Color.fromRGB(p, q, value);
      case 4:
        return Color.fromRGB(t, p, value);
      case 5:
        return Color.fromRGB(value, p, q);
      default:
        throw AssertionError('Invalid hue value: $hue');
    }
  }

  /// Converts the HSV color to an HSL color and returns it as an [HslColor].
  HslColor get hsl => HslColor.fromHSV(this);

  /// Rotates the hue by the given amount.
  ///
  /// [amount] is in degrees and can be positive or negative.
  /// The resulting hue is wrapped around to stay within the range [0, 360).
  @override
  HsvColor rotateHue(double amount) {
    return HsvColor._(
      (hue + amount) % 360,
      saturation,
      value,
    );
  }

  /// Increases the saturation by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting saturation is clamped to stay within the range [0, 1].
  @override
  HsvColor saturate(double amount) {
    return HsvColor._(
      hue,
      (saturation + amount).clamp(0.0, 1.0),
      value,
    );
  }

  /// Decreases the saturation by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting saturation is clamped to stay within the range [0, 1].
  @override
  HsvColor desaturate(double amount) {
    return HsvColor._(
      hue,
      (saturation - amount).clamp(0.0, 1.0),
      value,
    );
  }

  /// Increases the value by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting value is clamped to stay within the range [0, 1].
  @override
  HsvColor lighten(
    double amount, {
    LightnessMode mode = LightnessMode.value,
  }) {
    if (mode == LightnessMode.lightness) {
      return hsl.lighten(amount).hsv;
    }
    return HsvColor._(
      hue,
      saturation,
      (value + amount).clamp(0.0, 1.0),
    );
  }

  /// Decreases the value by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting value is clamped to stay within the range [0, 1].
  @override
  HsvColor darken(
    double amount, {
    LightnessMode mode = LightnessMode.value,
  }) {
    if (mode == LightnessMode.lightness) {
      return hsl.darken(amount).hsv;
    }
    return HsvColor._(
      hue,
      saturation,
      (value - amount).clamp(0.0, 1.0),
    );
  }

  @override
  int get hashCode => Object.hash(hue, saturation, value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HsvColor) return false;
    return hue == other.hue &&
        saturation == other.saturation &&
        value == other.value;
  }

  @override
  HsvColor clampingHue(double start, double end) {
    return HsvColor._(
      hue.clamp(start, end),
      saturation,
      value,
    );
  }

  @override
  HsvColor clampingLightness(
    double start,
    double end, {
    LightnessMode mode = LightnessMode.value,
  }) {
    if (mode == LightnessMode.lightness) {
      return hsl.clampingLightness(start, end).hsv;
    }
    return HsvColor._(
      hue,
      saturation,
      value.clamp(start, end),
    );
  }

  @override
  HsvColor clampingSaturation(double start, double end) {
    return HsvColor._(
      hue,
      saturation.clamp(start, end),
      value,
    );
  }

  @override
  HsvColor withHue(double hue) {
    return HsvColor._(hue, saturation, value);
  }

  @override
  HsvColor withLightness(
    double lightness, {
    LightnessMode mode = LightnessMode.value,
  }) {
    if (mode == LightnessMode.lightness) {
      return hsl.withLightness(lightness).hsv;
    }
    return HsvColor._(
      hue,
      saturation,
      lightness,
    );
  }

  @override
  HsvColor withSaturation(double saturation) {
    return HsvColor._(hue, saturation, value);
  }

  @override
  bool get isLight {
    return value > 0.5;
  }

  @override
  HsvColor lerp(HsvColor a, HsvColor b, double t) {
    return HsvColor._(
      const HueInterpolator().resolve(a.hue, b.hue, t),
      const DoubleInterpolator().resolve(a.saturation, b.saturation, t),
      const DoubleInterpolator().resolve(a.value, b.value, t),
    );
  }
}

/// An abstract class representing a color that can be manipulated.
///
/// This class provides methods to adjust lightness, saturation, and hue of a color.
abstract class ManipulatableColor<T> {
  /// Lightens the color by the given [amount].
  ///
  /// The [mode] parameter specifies the lightness mode to use.
  T lighten(
    double amount, {
    LightnessMode mode = LightnessMode.lightness,
  });

  /// Darkens the color by the given [amount].
  ///
  /// The [mode] parameter specifies the lightness mode to use.
  T darken(
    double amount, {
    LightnessMode mode = LightnessMode.lightness,
  });

  /// Sets the lightness of the color to the given [lightness].
  ///
  /// The [mode] parameter specifies the lightness mode to use.
  T withLightness(
    double lightness, {
    LightnessMode mode = LightnessMode.lightness,
  });

  /// Clamps the lightness of the color between [start] and [end].
  ///
  /// The [mode] parameter specifies the lightness mode to use.
  T clampingLightness(
    double start,
    double end, {
    LightnessMode mode = LightnessMode.lightness,
  });

  /// Saturates the color by the given [amount].
  T saturate(double amount);

  /// Desaturate the color by the given [amount].
  T desaturate(double amount);

  /// Sets the saturation of the color to the given [saturation].
  T withSaturation(double saturation);

  /// Clamps the saturation of the color between [start] and [end].
  T clampingSaturation(double start, double end);

  /// Rotates the hue of the color by the given [amount].
  T rotateHue(double amount);

  /// Sets the hue of the color to the given [hue].
  T withHue(double hue);

  /// Clamps the hue of the color between [start] and [end].
  T clampingHue(double start, double end);

  bool get isLight;
}

typedef DynamicColor = DynamicContainer<Color>;
typedef StatefulBoxColors = StatefulContainer<BoxColors>;
typedef LeveledStatefulBoxColors = LeveledContainer<StatefulBoxColors>;
typedef ColorPaletteLevels = DynamicContainer<LeveledStatefulBoxColors>;

class ColorGenerator {
  final ColorConfig config;

  const ColorGenerator(this.config);

  static HslColor get _errorColor => HslColor.fromHSL(0, 1, 0.5);
  static HslColor get _successColor => HslColor.fromHSL(120, 1, 0.5);
  static HslColor get _warningColor => HslColor.fromHSL(60, 1, 0.5);

  DynamicColor get base {
    final seed = config.seed.hsl;

    final light = seed.isLight
        ? seed.clampingLightness(0.6, 1)
        : seed.lighten(0.4).clampingLightness(0.6, 0.9);

    final dark = seed.isLight
        ? seed.darken(0.4).clampingLightness(0.1, 0.4)
        : seed.clampingLightness(0.1, 0.4);

    return DynamicContainer<Color>.generate((theme) {
      switch (theme) {
        case DynamicTheme.light:
          return light.color;
        case DynamicTheme.muted:
          return light.lerpTo(dark, 0.2).color;
        case DynamicTheme.dimmed:
          return dark.lerpTo(light, 0.2).color;
        case DynamicTheme.dark:
          return dark.color;
      }
    });
  }

  DynamicColor get barrier {
    return base.map(
      (color) => color.withAlpha(0.5),
    );
  }

  Color _colorForState(State input, Color color) {
    final hsl = color.hsl;
    switch (input) {
      case State.normal:
        return color;
      case State.highlighted:
        return hsl.saturate(0.04).lighten(0.1).color;
      case State.disabled:
        return hsl.withSaturation(0).withLightness(0.1).color;
      case State.loading:
        return hsl.desaturate(0.4).color;
      case State.errored:
        return _errorColor.lerpTo(hsl, 0.3).color;
      case State.succeeded:
        return _successColor.lerpTo(hsl, 0.3).color;
      case State.warned:
        return _warningColor.lerpTo(hsl, 0.3).color;
      case State.inactive:
        return hsl.desaturate(0.4).color;
    }
  }

  Color _colorForLevel(int level, Color color) {
    final t = level / config.levels;
    const interpolator = Interpolator<HslColor>();
    final hsl = color.hsl;
    return interpolator
        .resolve(
          hsl,
          hsl.isLight ? hsl.darken(0.3) : hsl.lighten(0.3),
          t,
        )
        .color;
  }

  StatefulBoxColors statefulBoxColors(
    Color color, [
    StatefulBoxColors? previous,
  ]) {
    return StatefulContainer<BoxColors>.generate((state) {
      return BoxColors.generate(
        _colorForState(state, color),
        previous?.get(state),
      );
    });
  }

  LeveledContainer<Color> leveledColors(Color base) {
    return LeveledContainer.generate(
      (level) {
        return _colorForLevel(level, base);
      },
      config.levels,
    );
  }

  ColorPaletteLevels get levels {
    StatefulBoxColors? previousLevel;
    return base.map<LeveledStatefulBoxColors>(
      (base) => leveledColors(base).map<StatefulBoxColors>(
        (color) {
          previousLevel = statefulBoxColors(color, previousLevel);
          return previousLevel!;
        },
      ),
    );
  }
}

class AccentableColor {
  final Color normal;
  final LeveledContainer<Color> _levels;

  /// Creates an [AccentableColor] with a normal color and a leveled container of colors.
  ///
  /// The [normal] color must not be null.
  /// The [_levels] container must not be null.
  const AccentableColor(
    this.normal,
    this._levels,
  );

  static AccentableColor generate(
    Color normal,
    Color start,
    Color end, [
    int depth = 3,
  ]) {
    const interpolator = Interpolator<HslColor>();
    return AccentableColor(
      normal,
      LeveledContainer.generate(
        (level) {
          final t = level / depth;
          return interpolator
              .resolve(
                start.hsl,
                end.hsl,
                t,
              )
              .color;
        },
        depth,
      ),
    );
  }

  /// Returns the color at the specified [level].
  ///
  /// If the levels container is empty, returns the normal color.
  Color accented(int level) {
    if (_levels.isEmpty) {
      return normal;
    }
    return _levels.get(level);
  }

  @override
  int get hashCode {
    return _levels.hashCode ^ normal.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AccentableColor) return false;
    return _levels == other._levels && normal == other.normal;
  }
}

class BoxColors {
  final AccentableColor surface;
  final AccentableColor content;
  final AccentableColor decoration;
  final AccentableColor shadow;
  final AccentableColor edge;
  final AccentableColor placeholder;

  const BoxColors({
    required this.content,
    required this.surface,
    required this.decoration,
    required this.shadow,
    required this.edge,
    required this.placeholder,
  });

  static BoxColors generate(Color base, [BoxColors? previous]) {
    if (base.isLight) {
      final surface =
          base.clampingSaturation(0, 0.01).clampingLightness(0, 0.1);
      return BoxColors(
        content: AccentableColor.generate(
          base,
          base,
          base,
        ),
        surface: AccentableColor.generate(
          surface,
          surface,
          surface,
        ),
        decoration: AccentableColor.generate(
          base,
          base,
          base,
        ),
        shadow: AccentableColor.generate(
          (previous?.content.normal ?? base).darken(0.1),
          (previous?.content.normal ?? base).darken(0.15),
          (previous?.content.normal ?? base).darken(0.15),
        ),
        edge: AccentableColor.generate(
          (base).darken(0.1),
          base.darken(0.1),
          base.darken(0.1),
        ),
        placeholder: AccentableColor.generate(
          base,
          base,
          base,
        ),
      );
    } else {
      final surface =
          base.clampingSaturation(0, 0.01).clampingLightness(0, 0.1);
      return BoxColors(
        content: AccentableColor.generate(
          base,
          base,
          base,
        ),
        surface: AccentableColor.generate(
          surface,
          surface,
          surface,
        ),
        decoration: AccentableColor.generate(
          base,
          base,
          base,
        ),
        shadow: AccentableColor.generate(
          (previous?.content.normal ?? base).darken(0.1),
          (previous?.content.normal ?? base).darken(0.15),
          (previous?.content.normal ?? base).darken(0.15),
        ),
        edge: AccentableColor.generate(
          (base).darken(0.1),
          base.darken(0.1),
          base.darken(0.1),
        ),
        placeholder: AccentableColor.generate(
          base,
          base,
          base,
        ),
      );
    }
  }

  @override
  int get hashCode {
    return Object.hash(
      content,
      surface,
      decoration,
      shadow,
      edge,
      placeholder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BoxColors) return false;
    return content == other.content &&
        surface == other.surface &&
        decoration == other.decoration &&
        shadow == other.shadow &&
        edge == other.edge &&
        placeholder == other.placeholder;
  }
}

class ColorPaletteDetails {
  final ColorPaletteAlgorithm algorithm;
  final int levels;

  const ColorPaletteDetails({
    this.algorithm = ColorPaletteAlgorithm.monochromatic,
    this.levels = 5,
  });
}

class HueInterpolator {
  final Curve curve;
  const HueInterpolator({
    this.curve = const LinearCurve(),
  });

  double resolve(double a, double b, double t) {
    final distance = ((b - a + 540) % 360) - 180;
    return (a + distance * curve.transform(t)) % 360;
  }
}

enum ColorPaletteAlgorithm {
  /// A color palette that uses a single color.
  monochromatic,
}

class ColorPalette {
  /// The levels of the color palette.
  final ColorPaletteLevels levels;

  /// A dynamic color used as a barrier.
  final DynamicColor barrier;

  /// Creates a new instance of [ColorPalette].
  const ColorPalette({
    required this.levels,
    required this.barrier,
  });

  static ColorPalette generate(ColorConfig config) {
    final generator = ColorGenerator(config);
    return ColorPalette(
      levels: generator.levels,
      barrier: generator.barrier,
    );
  }

  @override
  int get hashCode {
    return Object.hash(levels, barrier);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ColorPalette) return false;
    return levels == other.levels && barrier == other.barrier;
  }

  @override
  String toString() {
    return 'ColorPalette(\n  levels: $levels,\n  barrier: $barrier\n)';
  }
}

/// Enum representing the types of gradients available.
enum GradientType {
  linear,
  radial,
  sweep,
}

/// Class representing a gradient stop with an offset and a color.
class GradientStop {
  /// The offset of the gradient stop.
  final double offset;

  /// The color of the gradient stop.
  final Color color;

  /// Creates a gradient stop with the given offset and color.
  GradientStop(this.offset, this.color);
}

/// Class representing a gradient with multiple stops, direction, and type.
class Gradient {
  /// The list of gradient stops.
  final List<GradientStop> stops;

  /// The direction of the gradient flow.
  final FlowDirection direction;

  /// The type of the gradient.
  final GradientType type;

  /// Creates a gradient with the given stops, direction, and type.
  const Gradient({
    required this.stops,
    this.direction = FlowDirection.leftToRight,
    this.type = GradientType.linear,
  });

  /// Creates a linear gradient with the given stops and direction.
  const Gradient.linear({
    required List<GradientStop> stops,
    FlowDirection direction = FlowDirection.topToBottom,
  }) : this(
          stops: stops,
          direction: direction,
          type: GradientType.linear,
        );

  /// Creates a radial gradient with the given stops.
  const Gradient.radial({
    required List<GradientStop> stops,
  }) : this(
          stops: stops,
          type: GradientType.radial,
        );

  /// Creates a sweep gradient with the given stops.
  const Gradient.sweep({
    required List<GradientStop> stops,
  }) : this(
          stops: stops,
          type: GradientType.sweep,
        );

  /// Converts the Gradient to a Flutter Gradient.
  rendering.Gradient get uiGradient {
    final List<rendering.Offset> offsets = stops.map((stop) {
      return rendering.Offset(stop.offset, 0);
    }).toList();

    final List<ui.Color> colors = stops.map((stop) {
      return stop.color.uiColor;
    }).toList();

    switch (type) {
      case GradientType.linear:
        return rendering.LinearGradient(
          colors: colors,
          stops: offsets.map((offset) => offset.dx).toList(),
          begin: direction.begin,
          end: direction.end,
        );
      case GradientType.radial:
        return rendering.RadialGradient(
          colors: colors,
          stops: offsets.map((offset) => offset.dx).toList(),
          radius: 1,
        );
      case GradientType.sweep:
        return rendering.SweepGradient(
          colors: colors,
          stops: offsets.map((offset) => offset.dx).toList(),
          startAngle: 0,
          endAngle: 2 * 3.14,
        );
    }
  }

  @override
  int get hashCode {
    return Object.hash(stops, direction, type);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Gradient) return false;
    return stops == other.stops &&
        direction == other.direction &&
        type == other.type;
  }
}

/// Enum representing different themes for dynamic colors in the Oui library.
///
/// The `DynamicTheme` enum provides four different themes:
///
/// - `light`: Represents a light theme.
/// - `muted`: Represents a slightly darkened light theme.
/// - `dimmed`: Represents a slightly lifted dark theme.
/// - `dark`: Represents a dark theme.
enum DynamicTheme {
  light,
  muted,
  dimmed,
  dark;

  static DynamicTheme forContext(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;

    if (brightness == ui.Brightness.dark) {
      return DynamicTheme.dark;
    } else {
      return DynamicTheme.light;
    }
  }
}

class DynamicContainer<T> extends EnumContainer<DynamicTheme, T> {
  DynamicContainer(super.values);

  DynamicContainer.generate(
    T Function(DynamicTheme) generator,
  ) : super.generate(
          generator,
          DynamicTheme.values,
        );

  DynamicContainer<R> map<R>(R Function(T value) mapper) {
    return DynamicContainer<R>.generate(
      (theme) => mapper(get(theme)),
    );
  }

  @override
  List<DynamicTheme> get keys => DynamicTheme.values;

  @override
  @override
  String toString() {
    return 'DynamicContainer('
        'light: ${get(DynamicTheme.light)}, '
        'muted: ${get(DynamicTheme.muted)}, '
        'dimmed: ${get(DynamicTheme.dimmed)}, '
        'dark: ${get(DynamicTheme.dark)})';
  }
}

class ComponentAccent extends InheritedWidget {
  final int accent;

  const ComponentAccent({
    super.key,
    required this.accent,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return accent != (oldWidget as ComponentAccent).accent;
  }

  static int of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<ComponentAccent>()
            ?.accent ??
        0;
  }
}

extension ComponentAccentExtension on BuildContext {
  int get accent {
    return ComponentAccent.of(this);
  }
}

class AccentModifier extends ComponentModifier with ChildModifier {
  final int accent;

  const AccentModifier(this.accent);

  @override
  Widget? modify(Widget? child, ComponentContext context) {
    if (child == null) return null;
    return ComponentAccent(
      accent: accent,
      child: child,
    );
  }
}

mixin ModifiableAccent<Type extends Component> on Component<Type> {
  Type accented([int accent = 1]) {
    return withModifier(AccentModifier(accent));
  }
}
