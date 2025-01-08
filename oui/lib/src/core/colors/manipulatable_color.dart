import 'package:oui/src/core/colors/color.dart';

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
}
