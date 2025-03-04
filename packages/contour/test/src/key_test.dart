import 'package:contour/src/key.dart';
import 'package:test/test.dart';

void main() {
  group('VariableKey', () {
    test('should initialize with empty segments', () {
      final key = VariableKey([]);
      expect(key.segments, isEmpty);
    });

    test('should add field segment', () {
      final key = VariableKey([]).field('name');
      expect(key.segments.length, 1);
      expect(key.segments.first.value, 'name');
    });

    test('should add index segment', () {
      final key = VariableKey([]).index(0);
      expect(key.segments.length, 1);
      expect(key.segments.first.value, 0);
    });

    test('should shift key', () {
      final key = VariableKey([]).field('name').index(0);
      final (segment, next) = key.shift;
      expect(segment.value, 'name');
      expect(next?.segments.length, 1);
      expect(next?.segments.first.value, 0);
    });

    test('should handle shifting with a single segment', () {
      final key = VariableKey([]).field('name');
      final (segment, next) = key.shift;
      expect(segment.value, 'name');
      expect(next, isNull);
    });

    test('should build complex nested keys', () {
      final key = VariableKey(
        [],
      ).field('users').index(5).field('address').field('zipcode');
      expect(key.segments.length, 4);
      expect(key.segments.map((s) => s.value).toList(), [
        'users',
        5,
        'address',
        'zipcode',
      ]);
    });

    test('should maintain segment order when creating a new key', () {
      final baseKey = VariableKey([]).field('user');
      final extendedKey = baseKey.field('name');

      expect(baseKey.segments.length, 1);
      expect(baseKey.segments.first.value, 'user');

      expect(extendedKey.segments.length, 2);
      expect(extendedKey.segments.map((s) => s.value).toList(), [
        'user',
        'name',
      ]);
    });

    test('should work with different data types in segments', () {
      final segments = [
        VariableKeySegment<String>('name'),
        VariableKeySegment<int>(42),
        VariableKeySegment<bool>(true),
      ];
      final key = VariableKey(segments);

      expect(key.segments.length, 3);
      expect(key.segments[0].value, 'name');
      expect(key.segments[1].value, 42);
      expect(key.segments[2].value, true);
    });

    test('should shift segments in the correct order', () {
      final key = VariableKey(
        [],
      ).field('user').field('address').field('street');

      var (segment1, next1) = key.shift;
      expect(segment1.value, 'user');
      expect(next1!.segments.length, 2);

      var (segment2, next2) = next1.shift;
      expect(segment2.value, 'address');
      expect(next2!.segments.length, 1);

      var (segment3, next3) = next2.shift;
      expect(segment3.value, 'street');
      expect(next3, isNull);
    });
  });
}
