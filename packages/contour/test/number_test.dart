import 'package:contour/contour.dart';
import 'package:test/test.dart';

void main() {
  group('ContourNumber', () {
    test('should validate basic number', () {
      final type = number();
      expect(type.parse(42), 42);
      expect(type.parse(3.14), 3.14);
    });

    test('min value validation', () {
      final type = number().min(5);
      expect(() => type.parse(4), throwsA(isA<ContourParseError>()));
      expect(type.parse(5), 5);
      expect(type.parse(6), 6);
    });

    test('max value validation', () {
      final type = number().max(5);
      expect(() => type.parse(6), throwsA(isA<ContourParseError>()));
      expect(type.parse(5), 5);
      expect(type.parse(4), 4);
    });

    test('positive validation', () {
      final type = number().positive();
      expect(() => type.parse(0), throwsA(isA<ContourParseError>()));
      expect(() => type.parse(-1), throwsA(isA<ContourParseError>()));
      expect(type.parse(1), 1);
    });

    test('negative validation', () {
      final type = number().negative();
      expect(() => type.parse(0), throwsA(isA<ContourParseError>()));
      expect(() => type.parse(1), throwsA(isA<ContourParseError>()));
      expect(type.parse(-1), -1);
    });

    test('integer transformation', () {
      final type = number().integer();
      expect(type.parse(3.7), 4);
      expect(type.parse(3.2), 3);
      expect(type.parse(3.0), 3);
    });

    test('chaining operations', () {
      final type =
          number()
            ..min(0)
            ..max(10)
            ..integer();

      expect(() => type.parse(-1), throwsA(isA<ContourParseError>()));
      expect(() => type.parse(11), throwsA(isA<ContourParseError>()));
      expect(type.parse(3.7), 4);
      expect(type.parse(5), 5);
    });

    test('custom error messages', () {
      final type = number().min(5, message: 'Must be at least 5');
      try {
        type.parse(4);
        fail('Should have thrown');
      } catch (e) {
        expect(e, isA<ContourParseError>());
        final error = e as ContourParseError;
        expect(error.errors.first.message, 'Must be at least 5');
      }
    });
  });
}
