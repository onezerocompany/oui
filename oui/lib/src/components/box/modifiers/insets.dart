import 'package:flutter/widgets.dart' show EdgeInsets, Padding;

import '../box_modifier.dart';

/// A class representing insets (padding or margins) for a box.
///
/// This class provides various constructors to create insets with different
/// configurations and supports arithmetic operations for combining insets.
class Insets extends BoxModifier {
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
  const Insets.all(double value)
      : top = value,
        right = value,
        bottom = value,
        left = value;

  /// Creates insets with separate values for vertical and horizontal sides.
  ///
  /// [vertical] The value to be applied to the top and bottom sides.
  /// [horizontal] The value to be applied to the left and right sides.
  const Insets.symmetric({
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
  const Insets.only({
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
  /// Returns a new [Insets] object with the updated values.
  Insets copyWith({
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    return Insets.only(
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
    );
  }

  bool get shouldRender => top > 0 || right > 0 || bottom > 0 || left > 0;

  /// Adds the values of another [Insets] object to this one.
  ///
  /// [other] The other [Insets] object.
  ///
  /// Returns a new [Insets] object with the combined values.
  Insets operator +(Insets other) {
    return Insets.only(
      top: top + other.top,
      right: right + other.right,
      bottom: bottom + other.bottom,
      left: left + other.left,
    );
  }

  /// Subtracts the values of another [Insets] object from this one.
  ///
  /// [other] The other [Insets] object.
  ///
  /// Returns a new [Insets] object with the subtracted values.
  Insets operator -(Insets other) {
    return Insets.only(
      top: top - other.top,
      right: right - other.right,
      bottom: bottom - other.bottom,
      left: left - other.left,
    );
  }

  /// Multiplies the values of this [Insets] object by a factor.
  ///
  /// [factor] The factor to multiply by.
  ///
  /// Returns a new [Insets] object with the multiplied values.
  Insets operator *(double factor) {
    return Insets.only(
      top: top * factor,
      right: right * factor,
      bottom: bottom * factor,
      left: left * factor,
    );
  }

  /// Divides the values of this [Insets] object by a factor.
  ///
  /// [factor] The factor to divide by.
  ///
  /// Returns a new [Insets] object with the divided values.
  Insets operator /(double factor) {
    return Insets.only(
      top: top / factor,
      right: right / factor,
      bottom: bottom / factor,
      left: left / factor,
    );
  }

  /// Converts this [Insets] object to an [EdgeInsets] object.
  ///
  /// Returns an [EdgeInsets] object with the same values.
  EdgeInsets get edgeInsets => EdgeInsets.only(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      );

  @override
  void modify(BoxModifierContext context) {
    if (!shouldRender) return;

    context.modifyContent(
      Padding(
        padding: edgeInsets,
        child: context.content,
      ),
    );
  }

  /// Returns a string representation of this [Insets] object.
  @override
  String toString() {
    return 'Insets(top: $top, right: $right, bottom: $bottom, left: $left)';
  }
}
