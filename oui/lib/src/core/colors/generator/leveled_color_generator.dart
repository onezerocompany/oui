import 'package:oui/oui.dart';

import 'interpolated_color_generator.dart';

class LeveledColorGenerator extends Generator<LeveledContainer<HslColor>> {
  final int depth;
  final InterpolatedColorGenerator _generator;

  HslColor get first => _generator.first;
  HslColor get second => _generator.second;

  const LeveledColorGenerator._(
    this._generator,
    this.depth,
  );

  factory LeveledColorGenerator(
    HslColor first,
    HslColor second, [
    int levels = 5,
  ]) {
    return LeveledColorGenerator._(
      InterpolatedColorGenerator(
        first,
        second,
        levels,
      ),
      levels,
    );
  }

  @override
  LeveledContainer<HslColor> generate() {
    final colors = List.generate(
      depth,
      _generator.generate,
      growable: false,
    );
    return LeveledContainer(colors);
  }

  LeveledContainer<T> generateFor<T>(T Function(HslColor) generator) {
    final colors = List.generate(
      depth,
      (index) => generator(_generator.generate(index)),
      growable: false,
    );
    return LeveledContainer(colors);
  }
}
