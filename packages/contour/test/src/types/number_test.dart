import 'package:contour/src/types/number.dart';
import 'package:test/test.dart';

void main() {
  group('ContourNumber', () {
    test('coerce should return a number for a valid number input', () {
      final numberType = ContourNumber();
      expect(numberType.coerce(123), 123);
    });

    test('coerce should return a number for a valid string number input', () {
      final numberType = ContourNumber();
      expect(numberType.coerce('123'), 123);
    });

    test('coerce should return null for non-number values', () {
      final numberType = ContourNumber();
      expect(numberType.coerce('not a number'), isNull);
      expect(numberType.coerce(true), isNull);
    });

    test('equals should add a check operation', () {
      final numberType = ContourNumber().equals(123);
      final result = numberType.operations.any((op) => op.name == 'equals');
      expect(result, isTrue);
    });

    test('optional should remove required operation', () {
      final numberType = ContourNumber().required.optional;
      final result = numberType.operations.any((op) => op.name == 'required');
      expect(result, isFalse);
    });

    test('required should add a required operation', () {
      final numberType = ContourNumber().required;
      final result = numberType.operations.any((op) => op.name == 'required');
      expect(result, isTrue);
    });

    test('fallback should add a fallback operation', () {
      final numberType = ContourNumber().fallback(123);
      final result = numberType.operations.any((op) => op.name == 'fallback');
      expect(result, isTrue);
    });

    test('oneOf should add a oneOf operation', () {
      final numberType = ContourNumber().oneOf([1, 2, 3]);
      final result = numberType.operations.any((op) => op.name == 'oneOf');
      expect(result, isTrue);
    });
  });
}
