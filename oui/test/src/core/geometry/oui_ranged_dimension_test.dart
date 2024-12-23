import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

void main() {
  group('OuiRangedDimension', () {
    test('zero constant', () {
      const dimension = OuiRangedDimension.zero;
      expect(dimension.minimum, 0);
      expect(dimension.maximum, 0);
      expect(dimension.isFixed, true);
    });

    test('infinite constant', () {
      const dimension = OuiRangedDimension.infinite;
      expect(dimension.minimum, double.negativeInfinity);
      expect(dimension.maximum, double.infinity);
      expect(dimension.isFixed, false);
    });

    test('zeroToInfinity constant', () {
      const dimension = OuiRangedDimension.zeroToInfinity;
      expect(dimension.minimum, 0);
      expect(dimension.maximum, double.infinity);
      expect(dimension.isFixed, false);
    });

    test('fixed constructor', () {
      const dimension = OuiRangedDimension.fixed(5);
      expect(dimension.minimum, 5);
      expect(dimension.maximum, 5);
      expect(dimension.isFixed, true);
    });

    test('dynamic constructor', () {
      const dimension = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.minimum, 1);
      expect(dimension.maximum, 10);
      expect(dimension.isFixed, false);
    });

    test('inside method', () {
      const dimension = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.inside(5), true);
      expect(dimension.inside(1), false);
      expect(dimension.inside(10), false);
    });

    test('outside method', () {
      const dimension = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.outside(0), true);
      expect(dimension.outside(5), false);
      expect(dimension.outside(11), true);
    });

    test('clamped method', () {
      const dimension = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.clamped(0), 1);
      expect(dimension.clamped(5), 5);
      expect(dimension.clamped(11), 10);
    });

    test('toString method', () {
      const dimension = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(
        dimension.toString(),
        'OuiRangedDimension(minimum: 1.0, maximum: 10.0)',
      );
    });

    test('boundary values for inside method', () {
      const dimension = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.inside(1), false); // exclusive
      expect(dimension.inside(10), false); // exclusive
    });

    test('boundary values for outside method', () {
      const dimension = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.outside(1), true); // exclusive
      expect(dimension.outside(10), true); // exclusive
    });

    test('clamping extreme values', () {
      const dimension = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.clamped(-100), 1);
      expect(dimension.clamped(100), 10);
    });

    test('minimum equals maximum', () {
      const dimension = OuiRangedDimension.fixed(5);
      expect(dimension.inside(5), false); // exclusive
      expect(dimension.outside(5), true); // exclusive
      expect(dimension.clamped(5), 5);
    });

    test('negative ranges', () {
      const dimension = OuiRangedDimension.dynamic(minimum: -10, maximum: -1);
      expect(dimension.inside(-5), true);
      expect(dimension.outside(-11), true);
      expect(dimension.clamped(-15), -10);
      expect(dimension.clamped(0), -1);
    });

    test('toString for all types of ranges', () {
      expect(
        OuiRangedDimension.zero.toString(),
        'OuiRangedDimension(minimum: 0.0, maximum: 0.0)',
      );
      expect(
        OuiRangedDimension.infinite.toString(),
        'OuiRangedDimension(minimum: -Infinity, maximum: Infinity)',
      );
      expect(
        OuiRangedDimension.zeroToInfinity.toString(),
        'OuiRangedDimension(minimum: 0.0, maximum: Infinity)',
      );
      expect(
        const OuiRangedDimension.fixed(5).toString(),
        'OuiRangedDimension(minimum: 5.0, maximum: 5.0)',
      );
      expect(
        const OuiRangedDimension.dynamic(minimum: 1, maximum: 10).toString(),
        'OuiRangedDimension(minimum: 1.0, maximum: 10.0)',
      );
    });

    test('equality operator', () {
      const dimension1 = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      const dimension2 = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      const dimension3 = OuiRangedDimension.dynamic(minimum: 2, maximum: 10);
      const dimension4 = OuiRangedDimension.fixed(5);

      expect(dimension1 == dimension2, true);
      expect(dimension1 == dimension3, false);
      expect(dimension1 == dimension4, false);
    });

    test('hashCode', () {
      const dimension1 = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      const dimension2 = OuiRangedDimension.dynamic(minimum: 1, maximum: 10);
      const dimension3 = OuiRangedDimension.dynamic(minimum: 2, maximum: 10);
      const dimension4 = OuiRangedDimension.fixed(5);

      expect(dimension1.hashCode == dimension2.hashCode, true);
      expect(dimension1.hashCode == dimension3.hashCode, false);
      expect(dimension1.hashCode == dimension4.hashCode, false);
    });
  });
}
