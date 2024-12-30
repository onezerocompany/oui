import '../shared/range.dart';

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
///   RangedDimension dimension = RangedDimension.dynamic(minimum: 0, maximum: 100);
/// }
/// ```
///
/// In this example, a `RangedDimension` object is created with a minimum value of 0
/// and a maximum value of 100. The `inside` method is then used to check if
/// a given value falls within the specified range, and the `outside` method checks if
/// a value is outside the range.
class RangedDimension extends Range<double> {
  /// Weight of the dimension in a flexible layout.
  final int weight;

  /// Private constructor for creating a ranged dimension.
  const RangedDimension(
    super.start,
    super.end, {
    this.weight = 1,
  });

  /// A constant representing a range with both minimum and maximum set to zero.
  static const zero = RangedDimension(0, 0);

  /// A constant representing an infinite range.
  static const infinite = RangedDimension(
    double.negativeInfinity,
    double.infinity,
  );

  /// A constant representing a range from zero to infinity.
  static const zeroToInfinity = RangedDimension(0, double.infinity);

  /// Creates a fixed ranged dimension where minimum and maximum are the same.
  const RangedDimension.fixed(
    double value, [
    int weight = 1,
  ]) : this(value, value, weight: weight);

  /// Creates a dynamic ranged dimension with specified minimum and maximum values.
  const RangedDimension.dynamic({
    double minimum = 0,
    double maximum = double.infinity,
    int weight = 1,
  }) : this(minimum, maximum, weight: weight);

  @override
  String toString() {
    if (isUnbounded) {
      return 'RangedDimension.infinite';
    } else if (isFixed) {
      return 'RangedDimension.fixed($start)';
    } else {
      return 'RangedDimension.dynamic($start, $end)';
    }
  }
}
