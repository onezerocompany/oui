import 'dart:ui';

import 'package:flutter/rendering.dart'
    show
        BorderRadius,
        BorderRadiusGeometry,
        BoxDecoration,
        Matrix4,
        Path,
        Rect,
        TextDirection;

import 'corner_path.dart';
import 'corner_radius.dart';
import 'processed_corner_radius.dart';

/// A class that defines the border radius with custom corner radii and smoothing.
class CornerBorderRadius extends BorderRadius {
  const CornerBorderRadius.only({
    CornerRadius topLeft = CornerRadius.zero,
    CornerRadius topRight = CornerRadius.zero,
    CornerRadius bottomLeft = CornerRadius.zero,
    CornerRadius bottomRight = CornerRadius.zero,
  })  : _topLeft = topLeft,
        _topRight = topRight,
        _bottomLeft = bottomLeft,
        _bottomRight = bottomRight,
        super.only();

  const CornerBorderRadius.all(CornerRadius super.radius)
      : _topLeft = radius,
        _topRight = radius,
        _bottomLeft = radius,
        _bottomRight = radius,
        super.all();

  const CornerBorderRadius.vertical(
    CornerRadius top,
    CornerRadius bottom,
  )   : _topLeft = top,
        _topRight = top,
        _bottomLeft = bottom,
        _bottomRight = bottom,
        super.vertical();

  const CornerBorderRadius.horizontal(
    CornerRadius left,
    CornerRadius right,
  )   : _topLeft = left,
        _topRight = right,
        _bottomLeft = left,
        _bottomRight = right,
        super.horizontal();

  @override
  Radius get topLeft => _topLeft;
  final CornerRadius _topLeft;

  @override
  Radius get topRight => _topRight;
  final CornerRadius _topRight;

  @override
  Radius get bottomLeft => _bottomLeft;
  final CornerRadius _bottomLeft;

  @override
  Radius get bottomRight => _bottomRight;
  final CornerRadius _bottomRight;

  /// A border radius with all corners set to zero.
  static const CornerBorderRadius zero =
      CornerBorderRadius.all(CornerRadius.zero);

  /// Converts the border radius to a [Path] for the given [Rect].
  Path toPath(Rect rect) {
    final width = rect.width;
    final height = rect.height;

    final result = Path();

    final processedTopLeft = ProcessedCornerRadius(
      _topLeft,
      width: width,
      height: height,
    );
    final processedBottomLeft = _topLeft == _bottomLeft
        ? processedTopLeft
        : ProcessedCornerRadius(
            _bottomLeft,
            width: width,
            height: height,
          );
    final processedBottomRight = _bottomLeft == _bottomRight
        ? processedBottomLeft
        : ProcessedCornerRadius(
            _bottomRight,
            width: width,
            height: height,
          );
    final processedTopRight = _topRight == _bottomRight
        ? processedBottomRight
        : ProcessedCornerRadius(
            _topRight,
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
        topLeft: (_topLeft - other._topLeft),
        topRight: (_topRight - other._topRight),
        bottomLeft: (_bottomLeft - other._bottomLeft),
        bottomRight: (_bottomRight - other._bottomRight),
      );
    }

