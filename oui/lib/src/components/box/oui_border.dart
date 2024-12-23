import 'package:flutter/widgets.dart';

import '../../core/colors/oui_color.dart';
import 'oui_box_side.dart';

/// A class that represents a side of a border with a specific thickness and color.
class OuiBorderSide {
  /// The thickness of the border side.
  final double thickness;

  /// The color of the border side.
  final OuiColor color;

  /// Creates a border side with the given thickness and color.
  const OuiBorderSide({
    required this.thickness,
    required this.color,
  });

  static const none = OuiBorderSide(
    thickness: 0,
    color: OuiColor.clear,
  );

  /// Converts this border side to a Flutter [BorderSide].
  BorderSide get flutterBorderSide {
    return BorderSide(
      width: thickness,
      color: color.flutterColor,
    );
  }

  /// Determines if the border side should be rendered.
  bool get shouldRender => thickness > 0 && color.isVisible;

  /// Creates a copy of this border side with the given properties replaced.
  OuiBorderSide copyWith({
    double? thickness,
    OuiColor? color,
  }) {
    return OuiBorderSide(
      thickness: thickness ?? this.thickness,
      color: color ?? this.color,
    );
  }

  /// Creates a copy of this border side with the given width.
  OuiBorderSide withWidth(double width) {
    return copyWith(thickness: width);
  }

  /// Creates a copy of this border side with the given color.
  OuiBorderSide withColor(OuiColor color) {
    return copyWith(color: color);
  }

  @override
  String toString() {
    return 'OuiBorderSide(width: $thickness, color: $color)';
  }
}

/// A class that represents a border with four sides.
class OuiBorder {
  /// The top side of the border.
  final OuiBorderSide? top;

  /// The right side of the border.
  final OuiBorderSide? right;

  /// The bottom side of the border.
  final OuiBorderSide? bottom;

  /// The left side of the border.
  final OuiBorderSide? left;

  /// Creates a border with the given sides.
  const OuiBorder({
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  /// Creates a border with the same border side for all four sides.
  const OuiBorder.all(
    OuiBorderSide borderSide,
  )   : top = borderSide,
        right = borderSide,
        bottom = borderSide,
        left = borderSide;

  /// Creates a border with symmetric vertical and horizontal sides.
  const OuiBorder.symmetric({
    required OuiBorderSide vertical,
    required OuiBorderSide horizontal,
  })  : top = vertical,
        bottom = vertical,
        right = horizontal,
        left = horizontal;

  /// Creates a border with only the specified sides.
  const OuiBorder.only({
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  const OuiBorder.forBoxSide(
    OuiBoxSide side,
    OuiBorderSide borderSide,
  )   : top = side == OuiBoxSide.top ? borderSide : null,
        right = side == OuiBoxSide.right ? borderSide : null,
        bottom = side == OuiBoxSide.bottom ? borderSide : null,
        left = side == OuiBoxSide.left ? borderSide : null;

  /// Converts this border to a Flutter [BoxBorder].
  BoxBorder get _flutterBorder {
    return Border(
      top: top?.flutterBorderSide ?? BorderSide.none,
      right: right?.flutterBorderSide ?? BorderSide.none,
      bottom: bottom?.flutterBorderSide ?? BorderSide.none,
      left: left?.flutterBorderSide ?? BorderSide.none,
    );
  }

  /// Applies this border to the given [BoxDecoration].
  BoxDecoration apply(BoxDecoration decoration) {
    return decoration.copyWith(border: _flutterBorder);
  }

  @override
  String toString() {
    return 'OuiBorder(top: $top, right: $right, bottom: $bottom, left: $left)';
  }
}
