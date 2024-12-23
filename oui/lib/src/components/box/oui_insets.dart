import 'package:flutter/widgets.dart';

/// A class representing insets (padding or margins) for a box.
///
/// This class provides various constructors to create insets with different
/// configurations and supports arithmetic operations for combining insets.
class OuiInsets {
  /// The top inset value.
  final double top;

  /// The right inset value.
  final double right;

  /// The bottom inset value.
  final double bottom;

  /// The left inset value.
  final double left;

  /// Creates insets with the same value for all sides.
  ///
  /// [value] The value to be applied to all sides.
  const OuiInsets.all(double value)
      : top = value,
        right = value,
        bottom = value,
        left = value;

  /// Creates insets with separate values for vertical and horizontal sides.
  ///
  /// [vertical] The value to be applied to the top and bottom sides.
  /// [horizontal] The value to be applied to the left and right sides.
  const OuiInsets.symmetric({
    double vertical = 0,
    double horizontal = 0,
  })  : top = vertical,
        bottom = vertical,
        right = horizontal,
        left = horizontal;

  /// Creates insets with specific values for each side.
  ///
  /// [top] The value for the top side.
  /// [right] The value for the right side.
  /// [bottom] The value for the bottom side.
  /// [left] The value for the left side.
  const OuiInsets.only({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  /// Creates a copy of this insets object with the given values replaced.
  ///
  /// [top] The new value for the top side.
  /// [right] The new value for the right side.
  /// [bottom] The new value for the bottom side.
  /// [left] The new value for the left side.
  ///
  /// Returns a new [OuiInsets] object with the updated values.
  OuiInsets copyWith({
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    return OuiInsets.only(
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
    );
  }

  /// Adds the values of another [OuiInsets] object to this one.
  ///
  /// [other] The other [OuiInsets] object.
  ///
  /// Returns a new [OuiInsets] object with the combined values.
  OuiInsets operator +(OuiInsets other) {
    return OuiInsets.only(
      top: top + other.top,
      right: right + other.right,
      bottom: bottom + other.bottom,
      left: left + other.left,
    );
  }

  /// Subtracts the values of another [OuiInsets] object from this one.
  ///
  /// [other] The other [OuiInsets] object.
  ///
  /// Returns a new [OuiInsets] object with the subtracted values.
  OuiInsets operator -(OuiInsets other) {
    return OuiInsets.only(
      top: top - other.top,
      right: right - other.right,
      bottom: bottom - other.bottom,
      left: left - other.left,
    );
  }

  /// Multiplies the values of this [OuiInsets] object by a factor.
  ///
  /// [factor] The factor to multiply by.
  ///
  /// Returns a new [OuiInsets] object with the multiplied values.
  OuiInsets operator *(double factor) {
    return OuiInsets.only(
      top: top * factor,
      right: right * factor,
      bottom: bottom * factor,
      left: left * factor,
    );
  }

  /// Divides the values of this [OuiInsets] object by a factor.
  ///
  /// [factor] The factor to divide by.
  ///
  /// Returns a new [OuiInsets] object with the divided values.
  OuiInsets operator /(double factor) {
    return OuiInsets.only(
      top: top / factor,
      right: right / factor,
      bottom: bottom / factor,
      left: left / factor,
    );
  }

  /// Converts this [OuiInsets] object to an [EdgeInsets] object.
  ///
  /// Returns an [EdgeInsets] object with the same values.
  EdgeInsets get edgeInsets => EdgeInsets.only(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      );

  /// Returns a string representation of this [OuiInsets] object.
  @override
  String toString() {
    return 'OuiInsets(top: $top, right: $right, bottom: $bottom, left: $left)';
  }

  /// Applies this [OuiInsets] object to a [BoxDecoration].
  ///
  /// [decoration] The [BoxDecoration] to apply the insets to.
  void apply(BoxDecoration decoration) {}
}
