import 'package:oui/oui.dart';

import '../shared/interpolation.dart';

/// A class representing a color in the HSL (Hue, Saturation, Lightness) color space.
class HslColor implements ManipulatableColor<HslColor>, Interpolable<HslColor> {
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
  static HslColor lerp(HslColor a, HslColor b, double t) {
    double lerpHue(double a, double b, double t) {
      final double delta = ((b - a + 180) % 360) - 180;
      return a + delta * t;
    }

    return HslColor._(
      lerpHue(a.hue, b.hue, t),
      lerpDouble(a.saturation, b.saturation, t),
      lerpDouble(a.lightness, b.lightness, t),
    );
  }

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
  HslColor lerpFrom(HslColor other, double t) {
    return HslColor.lerp(other, this, t);
  }

  @override
  HslColor lerpTo(HslColor other, double t) {
    return HslColor.lerp(this, other, t);
  }

  @override
  String toString() {
    return 'HslColor($hue, $saturation, $lightness)';
  }
}
