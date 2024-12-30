import 'package:oui/oui.dart';
import 'package:oui/src/core/colors/generator/leveled_color_generator.dart';
import 'package:oui/src/core/colors/palette/accentable_color.dart';

class AccentableColorGenerator extends Generator<AccentableColor> {
  final int depth;
  final LeveledColorGenerator _generator;
  final HslColor normal;

  const AccentableColorGenerator._(
    this.normal,
    this._generator,
    this.depth,
  );

  factory AccentableColorGenerator(
    HslColor normal,
    HslColor start,
    HslColor end, [
    int levels = 4,
  ]) {
    return AccentableColorGenerator._(
      normal,
      LeveledColorGenerator(
        start,
        end,
        levels,
      ),
      levels,
    );
  }

  @override
  AccentableColor generate() {
    return AccentableColor(
      normal.color,
      _generator.generateFor<Color>(
        (color) => color.color,
      ),
    );
  }
}
