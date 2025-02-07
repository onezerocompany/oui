import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

import '../visual_color_utils.dart';

void main() {
  group('ColorGenerator', () {
    final seed = HslColor.fromHSL(200, 1, 0.5).color;
    final config = ColorConfig(seed: seed, levels: 5);
    final colorGenerator = MonochromaticColorGenerator(config);

    test('should generate base colors correctly', () {
      final baseColors = colorGenerator.base;
      expect(baseColors, isNotNull);
    });

    test('should generate barrier colors correctly', () {
      final barrierColors = colorGenerator.barrier;
      expect(barrierColors, isNotNull);
    });

    test('should generate stateful box colors correctly', () {
      final color = Color.fromHex("#123456");
      final statefulColors =
          colorGenerator.statefulBoxColors(color, DynamicTheme.light);
      expect(statefulColors, isNotNull);
    });

    test('should generate leveled colors correctly', () {
      final baseColor = Color.fromHex("#123456");
      final leveledColors = colorGenerator.leveledColors(
        baseColor,
        DynamicTheme.light,
      );
      expect(leveledColors, isNotNull);
    });

    test('should generate color palette levels correctly', () {
      final levels = colorGenerator.levels;
      expect(levels, isNotNull);
    });

    visualColorTest(
      'base_colors',
      'Check that the base colors are correct',
      () {
        return <double>[0, 50, 100, 150, 200, 250, 300, 350].map((hue) {
          final color = HslColor.fromHSL(hue, 1, 0.5).color;
          final generator = MonochromaticColorGenerator(
            ColorConfig(seed: color, levels: 5),
          );
          return generator.base.keys.map((level) {
            return generator.base[level];
          }).toList();
        }).toList();
      },
    );

    visualColorTest(
      "leveled_colors",
      "Check that the leveled colors are correct",
      () {
        return colorGenerator.base.map((color, theme) {
          return colorGenerator.leveledColors(color, theme).all;
        }).all;
      },
    );

    visualColorTest(
      "box_colors",
      "Check that the normal box colors are correct",
      () {
        return <Color>[
          Color.fromHex("#123456"),
          Color.fromHex("#654321"),
          Color.fromHex("#abcdef"),
          Color.fromHex("#fedcba"),
        ].map((color) {
          final boxColors = MonochromaticColorGenerator.boxColors(
            color,
            DynamicTheme.light,
            State.normal,
          );
          return [
            boxColors.content.normal,
            boxColors.surface.normal,
            boxColors.decoration.normal,
            boxColors.shadow.normal,
            boxColors.edge.normal,
            boxColors.placeholder.normal,
          ];
        }).toList();
      },
    );

    // test three levels of accented box colors
    for (final level in List.generate(4, (i) => i)) {
      visualColorTest(
        "accented_box_colors_$level",
        "Check that the accented box colors are correct",
        () {
          return <Color>[
            Color.fromHex("#123456"),
            Color.fromHex("#654321"),
            Color.fromHex("#abcdef"),
            Color.fromHex("#fedcba"),
          ].map((color) {
            final boxColors = MonochromaticColorGenerator.boxColors(
              color,
              DynamicTheme.light,
              State.normal,
            );
            return [
              boxColors.content.accented(level),
              boxColors.surface.accented(level),
              boxColors.decoration.accented(level),
              boxColors.shadow.accented(level),
              boxColors.edge.accented(level),
              boxColors.placeholder.accented(level),
            ];
          }).toList();
        },
      );
    }

    visualColorTest(
      "stateful_colors",
      "Check all stateful colors for a box",
      () {
        final boxColors =
            colorGenerator.statefulBoxColors(seed, DynamicTheme.light);
        return State.values
            .map(
              (state) => [
                boxColors.get(state).content.normal,
                boxColors.get(state).surface.normal,
                boxColors.get(state).decoration.normal,
                boxColors.get(state).shadow.normal,
                boxColors.get(state).edge.normal,
                boxColors.get(state).placeholder.normal,
              ],
            )
            .toList();
      },
    );
  });
}
