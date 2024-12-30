/// A generic class representing a range of values that are comparable.
///
/// The [Range] class is defined with a type parameter [T] that extends
/// [Comparable], ensuring that the values can be compared.
///
/// Example usage:
/// ```dart
/// final range = Range(1, 10);
/// print(range.within(5)); // true
/// print(range.outside(15)); // true
/// ```
///
/// [T] - The type of the values in the range, which must extend [Comparable].
///
/// Properties:
/// - `start` - The starting value of the range.
/// - `end` - The ending value of the range.
///
/// Methods:
/// - `within(T value)` - Checks if the given [value] is within the range.
/// - `outside(T value)` - Checks if the given [value] is outside the range.
/// - `toString()` - Returns a string representation of the range.
class Range<T extends Comparable> {
  final T start;
  final T end;

  const Range(
    this.start,
    this.end,
  );

  bool get isFixed => start == end;
  bool get isDynamic => !isFixed;
  bool get isUnbounded =>
      start == double.negativeInfinity && end == double.infinity;

  bool within(T value) {
    return value.compareTo(start) >= 0 && value.compareTo(end) <= 0;
  }

  bool outside(T value) {
    return !within(value);
  }

  T clamp(T value) {
    if (value.compareTo(start) < 0) {
      return start;
    } else if (value.compareTo(end) > 0) {
      return end;
    }
    return value;
  }

  /// Checks if two ranges are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Range<T>) return false;
    return start == other.start && end == other.end;
  }

  /// Returns the hash code for the range.
  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  /// Combines two ranges into a new range that spans from the minimum start to the maximum end.
  Range<T> operator +(Range<T> other) {
    final newStart = (start.compareTo(other.start) < 0) ? start : other.start;
    final newEnd = (end.compareTo(other.end) > 0) ? end : other.end;
    return Range(newStart, newEnd);
  }

  /// Subtracts one range from another, resulting in a new range.
  /// If the ranges do not overlap, returns the original range.
  Range<T>? operator -(Range<T> other) {
    if (other.end.compareTo(start) < 0 || other.start.compareTo(end) > 0) {
      return this;
    }
    final newStart = (start.compareTo(other.start) > 0) ? start : other.start;
    final newEnd = (end.compareTo(other.end) < 0) ? end : other.end;
    return (newStart.compareTo(newEnd) <= 0) ? Range(newStart, newEnd) : null;
  }

  @override
  String toString() {
    return 'Range{start: $start, end: $end}';
  }
}
