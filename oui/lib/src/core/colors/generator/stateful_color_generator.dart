import 'package:oui/src/core/colors/hsl_color.dart';
import 'package:oui/src/core/shared/generator.dart';
import 'package:oui/src/core/shared/stateful_container.dart';

/// A generator that produces different HSL colors based on the given state.
class StatefulColorGenerator extends GeneratorWithInput<HslColor, State> {
  final HslColor baseColor;

  /// Creates a [StatefulColorGenerator] with the given base [baseColor].
  const StatefulColorGenerator(this.baseColor);

  /// The color used to represent an error state.
  HslColor get _errorColor => HslColor.fromHSL(0, 1, 0.5);

  /// The color used to represent a success state.
  HslColor get _successColor => HslColor.fromHSL(120, 1, 0.5);

  /// The color used to represent a warning state.
  HslColor get _warningColor => HslColor.fromHSL(60, 1, 0.5);

  /// Generates an HSL color based on the given [input] state.
  ///
  /// The color is modified according to the state:
  /// - [State.normal]: Returns the base color.
  /// - [State.highlighted]: Returns a slightly saturated and lightened version of the base color.
  /// - [State.disabled]: Returns a desaturated and darkened version of the base color.
  /// - [State.loading]: Returns a desaturated version of the base color.
  /// - [State.errored]: Returns a blend of the error color and the base color.
  /// - [State.succeeded]: Returns a blend of the success color and the base color.
  /// - [State.warned]: Returns a blend of the warning color and the base color.
  /// - [State.inactive]: Returns a desaturated version of the base color.
  @override
  HslColor generate(State input) {
    switch (input) {
      case State.normal:
        return baseColor;
      case State.highlighted:
        return baseColor.saturate(0.04).lighten(0.1);
      case State.disabled:
        return baseColor.withSaturation(0).withLightness(0.1);
      case State.loading:
        return baseColor.desaturate(0.4);
      case State.errored:
        return _errorColor.lerpWith(baseColor, 0.1);
      case State.succeeded:
        return _successColor.lerpWith(baseColor, 0.1);
      case State.warned:
        return _warningColor.lerpWith(baseColor, 0.1);
      case State.inactive:
        return baseColor.desaturate(0.4);
    }
  }

  StatefulContainer<T> generateFor<T>(T Function(HslColor color) generator) {
    return StatefulContainerGenerator<T>(
      (state) => generator(generate(state)),
    ).generate();
  }
}
