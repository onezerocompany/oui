import 'package:flutter/painting.dart' as painting show BorderSide, Border;
import 'package:flutter/painting.dart' show BoxBorder;
import 'package:oui/src/components/box/box_modifier.dart';

import '../../../core/colors/color.dart';
import '../box_side.dart';

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

  @override
  String toString() {
    return 'BorderSide(width: $thickness, color: $color)';
  }
}

/// A class that represents a border with four sides.
class Border extends BoxModifier {
  /// The top side of the border.
  final BorderSide? top;

  /// The right side of the border.
  final BorderSide? right;

  /// The bottom side of the border.
  final BorderSide? bottom;

  /// The left side of the border.
  final BorderSide? left;

  /// Creates a border with the given sides.
  const Border({
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  /// Creates a border with the same border side for all four sides.
  const Border.all(
    BorderSide borderSide,
  )   : top = borderSide,
        right = borderSide,
        bottom = borderSide,
        left = borderSide;

  /// Creates a border with symmetric vertical and horizontal sides.
  const Border.symmetric({
    required BorderSide vertical,
    required BorderSide horizontal,
  })  : top = vertical,
        bottom = vertical,
        right = horizontal,
        left = horizontal;

  /// Creates a border with only the specified sides.
  const Border.only({
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  const Border.forBoxSide(
    BoxSide side,
    BorderSide borderSide,
  )   : top = side == BoxSide.top ? borderSide : null,
        right = side == BoxSide.right ? borderSide : null,
        bottom = side == BoxSide.bottom ? borderSide : null,
        left = side == BoxSide.left ? borderSide : null;

  bool get shouldRender {
    return top?.shouldRender == true ||
        right?.shouldRender == true ||
        bottom?.shouldRender == true ||
        left?.shouldRender == true;
  }

  /// Converts this border to a Flutter [BoxBorder].
  BoxBorder get _uiBorder {
    return painting.Border(
      top: top?.uiBorderSide ?? painting.BorderSide.none,
      right: right?.uiBorderSide ?? painting.BorderSide.none,
      bottom: bottom?.uiBorderSide ?? painting.BorderSide.none,
      left: left?.uiBorderSide ?? painting.BorderSide.none,
    );
  }

  @override
  void modify(BoxModifierContext context) {
    if (shouldRender) {
      context.decorate(
        context.decoration.copyWith(
          border: _uiBorder,
        ),
      );
    }
  }

  @override
  String toString() {
    return 'Border(top: $top, right: $right, bottom: $bottom, left: $left)';
  }
}
