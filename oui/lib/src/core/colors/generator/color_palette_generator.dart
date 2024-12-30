import 'package:oui/src/core/colors/generator/base_color_generator.dart';
import 'package:oui/src/core/colors/generator/color_palette_levels_generator.dart';
import 'package:oui/src/core/config/color_config.dart';

import '../../shared/generator.dart';
import '../color.dart';
import '../palette/color_palette.dart';

class ColorPaletteGenerator extends Generator<ColorPalette> {
  final ColorConfig config;
  late final BaseColorGenerator _baseColorGenerator;

  ColorPaletteGenerator(this.config) {
    _baseColorGenerator = BaseColorGenerator.fromColor(config.seed);
  }

  @override
  ColorPalette generate() {
    return ColorPalette(
      levels: ColorPaletteLevelsGenerator(
        _baseColorGenerator,
        6,
      ).generate(),
      barrier: _baseColorGenerator.generateFor<Color>(
        (color) => color.color.withAlpha(0.5),
      ),
    );
  }
}
