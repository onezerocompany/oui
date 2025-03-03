import 'package:contour/src/types/string.dart';
import 'package:test/test.dart';

void main() {
  group('ContourString', () {
    test('coerce should return a string for a valid string input', () {
      final stringType = ContourString();
      expect(stringType.coerce('test'), 'test');
    });

    // TODO: Convert non string to string when possible
    test('coerce should return null for non-string values', () {
      final stringType = ContourString();
      expect(stringType.coerce(123), isNull);
      expect(stringType.coerce(true), isNull);
    });

    test('equals should add a check operation', () {
      final stringType = ContourString().equals('test');
      final result = stringType.operations.any((op) => op.name == 'equals');
      expect(result, isTrue);
    });

    test('optional should remove required operation', () {
      final stringType = ContourString().required.optional;
      final result = stringType.operations.any((op) => op.name == 'required');
      expect(result, isFalse);
    });

    test('required should add a required operation', () {
      final stringType = ContourString().required;
      final result = stringType.operations.any((op) => op.name == 'required');
      expect(result, isTrue);
    });

    test('fallback should add a fallback operation', () {
      final stringType = ContourString().fallback('default');
      final result = stringType.operations.any((op) => op.name == 'fallback');
      expect(result, isTrue);
    });

    test('oneOf should add a oneOf operation', () {
      final stringType = ContourString().oneOf(['a', 'b', 'c']);
      final result = stringType.operations.any((op) => op.name == 'oneOf');
      expect(result, isTrue);
    });
  });
}
