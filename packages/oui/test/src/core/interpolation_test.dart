import 'package:oui/src/core/interpolation.dart';
import 'package:test/test.dart';

void main() {
  group('LinearCurve', () {
    test('transform returns input value', () {
      const curve = LinearCurve();
      expect(curve.transform(0.0), 0.0);
      expect(curve.transform(0.5), 0.5);
      expect(curve.transform(1.0), 1.0);
    });
  });

  group('Interpolator', () {
    test('resolve interpolates between two values', () {
      const curve = LinearCurve();
      const interpolator = Interpolator<InterpolableDouble>(curve: curve);
      final a = InterpolableDouble(0.0);
      final b = InterpolableDouble(1.0);
      expect(interpolator.resolve(a, b, 0.0).value, 0.0);
      expect(interpolator.resolve(a, b, 0.5).value, 0.5);
      expect(interpolator.resolve(a, b, 1.0).value, 1.0);
    });
  });

  group('DoubleInterpolator', () {
    test('resolve interpolates between two double values', () {
      const curve = LinearCurve();
      const interpolator = DoubleInterpolator(curve: curve);
      expect(interpolator.resolve(0.0, 1.0, 0.0), 0.0);
      expect(interpolator.resolve(0.0, 1.0, 0.5), 0.5);
      expect(interpolator.resolve(0.0, 1.0, 1.0), 1.0);
    });
  });
}

class InterpolableDouble with Interpolable<InterpolableDouble> {
  final double value;
  InterpolableDouble(this.value);

  @override
  InterpolableDouble lerp(
    InterpolableDouble a,
    InterpolableDouble b,
    double t,
  ) {
    return InterpolableDouble(a.value + (b.value - a.value) * t);
  }
}
