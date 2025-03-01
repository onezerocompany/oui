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
      expect(segment.value, 0);
      expect(next?.segments.length, 1);
      expect(next?.segments.first.value, 'name');
    });
  });
}
