import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/colors/color.dart';
import 'package:oui/src/core/colors/generator/color_generator.dart';
import 'package:oui/src/core/shared/dynamic_container.dart';

void main() {
  group('ColorGenerator', () {
    test('should generate correct light and dark colors for light seed', () {
      final seed = Color.fromHex('#FFFFFF'); // Light color
      final generator = ColorGenerator.seed(seed);

      expect(generator.light.lightness, inInclusiveRange(0.6, 1.0));
      expect(generator.dark.lightness, inInclusiveRange(0.1, 0.4));
    });

    test('should generate correct light and dark colors for dark seed', () {
      final seed = Color.fromHex('#000000'); // Dark color
      final generator = ColorGenerator.seed(seed);

      expect(generator.light.lightness, inInclusiveRange(0.6, 0.9));
      expect(generator.dark.lightness, inInclusiveRange(0.1, 0.4));
    });

    test('should return correct base color for DynamicTheme', () {
      final seed = Color.fromHex('#808080'); // Neutral color
      final generator = ColorGenerator.seed(seed);

      expect(generator.getBaseFor(DynamicTheme.light), generator.light.color);
      expect(
        generator.getBaseFor(DynamicTheme.muted),
        generator.light.lerpWith(generator.dark, 0.2).color,
      );
      expect(
        generator.getBaseFor(DynamicTheme.dimmed),
        generator.dark.lerpWith(generator.light, 0.2).color,
      );
      expect(generator.getBaseFor(DynamicTheme.dark), generator.dark.color);
    });

    testWidgets('should match golden values for base colors',
        (WidgetTester tester) async {
      final colors = ColorGenerator.seed(Color.fromHex('#808080'));
      final row = Row(
        children: [
          Container(
            width: 100,
            height: 100,
            color: colors.getBaseFor(DynamicTheme.light).uiColor,
          ),
          Container(
            width: 100,
            height: 100,
            color: colors.getBaseFor(DynamicTheme.muted).uiColor,
          ),
          Container(
            width: 100,
            height: 100,
            color: colors.getBaseFor(DynamicTheme.dimmed).uiColor,
          ),
          Container(
            width: 100,
            height: 100,
            color: colors.getBaseFor(DynamicTheme.dark).uiColor,
          ),
        ],
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: row,
        ),
      );

      await expectLater(
        find.byType(Row),
        matchesGoldenFile('goldens/color_generator_test.png'),
      );
    });
  });
}
