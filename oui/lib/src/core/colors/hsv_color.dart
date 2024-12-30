import 'color.dart';

/// A class representing a color in the HSV (Hue, Saturation, Value) color space.
class HsvColor {
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

  /// Rotates the hue by the given amount.
  ///
  /// [amount] is in degrees and can be positive or negative.
  /// The resulting hue is wrapped around to stay within the range [0, 360).
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
  HsvColor lighten(double amount) {
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
  HsvColor darken(double amount) {
    return HsvColor._(
      hue,
      saturation,
      (value - amount).clamp(0.0, 1.0),
    );
  }

  /// Linearly interpolates between this color and another HSV color.
  ///
  /// [t] is the interpolation factor and must be in the range [0, 1].
  /// The interpolation is done separately for hue, saturation, and value.
  HsvColor lerpWith(HsvColor other, double t) {
    double lerpHue(double a, double b, double t) {
      final double delta = ((b - a + 180) % 360) - 180;
      return a + delta * t;
    }

    return HsvColor._(
      lerpHue(hue, other.hue, t),
      saturation + (other.saturation - saturation) * t,
      value + (other.value - value) * t,
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
}
