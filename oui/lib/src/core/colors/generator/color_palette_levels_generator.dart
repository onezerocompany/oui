import 'package:oui/oui.dart';
import 'package:oui/src/core/colors/generator/base_color_generator.dart';
import 'package:oui/src/core/colors/generator/box_colors_generator.dart';
import 'package:oui/src/core/colors/generator/leveled_color_generator.dart';
import 'package:oui/src/core/colors/generator/stateful_color_generator.dart';

class ColorPaletteLevelsGenerator extends Generator<ColorPaletteLevels> {
  final int levels;
  final BaseColorGenerator baseColorGenerator;

  const ColorPaletteLevelsGenerator(
    this.baseColorGenerator,
    this.levels,
  );

  @override
  ColorPaletteLevels generate() {
    return baseColorGenerator.generateFor<LeveledStatefulBoxColors>(
      (baseColor) {
        return LeveledColorGenerator(
          baseColor,
          baseColor.color.isLight
              ? baseColor.darken(0.2)
              : baseColor.lighten(0.2),
          levels,
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
