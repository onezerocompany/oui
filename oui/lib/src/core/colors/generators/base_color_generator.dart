import '../../shared/dynamic_container.dart';
import '../../shared/generator.dart';
import '../color.dart';
import '../hsl_color.dart';

class BaseColorGenerator extends GeneratorWithInput<HslColor, DynamicTheme> {
  final HslColor light;
  final HslColor dark;

  const BaseColorGenerator(
    this.light,
    this.dark,
  );

  factory BaseColorGenerator.fromColor(Color seed) {
    final hsl = seed.hsl;

    final light = seed.isLight
        ? hsl.clampingLightness(0.6, 1)
        : hsl.lighten(0.4).clampingLightness(0.6, 0.9);

    final dark = seed.isDark
        ? hsl.clampingLightness(0.1, 0.4)
        : hsl.darken(0.4).clampingLightness(0.1, 0.4);

    return BaseColorGenerator(light, dark);
  }

  @override
  HslColor generate(DynamicTheme input) {
    switch (input) {
      case DynamicTheme.light:
        return light;
      case DynamicTheme.muted:
        return light.lerpTo(dark, 0.2);
      case DynamicTheme.dimmed:
        return light.lerpTo(light, 0.2);
      case DynamicTheme.dark:
        return dark;
    }
  }

  DynamicContainer<T> generateFor<T>(T Function(HslColor color) generator) {
    return DynamicContainerGenerator<T>(
      (theme) => generator(
        generate(theme),
      ),
    ).generate();
  }
}
