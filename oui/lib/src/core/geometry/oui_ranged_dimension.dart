/// A class representing a ranged dimension with a minimum and maximum value.
///
/// This class is useful for scenarios where you need to define a range of values,
/// such as in UI components, data validation, or any other context where a bounded
/// range is required.
///
/// Example usage:
///
/// ```dart
/// void main() {
///   OuiRangedDimension dimension = OuiRangedDimension.dynamic(minimum: 0, maximum: 100);
/// }
/// ```
///
/// In this example, a `OuiRangedDimension` object is created with a minimum value of 0
/// and a maximum value of 100. The `inside` method is then used to check if
/// a given value falls within the specified range, and the `outside` method checks if
/// a value is outside the range.
class OuiRangedDimension {
  /// The minimum value of the range.
  final double minimum;

  /// The maximum value of the range.
  final double maximum;

  /// Private constructor for creating a ranged dimension.
  const OuiRangedDimension._({
    this.minimum = double.negativeInfinity,
    this.maximum = double.infinity,
  });

  /// A constant representing a range with both minimum and maximum set to zero.
  static const zero = OuiRangedDimension._(minimum: 0, maximum: 0);

  /// A constant representing an infinite range.
  static const infinite = OuiRangedDimension._(
    minimum: double.negativeInfinity,
    maximum: double.infinity,
  );

  /// A constant representing a range from zero to infinity.
  static const zeroToInfinity = OuiRangedDimension._(
    minimum: 0,
    maximum: double.infinity,
  );

  /// Creates a fixed ranged dimension where minimum and maximum are the same.
  const OuiRangedDimension.fixed(double value)
      : this._(minimum: value, maximum: value);

  /// Creates a dynamic ranged dimension with specified minimum and maximum values.
  const OuiRangedDimension.dynamic({
    double minimum = 0,
    double maximum = double.infinity,
  }) : this._(minimum: minimum, maximum: maximum);

  /// Checks if the range is fixed (minimum equals maximum).
  bool get isFixed => minimum == maximum;

  /// Checks if a value is inside the range (exclusive).
  bool inside(double value) {
    return value > minimum && value < maximum;
  }

  /// Checks if a value is outside the range.
  bool outside(double value) {
    return !inside(value);
  }

  /// Clamps a value to be within the range.
  double clamped(double value) {
    return value.clamp(minimum, maximum);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OuiRangedDimension) return false;
    return minimum == other.minimum && maximum == other.maximum;
  }

  @override
  int get hashCode => minimum.hashCode ^ maximum.hashCode;

  @override
  String toString() {
    return 'OuiRangedDimension(minimum: $minimum, maximum: $maximum)';
  }
}
