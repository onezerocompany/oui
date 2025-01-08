import 'package:oui/src/core/colors/color.dart';
import 'package:oui/src/core/colors/palette/accentable_color.dart';
import 'package:oui/src/core/shared/leveled_container.dart';
import 'package:test/test.dart';

void main() {
  group('AccentableColor Tests', () {
    test('Constructor initializes correctly', () {
      final normalColor = Color.fromHex('#0000FF');
      final levels = LeveledContainer<Color>([
        Color.fromHex('#0000FF'),
        Color.fromHex('#00FF00'),
        Color.fromHex('#FF0000'),
      ]);
      final accentableColor = AccentableColor(normalColor, levels);

      expect(accentableColor.normal, normalColor);
      expect(accentableColor.accented(0), Color.fromHex('#0000FF'));
      expect(accentableColor.accented(1), Color.fromHex('#00FF00'));
      expect(accentableColor.accented(2), Color.fromHex('#FF0000'));
    });

    test('Accessing level below bounds returns lowest level', () {
      final normalColor = Color.fromHex('#0000FF');
      final levels = LeveledContainer<Color>([
        Color.fromHex('#0000FF'),
        Color.fromHex('#00FF00'),
        Color.fromHex('#FF0000'),
      ]);
      final accentableColor = AccentableColor(normalColor, levels);

      expect(accentableColor.accented(-1), Color.fromHex('#0000FF'));
      expect(accentableColor.accented(-100), Color.fromHex('#0000FF'));
    });

    test('Accessing level above bounds returns highest level', () {
      final normalColor = Color.fromHex('#0000FF');
      final levels = LeveledContainer<Color>([
        Color.fromHex('#0000FF'),
        Color.fromHex('#00FF00'),
        Color.fromHex('#FF0000'),
      ]);
      final accentableColor = AccentableColor(normalColor, levels);

      expect(accentableColor.accented(3), Color.fromHex('#FF0000'));
      expect(accentableColor.accented(100), Color.fromHex('#FF0000'));
    });

    test('Normal color is correctly stored', () {
      final normalColor = Color.fromHex('#123456');
      final levels = LeveledContainer<Color>([
        Color.fromHex('#000000'),
      ]);
      final accentableColor = AccentableColor(normalColor, levels);

      expect(accentableColor.normal, normalColor);
    });

    test('Returns normal color when levels are empty', () {
      final normalColor = Color.fromHex('#0000FF');
      const levels = LeveledContainer<Color>([]);
      final accentableColor = AccentableColor(normalColor, levels);

      expect(accentableColor.accented(0), normalColor);
      expect(accentableColor.accented(1), normalColor);
      expect(accentableColor.accented(-1), normalColor);
    });

    test('Handles large number of levels', () {
      final normalColor = Color.fromHex('#0000FF');
      final levels = LeveledContainer<Color>(
        List.generate(
          1000,
          (index) =>
              Color.fromHex('#${index.toRadixString(16).padLeft(6, '0')}'),
        ),
      );
      final accentableColor = AccentableColor(normalColor, levels);

      expect(accentableColor.accented(999), Color.fromHex('#0003E7'));
    });

    test('Equality check', () {
      final normalColor = Color.fromHex('#0000FF');
      final levels = LeveledContainer<Color>([
        Color.fromHex('#0000FF'),
        Color.fromHex('#00FF00'),
        Color.fromHex('#FF0000'),
      ]);
      final accentableColor1 = AccentableColor(normalColor, levels);
      final accentableColor2 = AccentableColor(normalColor, levels);

      expect(accentableColor1, accentableColor2);
      expect(accentableColor1.hashCode, accentableColor2.hashCode);
    });

    test('Inequality check', () {
      final normalColor1 = Color.fromHex('#0000FF');
      final normalColor2 = Color.fromHex('#FF0000');
      final levels1 = LeveledContainer<Color>([
        Color.fromHex('#0000FF'),
        Color.fromHex('#00FF00'),
        Color.fromHex('#FF0000'),
      ]);
      final levels2 = LeveledContainer<Color>([
        Color.fromHex('#FF0000'),
        Color.fromHex('#00FF00'),
        Color.fromHex('#0000FF'),
      ]);
      final accentableColor1 = AccentableColor(normalColor1, levels1);
      final accentableColor2 = AccentableColor(normalColor2, levels2);

      expect(accentableColor1, isNot(accentableColor2));
      expect(accentableColor1.hashCode, isNot(accentableColor2.hashCode));
    });
  });
}
