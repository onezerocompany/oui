import 'package:flutter/rendering.dart';

import 'oui_corner_path.dart';
import 'oui_corner_processed_radius.dart';
import 'oui_corner_radius.dart';

/// A class that defines the border radius with custom corner radii and smoothing.
class OuiCornerBorderRadius extends BorderRadius {
  /// Creates a border radius with the same radius and smoothing for all corners.
  OuiCornerBorderRadius({
    required double radius,
    double smoothing = 0,
  }) : this.only(
          topLeft: OuiCornerRadius(
            radius: radius,
            smoothing: smoothing,
          ),
          topRight: OuiCornerRadius(
            radius: radius,
            smoothing: smoothing,
          ),
          bottomLeft: OuiCornerRadius(
            radius: radius,
            smoothing: smoothing,
          ),
          bottomRight: OuiCornerRadius(
            radius: radius,
            smoothing: smoothing,
          ),
        );

  /// Creates a border radius with the same [OuiCornerRadius] for all corners.
  const OuiCornerBorderRadius.all(OuiCornerRadius radius)
      : this.only(
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        );

  /// Creates a border radius with different [OuiCornerRadius] for vertical corners.
  const OuiCornerBorderRadius.vertical({
    OuiCornerRadius top = OuiCornerRadius.zero,
    OuiCornerRadius bottom = OuiCornerRadius.zero,
  }) : this.only(
          topLeft: top,
          topRight: top,
          bottomLeft: bottom,
          bottomRight: bottom,
        );

  /// Creates a border radius with different [OuiCornerRadius] for horizontal corners.
  const OuiCornerBorderRadius.horizontal({
    OuiCornerRadius left = OuiCornerRadius.zero,
    OuiCornerRadius right = OuiCornerRadius.zero,
  }) : this.only(
          topLeft: left,
          topRight: right,
          bottomLeft: left,
          bottomRight: right,
        );

  /// Creates a border radius with different [OuiCornerRadius] for each corner.
  const OuiCornerBorderRadius.only({
    OuiCornerRadius topLeft = OuiCornerRadius.zero,
    OuiCornerRadius topRight = OuiCornerRadius.zero,
    OuiCornerRadius bottomLeft = OuiCornerRadius.zero,
    OuiCornerRadius bottomRight = OuiCornerRadius.zero,
  })  : _topLeft = topLeft,
        _topRight = topRight,
        _bottomLeft = bottomLeft,
        _bottomRight = bottomRight,
        super.only(
          topLeft: topLeft,
          bottomRight: topRight,
          topRight: topRight,
          bottomLeft: bottomLeft,
        );

