import 'package:oui/src/core/colors/oui_color_hsv.dart';

import 'oui_color.dart';

/// A class representing a color in the HSL (Hue, Saturation, Lightness) color space.
class OuiColorHsl {
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

  const OuiColorHsl._(
    this.hue, [
    this.saturation = 1.0,
    this.lightness = 0.5,
  ]);

  /// Creates an HSL color from the given hue, saturation, and lightness.
  ///
  /// [hue] must be in the range [0, 360).
  /// [saturation] and [lightness] must be in the range [0, 1].
  factory OuiColorHsl.fromHSL(
    double hue, [
    double saturation = 1.0,
    double lightness = 0.5,
  ]) {
    assert(hue >= 0 && hue < 360, 'Hue must be in the range [0, 360)');
    assert(saturation >= 0 && saturation <= 1,
        'Saturation must be in the range [0, 1]');
    assert(lightness >= 0 && lightness <= 1,
        'Lightness must be in the range [0, 1]');
    return OuiColorHsl._(hue, saturation, lightness);
  }

  /// Creates an HSL color from an RGB color.
  ///
  /// Converts the given [OuiColor] from the RGB color space to the HSL color space.
  factory OuiColorHsl.fromColor(OuiColor color) {
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
        max == 0 ? 0 : (max - min) / (1 - (2 * lightness - 1).abs());

    return OuiColorHsl._(hue, saturation, lightness);
  }

  /// Creates an HSL color from an HSV color.
  ///
  /// Converts the given [OuiColorHsv] from the HSV color space to the HSL color space.
  factory OuiColorHsl.fromHSV(OuiColorHsv hsv) {
    final double hue = hsv.hue;
    final double saturation = hsv.saturation;
    final double value = hsv.value;

    final double lightness = value - saturation * value / 2;
    final double newSaturation = lightness == 0 || lightness == 1
        ? 0
        : (value - lightness) / (lightness < 0.5 ? lightness : 1 - lightness);

    return OuiColorHsl._(hue, newSaturation, lightness);
  }

  /// Converts the HSL color to an RGB color and returns it as an [OuiColor].
  ///
  /// The conversion is done using the HSL to RGB conversion formula.
  OuiColor get color {
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

    return OuiColor.fromRGB(r + m, g + m, b + m);
  }

  /// Converts the HSL color to an HSV color.
  ///
  /// The conversion is done using the HSL to HSV conversion formula.
  OuiColorHsv get hsv => OuiColorHsv.fromColor(color);

  /// Rotates the hue by the given amount.
  ///
  /// [amount] is in degrees and can be positive or negative.
  /// The resulting hue is wrapped around to stay within the range [0, 360).
  OuiColorHsl rotateHue(double amount) {
    return OuiColorHsl._(
      (hue + amount) % 360,
      saturation,
      lightness,
    );
  }

  /// Increases the saturation by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting saturation is clamped to stay within the range [0, 1].
  OuiColorHsl saturate(double amount) {
    return OuiColorHsl._(
      hue,
      (saturation + amount).clamp(0.0, 1.0),
      lightness,
    );
  }

  /// Decreases the saturation by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting saturation is clamped to stay within the range [0, 1].
  OuiColorHsl desaturate(double amount) {
    return OuiColorHsl._(
      hue,
      (saturation - amount).clamp(0.0, 1.0),
      lightness,
    );
  }

  /// Increases the lightness by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting lightness is clamped to stay within the range [0, 1].
  OuiColorHsl lighten(double amount) {
    return OuiColorHsl._(
      hue,
      saturation,
      (lightness + amount).clamp(0.0, 1.0),
    );
  }

  /// Decreases the lightness by the given amount.
  ///
  /// [amount] must be in the range [0, 1].
  /// The resulting lightness is clamped to stay within the range [0, 1].
  OuiColorHsl darken(double amount) {
    return OuiColorHsl._(
      hue,
      saturation,
      (lightness - amount).clamp(0.0, 1.0),
    );
  }

  /// Linearly interpolates between this color and another HSL color.
  ///
  /// [t] is the interpolation factor and must be in the range [0, 1].
  /// The interpolation is done separately for hue, saturation, and lightness.
  OuiColorHsl lerpWith(OuiColorHsl other, double t) {
    double lerpHue(double a, double b, double t) {
      final double delta = ((b - a + 180) % 360) - 180;
      return a + delta * t;
    }

    return OuiColorHsl._(
      lerpHue(hue, other.hue, t),
      saturation + (other.saturation - saturation) * t,
      lightness + (other.lightness - lightness) * t,
    );
  }
}
