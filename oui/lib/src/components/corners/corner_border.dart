import 'dart:ui' show Canvas, Rect, TextDirection;
import 'package:flutter/rendering.dart'
    show
        BorderSide,
        BorderStyle,
        EdgeInsets,
        EdgeInsetsGeometry,
        OutlinedBorder,
        Path,
        ShapeBorder;

import 'corner_border_radius.dart';
import 'corner_radius.dart';

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

/// A custom border with configurable corner radius and alignment.
///
/// The [CornerBorder] class allows you to create a border with rounded corners
/// and specify the alignment of the border (inside, center, or outside).
///
/// Example usage:
/// ```dart
/// CornerBorder(
///   side: BorderSide(color: Colors.black, width: 2.0),
///   borderRadius: CornerBorderRadius.all(CornerRadius.circular(8.0)),
///   borderAlign: BorderAlign.center,
/// )
/// ```
///
/// Parameters:
/// - [side]: The border side configuration, including color and width.
/// - [borderRadius]: The radius of the corners. Defaults to [CornerBorderRadius.zero].
/// - [borderAlign]: The alignment of the border. Defaults to [BorderAlign.inside].
class CornerBorder extends OutlinedBorder {
  /// Creates a border with rounded corners and configurable alignment.
  ///
  /// The [side] parameter specifies the border side configuration, including color and width.
  /// The [borderRadius] parameter specifies the radius of the corners. Defaults to [CornerBorderRadius.zero].
  /// The [borderAlign] parameter specifies the alignment of the border. Defaults to [BorderAlign.inside].
  const CornerBorder({
    super.side,
    this.borderRadius = CornerBorderRadius.zero,
    this.borderAlign = BorderAlign.inside,
  });

  final CornerBorderRadius borderRadius;
  final BorderAlign borderAlign;

  /// Calculates the dimensions of the border based on the alignment.
  EdgeInsetsGeometry get _dimensions {
    switch (borderAlign) {
      case BorderAlign.inside:
        return EdgeInsets.all(side.width);
      case BorderAlign.center:
        return EdgeInsets.all(side.width / 2);
      case BorderAlign.outside:
        return EdgeInsets.zero;
    }
  }

  @override
  EdgeInsetsGeometry get dimensions => _dimensions;

  /// Adjusts the rectangle based on the border alignment and width.
  ///
  /// The [rect] parameter specifies the original rectangle.
  /// The [width] parameter specifies the width of the border.
  /// The [align] parameter specifies the alignment of the border.
  Rect _adjustRect(Rect rect, double width, BorderAlign align) {
    assert(
      width >= 0,
      'Width must be non-negative',
    ); // Validate that width is non-negative
    switch (align) {
      case BorderAlign.inside:
        // Deflate the rect by half the width to draw the border inside
        return rect.deflate(width / 2);
      case BorderAlign.center:
        // No adjustment needed for center alignment
        return rect;
      case BorderAlign.outside:
        // Inflate the rect by half the width to draw the border outside
        return rect.inflate(width / 2);
    }
  }

  /// Adjusts the corner radius based on the border alignment and width.
  ///
  /// The [radius] parameter specifies the original corner radius.
  /// The [width] parameter specifies the width of the border.
  /// The [align] parameter specifies the alignment of the border.
  CornerBorderRadius _adjustRadius(
    CornerBorderRadius radius,
    double width,
    BorderAlign align,
  ) {
    assert(
      width >= 0,
      'Width must be non-negative',
    ); // Validate that width is non-negative
    final adjustment = CornerRadius(radius: width / 2, smoothing: 1.0);
    switch (align) {
      case BorderAlign.inside:
        // Reduce the radius by half the width to draw the border inside
        return radius - CornerBorderRadius.all(adjustment);
      case BorderAlign.center:
        // No adjustment needed for center alignment
        return radius;
      case BorderAlign.outside:
        // Increase the radius by half the width to draw the border outside
        return radius + CornerBorderRadius.all(adjustment);
    }
  }

  /// Creates a path for the border based on the rectangle and corner radius.
  ///
  /// The [rect] parameter specifies the rectangle.
  /// The [radius] parameter specifies the corner radius.
  /// The [textDirection] parameter specifies the text direction.
  Path _createPath(
    Rect rect,
    CornerBorderRadius radius, {
    TextDirection? textDirection,
  }) {
    if (radius.isDefaultSmoothing) {
      return Path()..addRRect(radius.resolve(textDirection).toRRect(rect));
    }
    return radius.toPath(rect);
  }

  @override
  ShapeBorder scale(double t) {
    return CornerBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  /// Linearly interpolates between two [CornerBorder] shapes.
  ///
  /// The [other] parameter specifies the other shape to interpolate with.
  /// The [t] parameter specifies the interpolation factor.
  ShapeBorder? lerp(ShapeBorder? other, double t) {
    if (other is! CornerBorder) {
      return super.lerpFrom(
        other,
        t,
      );
    }
    return CornerBorder(
      side: BorderSide.lerp(side, other.side, t),
      borderRadius: CornerBorderRadius.lerp(
        borderRadius,
        other.borderRadius,
        t,
      )!,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) => lerp(a, t);

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) => lerp(b, t);

  /// Returns the inner path of the border based on the rectangle and text direction.
  ///
  /// The [rect] parameter specifies the rectangle.
  /// The [textDirection] parameter specifies the text direction.
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final innerRect = _adjustRect(rect, side.width, borderAlign);
    final radius = _adjustRadius(borderRadius, side.width, borderAlign);
    return _createPath(innerRect, radius, textDirection: textDirection);
  }

  /// Returns the outer path of the border based on the rectangle and text direction.
  ///
  /// The [rect] parameter specifies the rectangle.
  /// The [textDirection] parameter specifies the text direction.
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _createPath(rect, borderRadius, textDirection: textDirection);
  }

  /// Paints the border on the given canvas.
  ///
  /// The [canvas] parameter specifies the canvas to paint on.
  /// The [rect] parameter specifies the rectangle to paint within.
  /// The [textDirection] parameter specifies the text direction.
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (rect.isEmpty) {
      return;
    }
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final adjustedRect = _adjustRect(rect, side.width, borderAlign);
        final adjustedBorderRadius =
            _adjustRadius(borderRadius, side.width, borderAlign);
        final outerPath = _createPath(
          adjustedRect,
          adjustedBorderRadius,
          textDirection: textDirection,
        );
        canvas.drawPath(outerPath, side.toPaint());
        break;
    }
  }

  /// Creates a copy of this border with the given parameters.
  ///
  /// The [side] parameter specifies the border side configuration.
  /// The [borderRadius] parameter specifies the corner radius.
  /// The [borderAlign] parameter specifies the alignment of the border.
  @override
  CornerBorder copyWith({
    BorderSide? side,
    CornerBorderRadius? borderRadius,
    BorderAlign? borderAlign,
  }) {
    return CornerBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      borderAlign: borderAlign ?? this.borderAlign,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CornerBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.borderAlign == borderAlign;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius, borderAlign);

  @override
  String toString() {
    return 'CornerBorder(side: $side, borderRadius: $borderRadius, borderAlign: $borderAlign)';
  }
}
