/// Linearly interpolates between two double values.
///
/// The interpolation is performed by calculating the value at the
/// position `t` between `a` and `b`. The parameter `t` should be
/// between 0.0 and 1.0, where 0.0 corresponds to `a` and 1.0
/// corresponds to `b`.
///
/// - Parameters:
///   - a: The starting value.
///   - b: The ending value.
///   - t: The interpolation factor, typically between 0.0 and 1.0.
///
/// - Returns: The interpolated value between `a` and `b` at position `t`.
double lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
