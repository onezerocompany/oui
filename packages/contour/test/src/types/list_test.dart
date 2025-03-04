import 'package:contour/src/types/list.dart';
import 'package:contour/src/types/number.dart';
import 'package:test/test.dart';

void main() {
  group('ContourList', () {
    test('coerce should return a list for a valid list input', () {
      final listType = ContourList(ContourNumber());
      expect(listType.coerce([1, 2, 3]), [1, 2, 3]);
    });

    test('coerce should return a list for a valid list input', () {
      final listType = ContourList(ContourList(ContourNumber()));
      expect(
        listType.coerce([
          [1, 2],
          [3, 4],
        ]),
        [
          [1, 2],
          [3, 4],
        ],
      );
    });

    test('coerce should return a list for single non-list values', () {
      final listType = ContourList(ContourNumber());
      expect(listType.coerce('not a list'), [null]);
      expect(listType.coerce(123), [123]);
    });

    test('optional should remove required operation', () {
      final listType = ContourList(ContourNumber()).required.optional;
      final result = listType.operations.any((op) => op.name == 'required');
      expect(result, isFalse);
    });

    test('optional should validate list value', () {
      final listType = ContourList(ContourNumber()).required.optional;
      final instance = listType.instance('test');

      instance.value = null;
      expect(instance.errors.isEmpty, isTrue);

      instance.value = [1, 2, 3];
      expect(instance.errors.isEmpty, isTrue);
    });

    test('required should add a required operation', () {
      final listType = ContourList(ContourNumber()).required;
      final result = listType.operations.any((op) => op.name == 'required');
      expect(result, isTrue);
    });

    test('required should validate list value', () {
      final listType = ContourList(ContourNumber()).required;
      final instance = listType.instance('test');

      instance.value = null;
      expect(instance.errors.isNotEmpty, isTrue);
      expect(instance.errors.first.message, 'is required');

      instance.value = [1, 2, 3];
      expect(instance.errors.isEmpty, isTrue);
    });

    test('fallback should add a fallback operation', () {
      final listType = ContourList(ContourNumber()).fallback([1, 2, 3]);
      final result = listType.operations.any((op) => op.name == 'fallback');
      expect(result, isTrue);
    });

    test('fallback should validate list value', () {
      final listType = ContourList(ContourNumber()).fallback([1, 2, 3]);
      final instance = listType.instance('test');

      instance.value = null;
      expect(instance.value, [1, 2, 3]);

      instance.value = [4, 5, 6];
      expect(instance.value, [4, 5, 6]);
    });

    test('instance should create a correct instance', () {
      final listType = ContourList(ContourNumber());
      final instance = listType.instance('testList');
      expect(instance, isNotNull);
      expect(instance.name, 'testList');
      expect(instance.value, isNull);
    });

    test('should handle empty lists', () {
      final listType = ContourList(ContourNumber());
      expect(listType.coerce([]), []);
    });

    test(
      'should return empty list when parse complete list with invalid elements',
      () {
        final listType = ContourList(ContourNumber().required);
        final result = listType.parse([1, 'not a number', 3]);
        expect(result.errors.isEmpty, true);
        expect(result.value, []);
      },
    );
    // Check your expected behavior based on implementation
  });
}
