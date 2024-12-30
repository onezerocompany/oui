import 'dart:ui' show Radius, lerpDouble;

/// A class representing a corner radius with additional smoothing property.
class CornerRadius extends Radius {
  /// Creates a [CornerRadius] with the given [radius] and [smoothing].
  const CornerRadius({
    required double radius,
    this.smoothing = 0,
  })  : assert(radius >= 0, 'Radius must be non-negative'),
        assert(smoothing >= 0, 'Smoothing must be non-negative'),
        assert(smoothing <= 1, 'Smoothing must be between 0 and 1'),
        super.circular(radius);

  /// The smoothing factor for the corner radius.
  ///
  /// The value should be between 0.0 and 1.0, where 0.0 represents no smoothing
  /// (a sharp corner) and 1.0 represents maximum smoothing (a fully rounded corner).
  final double smoothing;

  /// Gets the corner radius value.
  double get cornerRadius => x;

  /// A constant [CornerRadius] with zero radius and smoothing.
  static const zero = CornerRadius(
    radius: 0,
    smoothing: 0,
  );

  /// Negates the corner radius value.
  @override
  CornerRadius operator -() => CornerRadius(
        radius: -cornerRadius,
        smoothing: smoothing,
      );

  /// Subtracts another [Radius] from this [CornerRadius].
  @override
  CornerRadius operator -(Radius other) {
    if (other is CornerRadius) {
      return CornerRadius(
        radius: cornerRadius - other.cornerRadius,
        smoothing: (smoothing + other.smoothing) / 2,
      );
    }
    return CornerRadius(
      radius: cornerRadius - other.x,
      smoothing: smoothing,
    );
  }

  /// Adds another [Radius] to this [CornerRadius].
  @override
  CornerRadius operator +(Radius other) {
    if (other is CornerRadius) {
      return CornerRadius(
        radius: cornerRadius + other.cornerRadius,
        smoothing: (smoothing + other.smoothing) / 2,
      );
    }
    return CornerRadius(
      radius: cornerRadius + other.x,
      smoothing: smoothing,
    );
  }

  /// Multiplies the corner radius and smoothing by a scalar [operand].
  @override
  CornerRadius operator *(double operand) {
    assert(operand >= 0, 'Operand must be non-negative');
    return CornerRadius(
      radius: cornerRadius * operand,
      smoothing: smoothing * operand,
    );
  }

  /// Divides the corner radius and smoothing by a scalar [operand].
  @override
  CornerRadius operator /(double operand) {
    assert(operand != 0, 'Operand must not be zero');
    return CornerRadius(
      radius: cornerRadius / operand,
      smoothing: smoothing / operand,
    );
  }

  /// Integer divides the corner radius and smoothing by a scalar [operand].
  @override
  CornerRadius operator ~/(double operand) {
    assert(operand != 0, 'Operand must not be zero');
    return CornerRadius(
      radius: (cornerRadius ~/ operand).toDouble(),
      smoothing: (smoothing ~/ operand).toDouble(),
    );
  }

  /// Computes the remainder of the corner radius and smoothing divided by a scalar [operand].
  @override
  CornerRadius operator %(double operand) {
    assert(operand != 0, 'Operand must not be zero');
    return CornerRadius(
      radius: cornerRadius % operand,
      smoothing: smoothing % operand,
    );
  }

  /// Linearly interpolates between two [CornerRadius] objects.
  static CornerRadius? lerp(
    CornerRadius? a,
    CornerRadius? b,
    double t,
  ) {
    assert(t >= 0 && t <= 1, 'Interpolation factor t must be between 0 and 1');
    if (b == null) {
      if (a == null) {
        return null;
      } else {
        final double k = 1.0 - t;
        return CornerRadius(
          radius: a.cornerRadius * k,
          smoothing: a.smoothing * k,
        );
      }
    } else {
      if (a == null) {
        return CornerRadius(
          radius: b.cornerRadius * t,
          smoothing: b.smoothing * t,
        );
      } else {
        return CornerRadius(
          radius: lerpDouble(a.cornerRadius, b.cornerRadius, t) ?? 0,
          smoothing: lerpDouble(a.smoothing, b.smoothing, t) ?? 0,
        );
      }
    }
  }

  /// Compares this instance with another object for equality.
  ///
  /// Returns `true` if the other object is identical to this instance,
  /// or if the other object is of the same runtime type and has the same
  /// `cornerRadius` and `smoothing` values.
  ///
  /// - Parameter other: The object to compare with this instance.
  /// - Returns: `true` if the objects are equal, `false` otherwise.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (runtimeType != other.runtimeType) {
      return false;
    }

    return other is CornerRadius &&
        other.cornerRadius == cornerRadius &&
        other.smoothing == smoothing;
  }

  @override
  int get hashCode => Object.hash(cornerRadius, smoothing);

  @override
  String toString() {
    return 'CornerRadius(cornerRadius: ${cornerRadius.toStringAsFixed(2)}, smoothing: ${smoothing.toStringAsFixed(2)})';
  }
}
