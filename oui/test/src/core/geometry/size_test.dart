import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/geometry/size.dart';

void main() {
  group('Size', () {
    test('fixed constructor initializes correctly', () {
      const width = 100.0;
      const height = 200.0;
      final size = Size.fixed(width: width, height: height);

      expect(size.width.start, width);
      expect(size.width.end, width);
      expect(size.height.start, height);
      expect(size.height.end, height);
    });

    test('fixed constructor initializes with only width', () {
      const width = 100.0;
      final size = Size.fixed(width: width);

      expect(size.width.start, width);
      expect(size.width.end, width);
      expect(size.height.start, 0);
      expect(size.height.end, double.infinity);
    });

    test('fixed constructor initializes with only height', () {
      const height = 200.0;
      final size = Size.fixed(height: height);

      expect(size.width.start, 0);
      expect(size.width.end, double.infinity);
      expect(size.height.start, height);
      expect(size.height.end, height);
    });

    test('dynamic constructor initializes correctly', () {
      const minWidth = 50.0;
      const maxWidth = 150.0;
      const minHeight = 100.0;
      const maxHeight = 300.0;
      final size = Size.dynamic(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );

      expect(size.width.start, minWidth);
      expect(size.width.end, maxWidth);
      expect(size.height.start, minHeight);
      expect(size.height.end, maxHeight);
    });

    test('fixed constructor defaults to zeroToInfinity', () {
      final size = Size.fixed();

      expect(size.width.start, 0);
      expect(size.width.end, double.infinity);
      expect(size.height.start, 0);
      expect(size.height.end, double.infinity);
    });

    test('dynamic constructor defaults to zero and infinity', () {
      final size = Size.dynamic();

      expect(size.width.start, 0);
      expect(size.width.end, double.infinity);
      expect(size.height.start, 0);
      expect(size.height.end, double.infinity);
    });

    test('equality operator returns true for equal sizes', () {
      const width = 100.0;
      const height = 200.0;
      final size1 = Size.fixed(width: width, height: height);
      final size2 = Size.fixed(width: width, height: height);

      expect(size1, equals(size2));
    });

    test('hashCode returns same value for equal sizes', () {
      const width = 100.0;
      const height = 200.0;
      final size1 = Size.fixed(width: width, height: height);
      final size2 = Size.fixed(width: width, height: height);

      expect(size1.hashCode, equals(size2.hashCode));
    });

    test('toString returns correct string representation', () {
      const width = 100.0;
      const height = 200.0;
      final size = Size.fixed(width: width, height: height);

      expect(
        size.toString(),
        'Size(width: RangedDimension.fixed($width), height: RangedDimension.fixed($height))',
      );
    });
  });
}
