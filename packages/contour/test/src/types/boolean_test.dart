import 'package:contour/src/types/boolean.dart';
import 'package:test/test.dart';

void main() {
  group('ContourBoolean', () {
    test('coerce should return true for string "true"', () {
      final booleanType = ContourBoolean();
      expect(booleanType.coerce('true'), isTrue);
    });

    test('coerce should return false for string "false"', () {
      final booleanType = ContourBoolean();
      expect(booleanType.coerce('false'), isFalse);
    });

    test('coerce should return null for non-boolean values', () {
      final booleanType = ContourBoolean();
      expect(booleanType.coerce('not a boolean'), isNull);
      expect(booleanType.coerce(123), isNull);
    });

    test('equals should add a check operation', () {
      final booleanType = ContourBoolean().equals(true);
      final result = booleanType.operations.any((op) => op.name == 'equals');
      expect(result, isTrue);
    });

    test('optional should remove required operation', () {
      final booleanType = ContourBoolean().required.optional;
      final result = booleanType.operations.any((op) => op.name == 'required');
      expect(result, isFalse);
    });

    test('required should add a required operation', () {
      final booleanType = ContourBoolean().required;
      final result = booleanType.operations.any((op) => op.name == 'required');
      expect(result, isTrue);
    });

    test('fallback should add a fallback operation', () {
      final booleanType = ContourBoolean().fallback(true);
      final result = booleanType.operations.any((op) => op.name == 'fallback');
      expect(result, isTrue);
    });
  });
}
