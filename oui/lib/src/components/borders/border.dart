import 'package:flutter/painting.dart' as painting show Border, BorderSide;
import 'package:flutter/painting.dart' show BoxBorder;

import '../../core/geometry/rectangle_side.dart';
import 'border_align.dart';
import 'border_side.dart';

/// A class that represents a border with four sides.
class Border {
  /// The top side of the border.
  final BorderSide? top;

  /// The right side of the border.
  final BorderSide? right;

  /// The bottom side of the border.
  final BorderSide? bottom;

  /// The left side of the border.
  final BorderSide? left;

  /// Alignment of the border.
  final BorderAlign align;

  /// Creates a border with the given sides.
  const Border({
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.align = BorderAlign.inside,
  });

  /// Creates a border with the same border side for all four sides.
  const Border.all(
    BorderSide borderSide, {
    this.align = BorderAlign.inside,
  })  : top = borderSide,
        right = borderSide,
        bottom = borderSide,
        left = borderSide;

  /// Creates a border with symmetric vertical and horizontal sides.
  const Border.symmetric({
    required BorderSide vertical,
    required BorderSide horizontal,
    this.align = BorderAlign.inside,
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
    this.align = BorderAlign.inside,
  });

  const Border.forBoxSide(
    RectangleSide side,
    BorderSide borderSide, {
    this.align = BorderAlign.inside,
  })  : top = side == RectangleSide.top ? borderSide : null,
        right = side == RectangleSide.right ? borderSide : null,
        bottom = side == RectangleSide.bottom ? borderSide : null,
        left = side == RectangleSide.left ? borderSide : null;

  bool get shouldRender {
    return top?.shouldRender == true ||
        right?.shouldRender == true ||
        bottom?.shouldRender == true ||
        left?.shouldRender == true;
  }

  /// Converts this border to a Flutter [BoxBorder].
  BoxBorder get uiBorder {
    return painting.Border(
      top: top?.uiBorderSide ?? painting.BorderSide.none,
      right: right?.uiBorderSide ?? painting.BorderSide.none,
      bottom: bottom?.uiBorderSide ?? painting.BorderSide.none,
      left: left?.uiBorderSide ?? painting.BorderSide.none,
    );
  }

  BorderSide get side {
    if (top?.shouldRender == true) return top!;
    if (right?.shouldRender == true) return right!;
    if (bottom?.shouldRender == true) return bottom!;
    if (left?.shouldRender == true) return left!;
    return BorderSide.none;
  }

  @override
  String toString() {
    return 'Border(top: $top, right: $right, bottom: $bottom, left: $left)';
  }
}
