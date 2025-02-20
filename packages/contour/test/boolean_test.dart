import 'package:contour/contour.dart';
import 'package:test/test.dart';

void main() {
  group('ContourBoolean', () {
    test('should validate basic boolean', () {
      final type = boolean();
      expect(type.parse(true), true);
      expect(type.parse(false), false);
    });

    test('isTrue validation', () {
      final type = boolean().isTrue();
      expect(() => type.parse(false), throwsA(isA<ContourParseError>()));
      expect(type.parse(true), true);
      expect(type.parse(true), isTrue);
    });

    test('isFalse validation', () {
      final type = boolean().isFalse();
      expect(() => type.parse(true), throwsA(isA<ContourParseError>()));
      expect(type.parse(false), false);
      expect(type.parse(false), isFalse);
    });

    test('custom error messages', () {
      final type = boolean().isTrue(message: 'Must be true');
      try {
        type.parse(false);
        fail('Should have thrown');
      } catch (e) {
        expect(e, isA<ContourParseError>());
        final error = e as ContourParseError;
        expect(error.errors.first.message, 'Must be true');
      }
    });
  });
}
