import 'package:oui/oui.dart';

class ColorPaletteLevelsGenerator extends Generator<ColorPaletteLevels> {
  final ColorConfig config;

  const ColorPaletteLevelsGenerator(
    this.config,
  );

  @override
  ColorPaletteLevels generate() {
    final baseColorGenerator = BaseColorGenerator.fromColor(config.seed);
    return baseColorGenerator.generateFor<LeveledStatefulBoxColors>(
      (baseColor) {
        return LeveledColorGenerator(
          baseColor,
          baseColor.color.isLight
              ? baseColor.darken(0.2)
              : baseColor.lighten(0.2),
          config.levels,
        ).generateFor<StatefulBoxColors>(
          (leveledColor) {
            return StatefulColorGenerator(leveledColor).generateFor<BoxColors>(
              (stateColor) {
                return BoxColorsGenerator(stateColor).generate();
              },
            );
          },
        );
      },
    );
  }
}