  /// Creates a copy of this border radius with the given corner radii replaced.
  @override
  OuiCornerBorderRadius copyWith({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) {
    return OuiCornerBorderRadius.only(
      topLeft: topLeft is OuiCornerRadius ? topLeft : this.topLeft,
      topRight: topRight is OuiCornerRadius ? topRight : this.topRight,
      bottomLeft: bottomLeft is OuiCornerRadius ? bottomLeft : this.bottomLeft,
      bottomRight:
          bottomRight is OuiCornerRadius ? bottomRight : this.bottomRight,
    );
  }

  /// A border radius with all corners set to zero.
  static const OuiCornerBorderRadius zero =
      OuiCornerBorderRadius.all(OuiCornerRadius.zero);

  /// The top-left corner radius.
  @override
  OuiCornerRadius get topLeft => _topLeft;
  final OuiCornerRadius _topLeft;

  /// The top-right corner radius.
  @override
  OuiCornerRadius get topRight => _topRight;
  final OuiCornerRadius _topRight;

  /// The bottom-left corner radius.
  @override
  OuiCornerRadius get bottomLeft => _bottomLeft;
  final OuiCornerRadius _bottomLeft;

  /// The bottom-right corner radius.
  @override
  OuiCornerRadius get bottomRight => _bottomRight;
  final OuiCornerRadius _bottomRight;

  /// Converts the border radius to a [Path] for the given [Rect].
  Path toPath(Rect rect) {
    final width = rect.width;
    final height = rect.height;

    final result = Path();

    final processedTopLeft = ProcessedOuiCornerRadius(
      topLeft,
      width: width,
      height: height,
    );
    final processedBottomLeft = topLeft == bottomLeft
        ? processedTopLeft
        : ProcessedOuiCornerRadius(
            bottomLeft,
            width: width,
            height: height,
          );
    final processedBottomRight = bottomLeft == bottomRight
        ? processedBottomLeft
        : ProcessedOuiCornerRadius(
            bottomRight,
            width: width,
            height: height,
          );
    final processedTopRight = topRight == bottomRight
        ? processedBottomRight
        : ProcessedOuiCornerRadius(
            topRight,
            width: width,
            height: height,
          );

    result
      ..addOuiCorner(OuiCorner.topRight, processedTopRight, rect)
      ..addOuiCorner(OuiCorner.bottomRight, processedBottomRight, rect)
      ..addOuiCorner(OuiCorner.bottomLeft, processedBottomLeft, rect)
      ..addOuiCorner(OuiCorner.topLeft, processedTopLeft, rect);

    return result.transform(
      Matrix4.translationValues(rect.left, rect.top, 0).storage,
    );
  }

  /// Subtracts another [BorderRadiusGeometry] from this one.
  @override
  BorderRadiusGeometry subtract(BorderRadiusGeometry other) {
    if (other is OuiCornerBorderRadius) {
      return this - other;
    }
    return super.subtract(other);
  }

  /// Adds another [BorderRadiusGeometry] to this one.
  @override
  BorderRadiusGeometry add(BorderRadiusGeometry other) {
    if (other is OuiCornerBorderRadius) {
      return this + other;
    }
    return super.add(other);
  }

  /// Subtracts another [OuiCornerBorderRadius] from this one.
  @override
  OuiCornerBorderRadius operator -(BorderRadius other) {
    if (other is OuiCornerBorderRadius) {
      return OuiCornerBorderRadius.only(
        topLeft: (topLeft - other.topLeft) as OuiCornerRadius,
        topRight: (topRight - other.topRight) as OuiCornerRadius,
        bottomLeft: (bottomLeft - other.bottomLeft) as OuiCornerRadius,
        bottomRight: (bottomRight - other.bottomRight) as OuiCornerRadius,
      );
    }

    return this;
  }

  /// Adds another [OuiCornerBorderRadius] to this one.
  @override
  OuiCornerBorderRadius operator +(BorderRadius other) {
    if (other is OuiCornerBorderRadius) {
      return OuiCornerBorderRadius.only(
        topLeft: (topLeft + other.topLeft) as OuiCornerRadius,
        topRight: (topRight + other.topRight) as OuiCornerRadius,
        bottomLeft: (bottomLeft + other.bottomLeft) as OuiCornerRadius,
        bottomRight: (bottomRight + other.bottomRight) as OuiCornerRadius,
      );
    }
    return this;
  }

  /// Negates the [OuiCornerBorderRadius].
  @override
  OuiCornerBorderRadius operator -() {
    return OuiCornerBorderRadius.only(
      topLeft: (-topLeft) as OuiCornerRadius,
      topRight: (-topRight) as OuiCornerRadius,
      bottomLeft: (-bottomLeft) as OuiCornerRadius,
      bottomRight: (-bottomRight) as OuiCornerRadius,
    );
  }

  /// Multiplies the [OuiCornerBorderRadius] by a scalar.
  @override
  OuiCornerBorderRadius operator *(double other) {
    return OuiCornerBorderRadius.only(
      topLeft: topLeft * other,
      topRight: topRight * other,
      bottomLeft: bottomLeft * other,
      bottomRight: bottomRight * other,
    );
  }

  /// Divides the [OuiCornerBorderRadius] by a scalar.
  @override
  OuiCornerBorderRadius operator /(double other) {
    return OuiCornerBorderRadius.only(
      topLeft: topLeft / other,
      topRight: topRight / other,
      bottomLeft: bottomLeft / other,
      bottomRight: bottomRight / other,
    );
  }

  /// Integer divides the [OuiCornerBorderRadius] by a scalar.
  @override
  OuiCornerBorderRadius operator ~/(double other) {
    return OuiCornerBorderRadius.only(
      topLeft: topLeft ~/ other,
      topRight: topRight ~/ other,
      bottomLeft: bottomLeft ~/ other,
      bottomRight: bottomRight ~/ other,
    );
  }

  /// Modulo operation on the [OuiCornerBorderRadius] by a scalar.
  @override
  OuiCornerBorderRadius operator %(double other) {
    return OuiCornerBorderRadius.only(
      topLeft: topLeft % other,
      topRight: topRight % other,
      bottomLeft: bottomLeft % other,
      bottomRight: bottomRight % other,
    );
  }

  /// Linearly interpolates between two [OuiCornerBorderRadius] objects.
  static OuiCornerBorderRadius? lerp(
    OuiCornerBorderRadius? a,
    OuiCornerBorderRadius? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    if (a == null) {
      return b! * t;
    }
    if (b == null) {
      return a * (1.0 - t);
    }
    final clampedT = t.clamp(0.0, 1.0);
    return OuiCornerBorderRadius.only(
      topLeft: OuiCornerRadius.lerp(a.topLeft, b.topLeft, clampedT)!,
      topRight: OuiCornerRadius.lerp(a.topRight, b.topRight, clampedT)!,
      bottomLeft: OuiCornerRadius.lerp(a.bottomLeft, b.bottomLeft, clampedT)!,
      bottomRight:
          OuiCornerRadius.lerp(a.bottomRight, b.bottomRight, clampedT)!,
    );
  }

  /// Checks if the smoothing is default (0.0) for all corners.
  bool get isDefaultSmoothing {
    return [
      bottomLeft,
      bottomRight,
      topLeft,
      topRight,
    ].every((x) => x.smoothing == 0.0);
  }

  bool get hasNoRadius {
    return [
      bottomLeft,
      bottomRight,
      topLeft,
      topRight,
    ].every((x) => x.cornerRadius == 0.0);
  }

  bool get shouldRender => !hasNoRadius;

  /// Resolves the border radius for the given text direction.
  @override
  BorderRadius resolve(TextDirection? direction) => BorderRadius.only(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
      );

  /// Returns a string representation of the border radius.
  @override
  String toString() {
    if (topLeft == topRight &&
        topLeft == bottomRight &&
        topLeft == bottomLeft) {
      final radius = topLeft.toString();
      return 'OuiCornerBorderRadius(topLeft: $radius, topRight: $radius, bottomLeft: $radius, bottomRight: $radius)';
    }

    return 'OuiCornerBorderRadius('
        'topLeft: $topLeft,'
        'topRight: $topRight,'
        'bottomLeft: $bottomLeft,'
        'bottomRight: $bottomRight,'
        ')';
  }

  BoxDecoration apply(BoxDecoration decoration) {
    if (!shouldRender) {
      return decoration;
    }
    return decoration.copyWith(borderRadius: this);
  }
}
