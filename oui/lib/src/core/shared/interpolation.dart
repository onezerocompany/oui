abstract class Interpolable<T> {
  T _lerp(T a, T b, double t);
  T lerpTo(T other, double t) => _lerp(this as T, other, t);
  T lerpFrom(T other, double t) => _lerp(other, this as T, t);
}

class Interpolator<T> {
  final T Function(T a, T b, double t) lerp;
  Interpolator(this.lerp);
}
