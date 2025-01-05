import 'package:flutter/painting.dart' as painting show BorderSide;
import 'package:oui/src/core/colors/color.dart';

import '../../core/utils/lerp_double.dart';

/// A class that represents a side of a border with a specific thickness and color.
class BorderSide {
  /// The thickness of the border side.
  final double thickness;

  /// The color of the border side.
  final Color color;

  /// Creates a border side with the given thickness and color.
  const BorderSide({
    required this.thickness,
    required this.color,
  });

  BorderSide.fromBorderSide(painting.BorderSide side)
      : thickness = side.width,
        color = side.color.ouiColor;

  static const none = BorderSide(
    thickness: 0,
    color: Color.clear,
  );

  /// Converts this border side to a Flutter [BorderSide].
  painting.BorderSide get uiBorderSide {
    return painting.BorderSide(
      width: thickness,
      color: color.uiColor,
    );
  }

  /// Determines if the border side should be rendered.
  bool get shouldRender => thickness > 0 && color.isVisible;

  /// Creates a copy of this border side with the given properties replaced.
  BorderSide copyWith({
    double? thickness,
    Color? color,
  }) {
    return BorderSide(
      thickness: thickness ?? this.thickness,
      color: color ?? this.color,
    );
  }

  /// Creates a copy of this border side with the given width.
  BorderSide withWidth(double width) {
    return copyWith(thickness: width);
  }

  /// Creates a copy of this border side with the given color.
  BorderSide withColor(Color color) {
    return copyWith(color: color);
  }

  /// Linearly interpolate between two border sides.
  static BorderSide _lerp(BorderSide a, BorderSide b, double t) {
    return BorderSide(
      thickness: lerpDouble(a.thickness, b.thickness, t),
      color: Color.lerp(a.color, b.color, t),
    );
  }

  /// Linearly interpolate from this border side to another border side.
  BorderSide lerpTo(BorderSide other, double t) {
    return _lerp(this, other, t);
  }

  /// Linearly interpolate from another border side to this border side.
  BorderSide lerpFrom(BorderSide other, double t) {
    return _lerp(other, this, t);
  }

  @override
  String toString() {
    return 'BorderSide(width: $thickness, color: $color)';
  }

  BorderSide scale(double t) {
    return copyWith(thickness: thickness * t);
  }
}

extension BorderSideExtension on painting.BorderSide {
  BorderSide get ouiBorderSide => BorderSide.fromBorderSide(this);
}
