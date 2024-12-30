import 'package:oui/src/core/colors/generator/base_color_generator.dart';
import 'package:oui/src/core/colors/generator/color_palette_levels_generator.dart';

import '../../shared/generator.dart';
import '../color.dart';
import '../palette/color_palette.dart';

class ColorPaletteGenerator extends Generator<ColorPalette> {
  final BaseColorGenerator baseColorGenerator;

  const ColorPaletteGenerator(
    this.baseColorGenerator,
  );

  @override
  ColorPalette generate() {
    return ColorPalette(
      levels: ColorPaletteLevelsGenerator(
        baseColorGenerator,
        6,
      ).generate(),
      barrier: baseColorGenerator.generateFor<Color>(
        (color) => color.color.withAlpha(0.5),
      ),
    );
  }
}
