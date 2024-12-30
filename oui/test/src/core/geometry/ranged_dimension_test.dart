import 'package:flutter_test/flutter_test.dart';
import 'package:oui/oui.dart';

void main() {
  group('RangedDimension', () {
    test('zero constant', () {
      const dimension = RangedDimension.zero;
      expect(dimension.start, 0);
      expect(dimension.end, 0);
      expect(dimension.isFixed, true);
    });

    test('infinite constant', () {
      const dimension = RangedDimension.infinite;
      expect(dimension.start, double.negativeInfinity);
      expect(dimension.end, double.infinity);
      expect(dimension.isFixed, false);
    });

    test('zeroToInfinity constant', () {
      const dimension = RangedDimension.zeroToInfinity;
      expect(dimension.start, 0);
      expect(dimension.end, double.infinity);
      expect(dimension.isFixed, false);
    });

    test('fixed constructor', () {
      const dimension = RangedDimension.fixed(5);
      expect(dimension.start, 5);
      expect(dimension.end, 5);
      expect(dimension.isFixed, true);
    });

    test('dynamic constructor', () {
      const dimension = RangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.start, 1);
      expect(dimension.end, 10);
      expect(dimension.isFixed, false);
    });

    test('inside method', () {
      const dimension = RangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.within(5), true);
      expect(dimension.within(1), true);
      expect(dimension.within(10), true);
    });

    test('outside method', () {
      const dimension = RangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.outside(0), true);
      expect(dimension.outside(5), false);
      expect(dimension.outside(11), true);
    });

    test('clamped method', () {
      const dimension = RangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.clamp(0), 1);
      expect(dimension.clamp(5), 5);
      expect(dimension.clamp(11), 10);
    });

    test('toString method', () {
      const dimension = RangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(
        dimension.toString(),
        'RangedDimension.dynamic(1.0, 10.0)',
      );
    });

    test('boundary values for inside method', () {
      const dimension = RangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.within(1), true); // inclusive
      expect(dimension.within(10), true); // inclusive
    });

    test('boundary values for outside method', () {
      const dimension = RangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.outside(1), false); // inclusive
      expect(dimension.outside(10), false); // inclusive
    });

    test('clamping extreme values', () {
      const dimension = RangedDimension.dynamic(minimum: 1, maximum: 10);
      expect(dimension.clamp(-100), 1);
      expect(dimension.clamp(100), 10);
    });

    test('minimum equals maximum', () {
      const dimension = RangedDimension.fixed(5);
      expect(dimension.within(5), true); // inclusive
      expect(dimension.outside(5), false); // inclusive
      expect(dimension.clamp(5), 5);
    });

    test('negative ranges', () {
      const dimension = RangedDimension.dynamic(minimum: -10, maximum: -1);
      expect(dimension.within(-5), true);
      expect(dimension.outside(-11), true);
      expect(dimension.clamp(-15), -10);
      expect(dimension.clamp(0), -1);
    });

    test('toString for all types of ranges', () {
      expect(
        RangedDimension.zero.toString(),
        'RangedDimension.fixed(0.0)',
      );
      expect(
        RangedDimension.infinite.toString(),
        'RangedDimension.infinite',
      );
      expect(
        RangedDimension.zeroToInfinity.toString(),
        'RangedDimension.dynamic(0.0, Infinity)',
      );
      expect(
        const RangedDimension.fixed(5).toString(),
        'RangedDimension.fixed(5.0)',
      );
      expect(
        const RangedDimension.dynamic(minimum: 1, maximum: 10).toString(),
        'RangedDimension.dynamic(1.0, 10.0)',
      );
    });

    test('equality operator', () {
      const dimension1 = RangedDimension.dynamic(minimum: 1, maximum: 10);
      const dimension2 = RangedDimension.dynamic(minimum: 1, maximum: 10);
      const dimension3 = RangedDimension.dynamic(minimum: 2, maximum: 10);
      const dimension4 = RangedDimension.fixed(5);

      expect(dimension1 == dimension2, true);
      expect(dimension1 == dimension3, false);
      expect(dimension1 == dimension4, false);
    });

    test('hashCode', () {
      const dimension1 = RangedDimension.dynamic(minimum: 1, maximum: 10);
      const dimension2 = RangedDimension.dynamic(minimum: 1, maximum: 10);
      const dimension3 = RangedDimension.dynamic(minimum: 2, maximum: 10);
      const dimension4 = RangedDimension.fixed(5);

      expect(dimension1.hashCode == dimension2.hashCode, true);
      expect(dimension1.hashCode == dimension3.hashCode, false);
      expect(dimension1.hashCode == dimension4.hashCode, false);
    });

    test('addition operator', () {
      const dimension1 = RangedDimension.dynamic(minimum: 1, maximum: 10);
      const dimension2 = RangedDimension.dynamic(minimum: 2, maximum: 5);
      final result = dimension1 + dimension2;
      expect(result.start, 1);
      expect(result.end, 10);
    });

    test('subtraction operator', () {
      const dimension1 = RangedDimension.dynamic(minimum: 10, maximum: 20);
      const dimension2 = RangedDimension.dynamic(minimum: 5, maximum: 5);
      final result = dimension1 - dimension2;
      expect(result?.start, 10);
      expect(result?.end, 20);
    });
  });
}
