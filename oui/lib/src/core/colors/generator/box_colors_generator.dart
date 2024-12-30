import 'package:oui/src/core/colors/generator/accentable_color_generator.dart';
import 'package:oui/src/core/colors/hsl_color.dart';

import '../../shared/generator.dart';
import '../palette/accentable_color.dart';
import '../palette/box_colors.dart';

class BoxColorsGenerator extends Generator<BoxColors> {
  final HslColor baseColor;
  const BoxColorsGenerator(this.baseColor);

  AccentableColor _accentable(HslColor color) {
    return AccentableColorGenerator(
      color,
      color,
      color,
    ).generate();
  }

  @override
  BoxColors generate() {
    return BoxColors(
      content: _accentable(baseColor),
      surface: _accentable(baseColor),
      decoration: _accentable(baseColor),
      shadow: _accentable(baseColor),
      edge: _accentable(baseColor),
      placeholder: _accentable(baseColor),
    );
  }
}