    return this;
  }

  /// Adds another [CornerBorderRadius] to this one.
  @override
  CornerBorderRadius operator +(BorderRadius other) {
    if (other is CornerBorderRadius) {
      return CornerBorderRadius.only(
        topLeft: (_topLeft + other._topLeft),
        topRight: (_topRight + other._topRight),
        bottomLeft: (_bottomLeft + other._bottomLeft),
        bottomRight: (_bottomRight + other._bottomRight),
      );
    }
    return this;
  }

  /// Negates the [CornerBorderRadius].
  @override
  CornerBorderRadius operator -() {
    return CornerBorderRadius.only(
      topLeft: (-_topLeft),
      topRight: (-_topRight),
      bottomLeft: (-_bottomLeft),
      bottomRight: (-_bottomRight),
    );
  }

  /// Multiplies the [CornerBorderRadius] by a scalar.
  @override
  CornerBorderRadius operator *(double other) {
    return CornerBorderRadius.only(
      topLeft: _topLeft * other,
      topRight: _topRight * other,
      bottomLeft: _bottomLeft * other,
      bottomRight: _bottomRight * other,
    );
  }

  /// Divides the [CornerBorderRadius] by a scalar.
  @override
  CornerBorderRadius operator /(double other) {
    return CornerBorderRadius.only(
      topLeft: _topLeft / other,
      topRight: _topRight / other,
      bottomLeft: _bottomLeft / other,
      bottomRight: _bottomRight / other,
    );
  }

  /// Integer divides the [CornerBorderRadius] by a scalar.
  @override
  CornerBorderRadius operator ~/(double other) {
    return CornerBorderRadius.only(
      topLeft: _topLeft ~/ other,
      topRight: _topRight ~/ other,
      bottomLeft: _bottomLeft ~/ other,
      bottomRight: _bottomRight ~/ other,
    );
  }

  /// Modulo operation on the [CornerBorderRadius] by a scalar.
  @override
  CornerBorderRadius operator %(double other) {
    return CornerBorderRadius.only(
      topLeft: _topLeft % other,
      topRight: _topRight % other,
      bottomLeft: _bottomLeft % other,
      bottomRight: _bottomRight % other,
    );
  }

  /// Linearly interpolates between two [CornerBorderRadius] objects.
  static CornerBorderRadius _lerp(
    CornerBorderRadius a,
    CornerBorderRadius b,
    double t,
  ) {
    final clampedT = t.clamp(0.0, 1.0);
    return CornerBorderRadius.only(
      topLeft: CornerRadius.lerp(a._topLeft, b._topLeft, clampedT)!,
      topRight: CornerRadius.lerp(a._topRight, b._topRight, clampedT)!,
      bottomLeft: CornerRadius.lerp(a._bottomLeft, b._bottomLeft, clampedT)!,
      bottomRight: CornerRadius.lerp(a._bottomRight, b._bottomRight, clampedT)!,
    );
  }

  /// Linearly interpolates to another [BorderRadiusGeometry] from this one.
  CornerBorderRadius lerpTo(BorderRadiusGeometry b, double t) {
    if (b is CornerBorderRadius) {
      return CornerBorderRadius._lerp(this, b, t);
    }
    return BorderRadiusGeometry.lerp(this, b, t) as CornerBorderRadius;
  }

  /// Linearly interpolates from another [BorderRadiusGeometry] to this one.
  CornerBorderRadius lerpFrom(BorderRadiusGeometry a, double t) {
    if (a is CornerBorderRadius) {
      return CornerBorderRadius._lerp(a, this, t);
    }
    return BorderRadiusGeometry.lerp(a, this, t) as CornerBorderRadius;
  }

  /// Checks if the smoothing is default (0.0) for all corners.
  bool get isDefaultSmoothing {
    return [
      _bottomLeft,
      _bottomRight,
      _topLeft,
      _topRight,
    ].every((x) => x.smoothing == 0.0);
  }

  bool get hasNoRadius {
    return [
      _bottomLeft,
      _bottomRight,
      _topLeft,
      _topRight,
    ].every((x) => x.cornerRadius == 0.0);
  }

  bool get shouldRender => !hasNoRadius;

  /// Resolves the border radius for the given text direction.
  @override
  BorderRadius resolve(TextDirection? direction) => BorderRadius.only(
        topLeft: _topLeft,
        topRight: _topRight,
        bottomLeft: _bottomLeft,
        bottomRight: _bottomRight,
      );

  /// Returns a string representation of the border radius.
  @override
  String toString() {
    if (_topLeft == _topRight &&
        _topLeft == _bottomRight &&
        _topLeft == _bottomLeft) {
      final radius = _topLeft.toString();
      return 'CornerBorderRadius(topLeft: $radius, topRight: $radius, bottomLeft: $radius, bottomRight: $radius)';
    }

    return 'CornerBorderRadius('
        'topLeft: $_topLeft,'
        'topRight: $_topRight,'
        'bottomLeft: $_bottomLeft,'
        'bottomRight: $_bottomRight,'
        ')';
  }

  BoxDecoration apply(BoxDecoration decoration) {
    if (!shouldRender) {
      return decoration;
    }
    return decoration.copyWith(borderRadius: this);
  }
}
