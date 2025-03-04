import 'package:contour/src/types/string.dart';
import 'package:test/test.dart';

void main() {
  group('ContourString', () {
    test('coerce should return a string for a valid string input', () {
      final stringType = ContourString();
      expect(stringType.coerce('test'), 'test');
    });

    test('coerce should return string for non-string values', () {
      final stringType = ContourString();
      expect(stringType.coerce(123), "123");
      expect(stringType.coerce(true), "true");
    });

    test('equals should add a check operation', () {
      final stringType = ContourString().equals('test');
      final result = stringType.operations.any((op) => op.name == 'equals');
      expect(result, isTrue);
    });

    test('equals should validate string value', () {
      final stringType = ContourString().equals('test');
      final instance = stringType.instance('test');
      instance.value = 'not test';
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'should equal test');

      instance.value = 'test';
      expect(instance.errors.isEmpty, isTrue);
    });

    test('optional should remove required operation', () {
      final stringType = ContourString().required.optional;
      final result = stringType.operations.any((op) => op.name == 'required');
      expect(result, isFalse);
    });

    test('optional should validate string value', () {
      final stringType = ContourString().required.optional;
      final instance = stringType.instance('test');

      instance.value = null;
      expect(instance.errors.isEmpty, isTrue);

      instance.value = 'test';
      expect(instance.errors.isEmpty, isTrue);
    });

    test('required should add a required operation', () {
      final stringType = ContourString().required;
      final result = stringType.operations.any((op) => op.name == 'required');
      expect(result, isTrue);
    });

    test('required should validate string value', () {
      final stringType = ContourString().required;
      final instance = stringType.instance('test');
      instance.value = null;
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'is required');

      instance.value = 'test';
      expect(instance.errors.isEmpty, isTrue);
    });

    test('fallback should add a fallback operation', () {
      final stringType = ContourString().fallback('default');
      final result = stringType.operations.any((op) => op.name == 'fallback');
      expect(result, isTrue);
    });

    test('fallback should validate string value', () {
      final stringType = ContourString().fallback('default');
      final instance = stringType.instance('test');
      instance.value = null;
      expect(instance.value, 'default');

      instance.value = 'test';
      expect(instance.value, 'test');
    });

    test('oneOf should add a oneOf operation', () {
      final stringType = ContourString().oneOf(['a', 'b', 'c']);
      final result = stringType.operations.any((op) => op.name == 'oneOf');
      expect(result, isTrue);
    });

    test('oneOf should validate string value', () {
      final stringType = ContourString().oneOf(['a', 'b', 'c']);
      final instance = stringType.instance('test');
      instance.value = 'd';
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'should be one of a, b, c');

      instance.value = 'a';
      expect(instance.errors.isEmpty, isTrue);
    });
  });
}
