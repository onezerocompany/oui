import 'package:contour/src/types/number.dart';
import 'package:test/test.dart';

void main() {
  group('ContourNumber', () {
    test('coerce should return a number for a valid number input', () {
      final numberType = ContourNumber();
      expect(numberType.coerce(123), 123);
      expect(numberType.coerce(123.0), 123.0);
      expect(numberType.coerce(123.4), 123.4);
      expect(numberType.coerce(3.141592653589793), 3.141592653589793);
      expect(
        numberType.coerce(31415926535897932384626433832795.0288419716939937510),
        31415926535897932384626433832795.0288419716939937510,
      );
    });

    test('coerce should return a number for a valid string number input', () {
      final numberType = ContourNumber();
      expect(numberType.coerce('123'), 123);
      expect(numberType.coerce('123.0'), 123.0);
      expect(numberType.coerce('123.4'), 123.4);
      expect(numberType.coerce('3.141592653589793'), 3.141592653589793);
      expect(
        numberType.coerce(
          '31415926535897932384626433832795.0288419716939937510',
        ),
        31415926535897932384626433832795.0288419716939937510,
      );
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

    test('equals should validate number value', () {
      final numberType = ContourNumber().equals(123);
      final instance = numberType.instance('test');
      instance.value = 321;
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'should equal 123');

      instance.value = 123;
      expect(instance.errors.isEmpty, isTrue);
    });

    test('optional should remove required operation', () {
      final numberType = ContourNumber().required.optional;
      final result = numberType.operations.any((op) => op.name == 'required');
      expect(result, isFalse);
    });

    test('optional should validate number value', () {
      final numberType = ContourNumber().required.optional;
      final instance = numberType.instance('test');

      instance.value = null;
      expect(instance.errors.isEmpty, isTrue);

      instance.value = 1;
      expect(instance.errors.isEmpty, isTrue);
    });

    test('required should add a required operation', () {
      final numberType = ContourNumber().required;
      final result = numberType.operations.any((op) => op.name == 'required');
      expect(result, isTrue);
      final instance = numberType.instance('test');

      instance.value = null;
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'is required');

      instance.value = 1;
      expect(instance.errors.isEmpty, isTrue);
    });

    test('required should validate number value', () {
      final numberType = ContourNumber().required;
      final instance = numberType.instance('test');

      instance.value = null;
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'is required');

      instance.value = 1;
      expect(instance.errors.isEmpty, isTrue);
    });

    test('fallback should add a fallback operation', () {
      final numberType = ContourNumber().fallback(123);
      final result = numberType.operations.any((op) => op.name == 'fallback');
      expect(result, isTrue);
    });

    test('fallback should validate number value', () {
      final numberType = ContourNumber().fallback(123);
      final instance = numberType.instance('test');

      instance.value = null;
      expect(instance.value, 123);

      instance.value = 1;
      expect(instance.value, 1);
    });

    test('oneOf should add a oneOf operation', () {
      final numberType = ContourNumber().oneOf([1, 2, 3]);
      final result = numberType.operations.any((op) => op.name == 'oneOf');
      expect(result, isTrue);
    });

    test('oneOf should validate number value', () {
      final numberType = ContourNumber().oneOf([1, 2, 3]);
      final instance = numberType.instance('test');

      instance.value = 4;
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'should be one of 1, 2, 3');

      instance.value = 1;
      expect(instance.errors.isEmpty, isTrue);
    });

    test('isInteger should add a isInteger operation', () {
      final numberType = ContourNumber().isInteger();
      final result = numberType.operations.any((op) => op.name == 'isInteger');
      expect(result, isTrue);
    });

    test('isInteger should validate number value', () {
      final numberType = ContourNumber().isInteger();
      final instance = numberType.instance('test');

      instance.value = 1.1;
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'should be an integer');

      instance.value = 1;
      expect(instance.errors.isEmpty, isTrue);
    });
  });

  test('toInteger should add a toInteger operation', () {
    final numberType = ContourNumber().toInteger();
    final result = numberType.operations.any((op) => op.name == 'toInteger');
    expect(result, isTrue);
  });

  test('toInteger should validate number value', () {
    final numberType = ContourNumber().toInteger();
    final instance = numberType.instance('test');

    instance.value = 1.1;
    expect(instance.value, 1);

    instance.value = 1;
    expect(instance.value, 1);
  });
}
