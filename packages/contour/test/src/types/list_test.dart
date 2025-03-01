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

    test('coerce should return null for non-list values', () {
      final listType = ContourList(ContourNumber());
      expect(listType.coerce('not a list'), isNull);
      expect(listType.coerce(123), isNull);
    });

    test('optional should remove required operation', () {
      final listType = ContourList(ContourNumber()).required.optional;
      final result = listType.operations.any((op) => op.name == 'required');
      expect(result, isFalse);
    });

    test('required should add a required operation', () {
      final listType = ContourList(ContourNumber()).required;
      final result = listType.operations.any((op) => op.name == 'required');
      expect(result, isTrue);
    });

    test('fallback should add a fallback operation', () {
      final listType = ContourList(ContourNumber()).fallback([1, 2, 3]);
      final result = listType.operations.any((op) => op.name == 'fallback');
      expect(result, isTrue);
    });
  });
}
