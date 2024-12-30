import 'package:flutter/rendering.dart'
    show
        BorderRadius,
        BorderRadiusGeometry,
        BoxDecoration,
        Matrix4,
        Path,
        Radius,
        Rect,
        TextDirection;

import 'corner_path.dart';
import 'corner_radius.dart';
import 'processed_corner_radius.dart';

/// A class that defines the border radius with custom corner radii and smoothing.
class CornerBorderRadius extends BorderRadius {
  /// Creates a border radius with the same radius and smoothing for all corners.
  CornerBorderRadius({
    required double radius,
    double smoothing = 0,
  }) : this.only(
          topLeft: CornerRadius(
            radius: radius,
            smoothing: smoothing,
          ),
          topRight: CornerRadius(
            radius: radius,
            smoothing: smoothing,
          ),
          bottomLeft: CornerRadius(
            radius: radius,
            smoothing: smoothing,
          ),
          bottomRight: CornerRadius(
            radius: radius,
            smoothing: smoothing,
          ),
        );

  /// Creates a border radius with the same [CornerRadius] for all corners.
  const CornerBorderRadius.all(CornerRadius radius)
      : this.only(
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        );

  /// Creates a border radius with different [CornerRadius] for vertical corners.
  const CornerBorderRadius.vertical({
    CornerRadius top = CornerRadius.zero,
    CornerRadius bottom = CornerRadius.zero,
  }) : this.only(
          topLeft: top,
          topRight: top,
          bottomLeft: bottom,
          bottomRight: bottom,
        );

  /// Creates a border radius with different [CornerRadius] for horizontal corners.
  const CornerBorderRadius.horizontal({
    CornerRadius left = CornerRadius.zero,
    CornerRadius right = CornerRadius.zero,
  }) : this.only(
          topLeft: left,
          topRight: right,
          bottomLeft: left,
          bottomRight: right,
        );

  /// Creates a border radius with different [CornerRadius] for each corner.
  const CornerBorderRadius.only({
    CornerRadius super.topLeft = CornerRadius.zero,
    CornerRadius super.topRight = CornerRadius.zero,
    CornerRadius super.bottomLeft = CornerRadius.zero,
    CornerRadius bottomRight = CornerRadius.zero,
  })  : _topLeft = topLeft,
        _topRight = topRight,
        _bottomLeft = bottomLeft,
        _bottomRight = bottomRight,
        super.only(
          bottomRight: topRight,
        );

