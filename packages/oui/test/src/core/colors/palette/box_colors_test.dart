import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/colors.dart';
import 'package:oui/src/core/utils.dart';

void main() {
  group('BoxColors', () {
    test('should correctly compare two identical BoxColors instances', () {
      final color1 = AccentableColor(
        Color.black,
        LeveledContainer<Color>([
          Color.fromHex("#123456"),
        ]),
      );

      final color2 = AccentableColor(
        Color.white,
        LeveledContainer<Color>([
          Color.fromHex("#654321"),
        ]),
      );

      final boxColors1 = AccentableBoxColors(
        content: color1,
        surface: color2,
        decoration: color1,
        shadow: color2,
        edge: color1,
        placeholder: color2,
      );

      final boxColors2 = AccentableBoxColors(
        content: color1,
        surface: color2,
        decoration: color1,
        shadow: color2,
        edge: color1,
        placeholder: color2,
      );

      expect(boxColors1, equals(boxColors2));
    });

    test('should correctly compare two different BoxColors instances', () {
      final color1 = AccentableColor(
        Color.black,
        LeveledContainer<Color>([
          Color.fromHex("#123456"),
        ]),
      );

      final color2 = AccentableColor(
        Color.white,
        LeveledContainer<Color>([
          Color.fromHex("#654321"),
        ]),
      );

      final color3 = AccentableColor(
        Color.fromHex("#abcdef"),
        LeveledContainer<Color>([
          Color.fromHex("#fedcba"),
        ]),
      );

      final boxColors1 = AccentableBoxColors(
        content: color1,
        surface: color2,
        decoration: color1,
        shadow: color2,
        edge: color1,
        placeholder: color2,
      );

      final boxColors2 = AccentableBoxColors(
        content: color1,
        surface: color3,
        decoration: color1,
        shadow: color2,
        edge: color1,
        placeholder: color2,
      );

      expect(boxColors1, isNot(equals(boxColors2)));
    });

    test('should correctly compute hashCode', () {
      final color1 = AccentableColor(
        Color.black,
        LeveledContainer<Color>([
          Color.fromHex("#123456"),
        ]),
      );

      final color2 = AccentableColor(
        Color.white,
        LeveledContainer<Color>([
          Color.fromHex("#654321"),
        ]),
      );

      final boxColors = AccentableBoxColors(
        content: color1,
        surface: color2,
        decoration: color1,
        shadow: color2,
        edge: color1,
        placeholder: color2,
      );

      expect(
        boxColors.hashCode,
        equals(
          Object.hash(
            color1,
            color2,
            color1,
            color2,
            color1,
            color2,
          ),
        ),
      );
    });

    test('Deep Copy Test', () {
      final color1 = AccentableColor(
        Color.black,
        LeveledContainer<Color>([
          Color.fromHex("#123456"),
        ]),
      );

      final boxColors1 = AccentableBoxColors(
        content: color1,
        surface: color1,
        decoration: color1,
        shadow: color1,
        edge: color1,
        placeholder: color1,
      );

      final boxColors2 = AccentableBoxColors(
        content: color1,
        surface: color1,
        decoration: color1,
        shadow: color1,
        edge: color1,
        placeholder: color1,
      );

      expect(boxColors1, equals(boxColors2));
      expect(boxColors1, isNot(same(boxColors2)));
    });

    test('Equality with Null Test', () {
      final color1 = AccentableColor(
        Color.black,
        LeveledContainer<Color>([
          Color.fromHex("#123456"),
        ]),
      );

      final boxColors = AccentableBoxColors(
        content: color1,
        surface: color1,
        decoration: color1,
        shadow: color1,
        edge: color1,
        placeholder: color1,
      );

      expect(boxColors, isNot(equals(null)));
    });

    test('Type Mismatch Equality Test', () {
      final color1 = AccentableColor(
        Color.black,
        LeveledContainer<Color>([
          Color.fromHex("#123456"),
        ]),
      );

      final boxColors = AccentableBoxColors(
        content: color1,
        surface: color1,
        decoration: color1,
        shadow: color1,
        edge: color1,
        placeholder: color1,
      );

      expect(boxColors, isNot(equals('Not a BoxColors')));
    });

    test('HashCode Consistency Test', () {
      final color1 = AccentableColor(
        Color.black,
        LeveledContainer<Color>([
          Color.fromHex("#123456"),
        ]),
      );

      final boxColors = AccentableBoxColors(
        content: color1,
        surface: color1,
        decoration: color1,
        shadow: color1,
        edge: color1,
        placeholder: color1,
      );

      final initialHashCode = boxColors.hashCode;
      expect(boxColors.hashCode, equals(initialHashCode));
    });

    test('Field-Specific Comparison Test', () {
      final color1 = AccentableColor(
        Color.black,
        LeveledContainer<Color>([
          Color.fromHex("#123456"),
        ]),
      );

      final color2 = AccentableColor(
        Color.white,
        LeveledContainer<Color>([
          Color.fromHex("#654321"),
        ]),
      );

      final boxColors1 = AccentableBoxColors(
        content: color1,
        surface: color1,
        decoration: color1,
        shadow: color1,
        edge: color1,
        placeholder: color1,
      );

      final boxColors2 = AccentableBoxColors(
        content: color1,
        surface: color1,
        decoration: color1,
        shadow: color2, // Different field
        edge: color1,
        placeholder: color1,
      );

      expect(boxColors1, isNot(equals(boxColors2)));
    });

    test('Default Field Behavior Test', () {
      final color1 = AccentableColor(
        Color.black,
        LeveledContainer<Color>([
          Color.fromHex("#123456"),
        ]),
      );

      final boxColors = AccentableBoxColors(
        content: color1,
        surface: color1,
        decoration: color1,
        shadow: color1,
        edge: color1,
        placeholder: color1,
      );

      expect(boxColors.content, equals(color1));
      expect(boxColors.surface, equals(color1));
      expect(boxColors.decoration, equals(color1));
      expect(boxColors.shadow, equals(color1));
      expect(boxColors.edge, equals(color1));
      expect(boxColors.placeholder, equals(color1));
    });
  });
}
