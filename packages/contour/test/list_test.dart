import 'package:contour/contour.dart';
import 'package:test/test.dart';

void main() {
  group('ContourList', () {
    test('should validate basic list', () {
      final type = list();
      final result = type.parse([1, 2, 3]);
      expect(result, [1, 2, 3]);
    });

    test('should validate list with item type', () {
      final type = list(number().min(0));
      final result = type.parse([1, 2, 3]);
      expect(result, [1, 2, 3]);

      expect(() => type.parse([-1, 2, 3]), throwsA(isA<ContourParseError>()));
    });

    test('min length validation', () {
      final type = list().min(2);
      expect(() => type.parse([1]), throwsA(isA<ContourParseError>()));
      final result = type.parse([1, 2]);
      expect(result, [1, 2]);
    });

    test('max length validation', () {
      final type = list().max(2);
      expect(() => type.parse([1, 2, 3]), throwsA(isA<ContourParseError>()));
      final result = type.parse([1, 2]);
      expect(result, [1, 2]);
    });

    test('exact length validation', () {
      final type = list().length(2);
      expect(() => type.parse([1]), throwsA(isA<ContourParseError>()));
      expect(() => type.parse([1, 2, 3]), throwsA(isA<ContourParseError>()));
      final result = type.parse([1, 2]);
      expect(result, [1, 2]);
    });

    test('unique items validation', () {
      final type = list().unique();
      expect(() => type.parse([1, 1, 2]), throwsA(isA<ContourParseError>()));
      final result = type.parse([1, 2, 3]);
      expect(result, [1, 2, 3]);
    });

    test('sort transformation', () {
      final type = list<int>().sort();
      final result = type.parse([3, 1, 2]);
      expect(result, [1, 2, 3]);
    });

    test('sort with custom compare', () {
      final type = list<int>().sort((a, b) => b.compareTo(a));
      final result = type.parse([1, 3, 2]);
      expect(result, [3, 2, 1]);
    });

    test('reverse transformation', () {
      final type = list().reverse();
      final result = type.parse([1, 2, 3]);
      expect(result, [3, 2, 1]);
    });

    test('chaining operations', () {
      final type =
          list<int>()
            ..min(3)
            ..unique()
            ..sort();

      expect(() => type.parse([1, 2]), throwsA(isA<ContourParseError>()));
      expect(() => type.parse([1, 1, 2, 3]), throwsA(isA<ContourParseError>()));

      final result = type.parse([3, 1, 2]);
      expect(result, [1, 2, 3]);
    });

    test('complex nested validation', () {
      final type = list(
        object({'id': number().min(1), 'name': string().min(3)}),
      );

      expect(
        () => type.parse([
          {'id': 0, 'name': 'ab'},
          {'id': 1, 'name': 'abc'},
        ]),
        throwsA(isA<ContourParseError>()),
      );

      final result = type.parse([
        {'id': 1, 'name': 'abc'},
        {'id': 2, 'name': 'def'},
      ]);

      expect(result.length, 2);
      expect(result[0]['id'], 1);
      expect(result[0]['name'], 'abc');
      expect(result[1]['id'], 2);
      expect(result[1]['name'], 'def');
    });
  });
}
