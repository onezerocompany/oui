import 'dart:ui';

/// A class representing a corner radius with additional smoothing property.
class OuiCornerRadius extends Radius {
  /// Creates a [OuiCornerRadius] with the given [radius] and [smoothing].
  const OuiCornerRadius({
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

  /// A constant [OuiCornerRadius] with zero radius and smoothing.
  static const zero = OuiCornerRadius(
    radius: 0,
    smoothing: 0,
  );

  /// Negates the corner radius value.
  @override
  Radius operator -() => OuiCornerRadius(
        radius: -cornerRadius,
        smoothing: smoothing,
      );

  /// Subtracts another [Radius] from this [OuiCornerRadius].
  @override
  Radius operator -(Radius other) {
    if (other is OuiCornerRadius) {
      return OuiCornerRadius(
        radius: cornerRadius - other.cornerRadius,
        smoothing: (smoothing + other.smoothing) / 2,
      );
    }
    return OuiCornerRadius(
      radius: cornerRadius - other.x,
      smoothing: smoothing,
    );
  }

  /// Adds another [Radius] to this [OuiCornerRadius].
  @override
  Radius operator +(Radius other) {
    if (other is OuiCornerRadius) {
      return OuiCornerRadius(
        radius: cornerRadius + other.cornerRadius,
        smoothing: (smoothing + other.smoothing) / 2,
      );
    }
    return OuiCornerRadius(
      radius: cornerRadius + other.x,
      smoothing: smoothing,
    );
  }

  /// Multiplies the corner radius and smoothing by a scalar [operand].
  @override
  OuiCornerRadius operator *(double operand) {
    assert(operand >= 0, 'Operand must be non-negative');
    return OuiCornerRadius(
      radius: cornerRadius * operand,
      smoothing: smoothing * operand,
    );
  }

  /// Divides the corner radius and smoothing by a scalar [operand].
  @override
  OuiCornerRadius operator /(double operand) {
    assert(operand != 0, 'Operand must not be zero');
    return OuiCornerRadius(
      radius: cornerRadius / operand,
      smoothing: smoothing / operand,
    );
  }

  /// Integer divides the corner radius and smoothing by a scalar [operand].
  @override
  OuiCornerRadius operator ~/(double operand) {
    assert(operand != 0, 'Operand must not be zero');
    return OuiCornerRadius(
      radius: (cornerRadius ~/ operand).toDouble(),
      smoothing: (smoothing ~/ operand).toDouble(),
    );
  }

  /// Computes the remainder of the corner radius and smoothing divided by a scalar [operand].
  @override
  OuiCornerRadius operator %(double operand) {
    assert(operand != 0, 'Operand must not be zero');
    return OuiCornerRadius(
      radius: cornerRadius % operand,
      smoothing: smoothing % operand,
    );
  }

  /// Linearly interpolates between two [OuiCornerRadius] objects.
  static OuiCornerRadius? lerp(
    OuiCornerRadius? a,
    OuiCornerRadius? b,
    double t,
  ) {
    assert(t >= 0 && t <= 1, 'Interpolation factor t must be between 0 and 1');
    if (b == null) {
      if (a == null) {
        return null;
      } else {
        final double k = 1.0 - t;
        return OuiCornerRadius(
          radius: a.cornerRadius * k,
          smoothing: a.smoothing * k,
        );
      }
    } else {
      if (a == null) {
        return OuiCornerRadius(
          radius: b.cornerRadius * t,
          smoothing: b.smoothing * t,
        );
      } else {
        return OuiCornerRadius(
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

    return other is OuiCornerRadius &&
        other.cornerRadius == cornerRadius &&
        other.smoothing == smoothing;
  }

  @override
  int get hashCode => Object.hash(cornerRadius, smoothing);

  @override
  String toString() {
    return 'OuiCornerRadius(cornerRadius: ${cornerRadius.toStringAsFixed(2)}, smoothing: ${smoothing.toStringAsFixed(2)})';
  }
}
