import 'package:contour/contour.dart';
import 'package:test/test.dart';

void main() {
  group('ContourString', () {
    test('should validate basic string', () {
      final type = string();
      expect(type.parse('test'), equals('test'));
    });

    test('min length validation', () {
      final type = string().min(3);
      expect(() => type.parse('ab'), throwsA(isA<ContourParseError>()));
      expect(type.parse('abc'), equals('abc'));
    });

    test('max length validation', () {
      final type = string().max(3);
      expect(() => type.parse('abcd'), throwsA(isA<ContourParseError>()));
      expect(type.parse('abc'), equals('abc'));
    });

    test('exact length validation', () {
      final type = string().length(3);
      expect(() => type.parse('ab'), throwsA(isA<ContourParseError>()));
      expect(() => type.parse('abcd'), throwsA(isA<ContourParseError>()));
      expect(type.parse('abc'), equals('abc'));
    });

    test('pattern validation', () {
      final type = string().pattern(RegExp(r'^[a-z]+$'));
      expect(() => type.parse('123'), throwsA(isA<ContourParseError>()));
      expect(() => type.parse('ABC'), throwsA(isA<ContourParseError>()));
      expect(type.parse('abc'), 'abc');
    });

    group('transformations', () {
      test('lowercase()', () {
        final type = string().lowercase();
        expect(type.parse('ABC'), equals('abc'));
      });

      test('uppercase()', () {
        final type = string().uppercase();
        expect(type.parse('abc'), equals('ABC'));
      });

      test('trim()', () {
        final type = string().trim();
        expect(type.parse('  abc  '), equals('abc'));
      });

      test('replace()', () {
        final type = string().replace('-', '_');
        expect(type.parse('a-b-c'), equals('a_b_c'));
      });

      test('remove()', () {
        final type = string().remove('-');
        expect(type.parse('a-b-c'), equals('abc'));
      });

      test('append()', () {
        final type = string().append('X');
        expect(type.parse('abc'), equals('abcX'));
      });

      test('prepend()', () {
        final type = string().prepend('X');
        expect(type.parse('abc'), equals('Xabc'));
      });

      test('substring()', () {
        final type = string().substring(1, 3);
        expect(type.parse('abcd'), equals('bc'));
      });
    });
  });
}
