import '../../shared/generator.dart';
import '../color.dart';
import '../hsl_color.dart';
import '../palette/accentable_color.dart';
import 'leveled_color_generator.dart';

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
