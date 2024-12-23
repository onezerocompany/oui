import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/core/geometry/oui_size.dart';

void main() {
  group('OuiSize', () {
    test('fixed constructor initializes correctly', () {
      const width = 100.0;
      const height = 200.0;
      final size = OuiSize.fixed(width: width, height: height);

      expect(size.width.minimum, width);
      expect(size.width.maximum, width);
      expect(size.height.minimum, height);
      expect(size.height.maximum, height);
    });

    test('dynamic constructor initializes correctly', () {
      const minWidth = 50.0;
      const maxWidth = 150.0;
      const minHeight = 100.0;
      const maxHeight = 300.0;
      final size = OuiSize.dynamic(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );

      expect(size.width.minimum, minWidth);
      expect(size.width.maximum, maxWidth);
      expect(size.height.minimum, minHeight);
      expect(size.height.maximum, maxHeight);
    });

    test('fixed constructor defaults to zero', () {
      final size = OuiSize.fixed();

      expect(size.width.minimum, 0);
      expect(size.width.maximum, 0);
      expect(size.height.minimum, 0);
      expect(size.height.maximum, 0);
    });

    test('dynamic constructor defaults to zero and infinity', () {
      final size = OuiSize.dynamic();

      expect(size.width.minimum, 0);
      expect(size.width.maximum, double.infinity);
      expect(size.height.minimum, 0);
      expect(size.height.maximum, double.infinity);
    });

    test('equality operator returns true for equal sizes', () {
      const width = 100.0;
      const height = 200.0;
      final size1 = OuiSize.fixed(width: width, height: height);
      final size2 = OuiSize.fixed(width: width, height: height);

      expect(size1, equals(size2));
    });

    test('hashCode returns same value for equal sizes', () {
      const width = 100.0;
      const height = 200.0;
      final size1 = OuiSize.fixed(width: width, height: height);
      final size2 = OuiSize.fixed(width: width, height: height);

      expect(size1.hashCode, equals(size2.hashCode));
    });

    test('toString returns correct string representation', () {
      const width = 100.0;
      const height = 200.0;
      final size = OuiSize.fixed(width: width, height: height);

      expect(
        size.toString(),
        'OuiSize(width: OuiRangedDimension(minimum: $width, maximum: $width), height: OuiRangedDimension(minimum: $height, maximum: $height))',
      );
    });
  });
}
