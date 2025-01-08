import '../../config/color_config.dart';
import '../../shared/generator.dart';
import '../color.dart';
import '../palette/color_palette.dart';
import 'base_color_generator.dart';
import 'color_palette_levels_generator.dart';

class ColorPaletteGenerator extends Generator<ColorPalette> {
  final ColorConfig config;

  ColorPaletteGenerator(this.config);

  @override
  ColorPalette generate() {
    final baseColorGenerator = BaseColorGenerator.fromColor(config.seed);
    return ColorPalette(
      levels: ColorPaletteLevelsGenerator(config).generate(),
      barrier: baseColorGenerator.generateFor<Color>(
        (color) => color.color.withAlpha(0.5),
      ),
    );
  }
}