  /// Creates a copy of this border radius with the given corner radii replaced.
  @override
  CornerBorderRadius copyWith({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) {
    return CornerBorderRadius.only(
      topLeft: topLeft is CornerRadius ? topLeft : this.topLeft,
      topRight: topRight is CornerRadius ? topRight : this.topRight,
      bottomLeft: bottomLeft is CornerRadius ? bottomLeft : this.bottomLeft,
      bottomRight: bottomRight is CornerRadius ? bottomRight : this.bottomRight,
    );
  }

  /// A border radius with all corners set to zero.
  static const CornerBorderRadius zero =
      CornerBorderRadius.all(CornerRadius.zero);

  /// The top-left corner radius.
  @override
  CornerRadius get topLeft => _topLeft;
  final CornerRadius _topLeft;

  /// The top-right corner radius.
  @override
  CornerRadius get topRight => _topRight;
  final CornerRadius _topRight;

  /// The bottom-left corner radius.
  @override
  CornerRadius get bottomLeft => _bottomLeft;
  final CornerRadius _bottomLeft;

  /// The bottom-right corner radius.
  @override
  CornerRadius get bottomRight => _bottomRight;
  final CornerRadius _bottomRight;

  /// Converts the border radius to a [Path] for the given [Rect].
  Path toPath(Rect rect) {
    final width = rect.width;
    final height = rect.height;

    final result = Path();

    final processedTopLeft = ProcessedCornerRadius(
      topLeft,
      width: width,
      height: height,
    );
    final processedBottomLeft = topLeft == bottomLeft
        ? processedTopLeft
        : ProcessedCornerRadius(
            bottomLeft,
            width: width,
            height: height,
          );
    final processedBottomRight = bottomLeft == bottomRight
        ? processedBottomLeft
        : ProcessedCornerRadius(
            bottomRight,
            width: width,
            height: height,
          );
    final processedTopRight = topRight == bottomRight
        ? processedBottomRight
        : ProcessedCornerRadius(
            topRight,
            width: width,
            height: height,
          );

    result
      ..addCorner(Corner.topRight, processedTopRight, rect)
      ..addCorner(Corner.bottomRight, processedBottomRight, rect)
      ..addCorner(Corner.bottomLeft, processedBottomLeft, rect)
      ..addCorner(Corner.topLeft, processedTopLeft, rect);

    return result.transform(
      Matrix4.translationValues(rect.left, rect.top, 0).storage,
    );
  }

  /// Subtracts another [BorderRadiusGeometry] from this one.
  @override
  BorderRadiusGeometry subtract(BorderRadiusGeometry other) {
    if (other is CornerBorderRadius) {
      return this - other;
    }
    return super.subtract(other);
  }

  /// Adds another [BorderRadiusGeometry] to this one.
  @override
  BorderRadiusGeometry add(BorderRadiusGeometry other) {
    if (other is CornerBorderRadius) {
      return this + other;
    }
    return super.add(other);
  }

  /// Subtracts another [CornerBorderRadius] from this one.
  @override
  CornerBorderRadius operator -(BorderRadius other) {
    if (other is CornerBorderRadius) {
      return CornerBorderRadius.only(
        topLeft: (topLeft - other.topLeft),
        topRight: (topRight - other.topRight),
        bottomLeft: (bottomLeft - other.bottomLeft),
        bottomRight: (bottomRight - other.bottomRight),
      );
    }

    return this;
  }

  /// Adds another [CornerBorderRadius] to this one.
  @override
  CornerBorderRadius operator +(BorderRadius other) {
    if (other is CornerBorderRadius) {
      return CornerBorderRadius.only(
        topLeft: (topLeft + other.topLeft),
        topRight: (topRight + other.topRight),
        bottomLeft: (bottomLeft + other.bottomLeft),
        bottomRight: (bottomRight + other.bottomRight),
      );
    }
    return this;
  }

  /// Negates the [CornerBorderRadius].
  @override
  CornerBorderRadius operator -() {
    return CornerBorderRadius.only(
      topLeft: (-topLeft),
      topRight: (-topRight),
      bottomLeft: (-bottomLeft),
      bottomRight: (-bottomRight),
    );
  }

  /// Multiplies the [CornerBorderRadius] by a scalar.
  @override
  CornerBorderRadius operator *(double other) {
    return CornerBorderRadius.only(
      topLeft: topLeft * other,
      topRight: topRight * other,
      bottomLeft: bottomLeft * other,
      bottomRight: bottomRight * other,
    );
  }

  /// Divides the [CornerBorderRadius] by a scalar.
  @override
  CornerBorderRadius operator /(double other) {
    return CornerBorderRadius.only(
      topLeft: topLeft / other,
      topRight: topRight / other,
      bottomLeft: bottomLeft / other,
      bottomRight: bottomRight / other,
    );
  }

  /// Integer divides the [CornerBorderRadius] by a scalar.
  @override
  CornerBorderRadius operator ~/(double other) {
    return CornerBorderRadius.only(
      topLeft: topLeft ~/ other,
      topRight: topRight ~/ other,
      bottomLeft: bottomLeft ~/ other,
      bottomRight: bottomRight ~/ other,
    );
  }

  /// Modulo operation on the [CornerBorderRadius] by a scalar.
  @override
  CornerBorderRadius operator %(double other) {
    return CornerBorderRadius.only(
      topLeft: topLeft % other,
      topRight: topRight % other,
      bottomLeft: bottomLeft % other,
      bottomRight: bottomRight % other,
    );
  }

  /// Linearly interpolates between two [CornerBorderRadius] objects.
  static CornerBorderRadius? lerp(
    CornerBorderRadius? a,
    CornerBorderRadius? b,
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
    return CornerBorderRadius.only(
      topLeft: CornerRadius.lerp(a.topLeft, b.topLeft, clampedT)!,
      topRight: CornerRadius.lerp(a.topRight, b.topRight, clampedT)!,
      bottomLeft: CornerRadius.lerp(a.bottomLeft, b.bottomLeft, clampedT)!,
      bottomRight: CornerRadius.lerp(a.bottomRight, b.bottomRight, clampedT)!,
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
      return 'CornerBorderRadius(topLeft: $radius, topRight: $radius, bottomLeft: $radius, bottomRight: $radius)';
    }

    return 'CornerBorderRadius('
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
