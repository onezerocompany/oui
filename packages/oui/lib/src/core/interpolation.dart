abstract class Curve {
  const Curve();
  double transform(double t);

  static const Curve linear = LinearCurve();
}

class LinearCurve implements Curve {
  const LinearCurve();

  @override
  double transform(double t) {
    return t;
  }
}

class CubicCurve implements Curve {
  final double p0; // Control point 0
  final double p1; // Control point 1
  final double p2; // Control point 2
  final double p3; // Control point 3

  const CubicCurve(this.p0, this.p1, this.p2, this.p3);

  @override
  double transform(double t) {
    final t2 = t * t; // Precompute t^2
    final t3 = t2 * t; // Precompute t^3
    return p0 * t3 + p1 * t2 + p2 * t + p3;
  }
}

/// Represents a quadratic curve defined by the formula: f(t) = a*t² + b*t + c.
class QuadraticCurve implements Curve {
  final double a; // Coefficient for t²
  final double b; // Coefficient for t
  final double c; // Constant term

  const QuadraticCurve(this.a, this.b, this.c);

  /// Transforms the input [t] using the quadratic formula.
  @override
  double transform(double t) {
    return a * t * t + b * t + c;
  }
}

mixin Interpolable<T> {
  T lerp(T a, T b, double t);
  T lerpTo(T b, double t) => lerp(this as T, b, t);
  T lerpFrom(T a, double t) => lerp(a, this as T, t);
}

class Interpolator<T extends Interpolable<T>> {
  final Curve curve;
  const Interpolator({
    this.curve = const LinearCurve(),
  });
  T resolve(T a, T b, double t) {
    return a.lerpTo(b, curve.transform(t));
  }
}

class DoubleInterpolator {
  final Curve curve;
  const DoubleInterpolator({
    this.curve = const LinearCurve(),
  });
  double resolve(double a, double b, double t) {
    return a + (b - a) * curve.transform(t);
  }
}
