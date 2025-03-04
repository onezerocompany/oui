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

    test('equals should validate boolean value', () {
      final booleanType = ContourBoolean().equals(true);
      final instance = booleanType.instance('test');
      instance.value = false;
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'should equal be true');

      instance.value = true;
      expect(instance.errors.isEmpty, isTrue);
    });

    test('optional should remove required operation', () {
      final booleanType = ContourBoolean().required.optional;
      final result = booleanType.operations.any((op) => op.name == 'required');
      expect(result, isFalse);
    });

    test('optional should validate boolean value', () {
      final booleanType = ContourBoolean().required.optional;
      final instance = booleanType.instance('test');

      instance.value = null;
      expect(instance.errors.isEmpty, isTrue);

      instance.value = true;
      expect(instance.errors.isEmpty, isTrue);
    });

    test('required should add a required operation', () {
      final booleanType = ContourBoolean().required;
      final result = booleanType.operations.any((op) => op.name == 'required');
      expect(result, isTrue);
    });

    test('required should validate boolean value', () {
      final booleanType = ContourBoolean().required;
      final instance = booleanType.instance('test');

      instance.value = null;
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'is required');

      instance.value = true;
      expect(instance.errors.isEmpty, isTrue);
    });

    test('fallback should add a fallback operation', () {
      final booleanType = ContourBoolean().fallback(true);
      final result = booleanType.operations.any((op) => op.name == 'fallback');
      expect(result, isTrue);
    });

    test('fallback should validate boolean value', () {
      final booleanType = ContourBoolean().fallback(true);
      final instance = booleanType.instance('test');

      instance.value = null;
      expect(instance.value, true);

      instance.value = false;
      expect(instance.value, false);
    });
  });

  test('initial value should be null', () {
    final numberType = ContourBoolean();
    final instance = numberType.instance('test');
    expect(instance.value, isNull);
  });

  test('initial value should be set', () {
    final numberType = ContourBoolean();
    final instance = numberType.instance('test', true);
    expect(instance.value, true);
  });
}
