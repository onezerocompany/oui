abstract class Curve {
  const Curve();
  double transform(double t);
}

class LinearCurve implements Curve {
  const LinearCurve();

  @override
  double transform(double t) {
    return t;
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
