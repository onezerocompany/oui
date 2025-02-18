import 'package:flutter/painting.dart' as painting
    show Border, BorderSide, BoxBorder;
import 'package:flutter/rendering.dart'
    show BoxBorder, BoxDecoration, Decoration, ShapeDecoration;
import 'package:oui/src/core/component.dart';
import 'package:oui/src/core/interpolation.dart';

import 'colors.dart';
import 'corners.dart';
import 'geometry.dart';
import 'utils.dart';

/// An enumeration that defines the alignment of the border.
///
/// The [BorderAlign] enum provides three possible values:
/// - [inside]: The border is aligned inside the boundary.
/// - [center]: The border is centered on the boundary.
/// - [outside]: The border is aligned outside the boundary.
enum BorderAlign {
  inside,
  center,
  outside,
}

/// A class that represents a side of a border with a specific thickness and color.
class BorderSide with Interpolable<BorderSide> {
  /// The thickness of the border side.
  final double thickness;

  /// The color of the border side.
  final Color? color;

  /// Creates a border side with the given thickness and color.
  const BorderSide({
    required this.thickness,
    this.color,
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
      color: (color ?? Color.clear).uiColor,
    );
  }

  /// Determines if the border side should be rendered.
  bool get shouldRender => thickness > 0 && color != Color.clear;

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

  /// Creates a copy of this border side with the given color if the color is null.
  BorderSide withColorIfNull(Color color) {
    return copyWith(color: this.color ?? color);
  }

  @override
  String toString() {
    return 'BorderSide(width: $thickness, color: $color)';
  }

  BorderSide scale(double t) {
    return copyWith(thickness: thickness * t);
  }

  @override
  BorderSide lerp(BorderSide a, BorderSide b, double t) {
    return BorderSide(
      // thickness: lerpDouble(a.thickness, b.thickness, t)
      thickness: const DoubleInterpolator().resolve(
        a.thickness,
        b.thickness,
        t,
      ),
    );
  }
}

extension BorderSideExtension on painting.BorderSide {
  BorderSide get ouiBorderSide => BorderSide.fromBorderSide(this);
}

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

  const Border.forRectSide(
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

  Border withColor(Color color) {
    return Border.only(
      top: top?.withColorIfNull(color),
      right: right?.withColorIfNull(color),
      bottom: bottom?.withColorIfNull(color),
      left: left?.withColorIfNull(color),
      align: align,
    );
  }

  /// Converts this border to a Flutter [BoxBorder].
  painting.BoxBorder uiBorder(ComponentContext context) {
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

/// A class that modifies a border.
class BorderModifier extends ComponentModifier with DecorationModifier {
  final bool auto;
  final Border border;

  /// Creates a border modifier with the given border.
  const BorderModifier(
    this.border, {
    this.auto = false,
    super.condition,
  });

  @override
  Decoration? decorate(
    Decoration decoration,
    ComponentContext context,
  ) {
    if (!border.shouldRender) return null;
    final normalizedBorder = border.withColor(
      context.colors.edge,
    );

    if (decoration is ShapeDecoration) {
      if (decoration.shape is CornerBorder) {
        return decoration.copyWith(
          shape: (decoration.shape as CornerBorder).copyWith(
            side: normalizedBorder.side.uiBorderSide,
            align: border.align,
          ),
        );
      } else {
        return decoration.copyWith(
          shape: CornerBorder(
            side: normalizedBorder.side,
            borderAlign: border.align,
          ),
        );
      }
    }

    if (decoration is BoxDecoration) {
      return decoration.copyWith(
        border: normalizedBorder.uiBorder(context),
      );
    }

    return null;
  }

  @override
  String toString() {
    return 'BorderModifier(border: $border)';
  }
}

mixin ModifiableBorder<Type extends Component> on Component<Type> {
  Type borders({
    BorderSide? top,
    BorderSide? right,
    BorderSide? bottom,
    BorderSide? left,
    BorderAlign align = BorderAlign.inside,
  }) {
    return withModifier(
      BorderModifier(
        Border(
          top: top,
          right: right,
          bottom: bottom,
          left: left,
          align: align,
        ),
      ),
    );
  }

  Type borderForSide(
    RectangleSide boxSide,
    BorderSide borderSide, {
    BorderAlign align = BorderAlign.inside,
  }) {
    return withModifier(
      BorderModifier(
        Border(
          top: boxSide == RectangleSide.top ? borderSide : null,
          right: boxSide == RectangleSide.right ? borderSide : null,
          bottom: boxSide == RectangleSide.bottom ? borderSide : null,
          left: boxSide == RectangleSide.left ? borderSide : null,
          align: align,
        ),
      ),
    );
  }

  Type get noBorder => border(0);
  Type get bordered => border();

  Type border([
    double thickness = 1,
    Color? color,
    BorderAlign align = BorderAlign.inside,
  ]) {
    return withModifier(
      BorderModifier(
        Border.all(
          BorderSide(
            thickness: thickness,
            color: color,
          ),
          align: align,
        ),
      ),
    );
  }
}
