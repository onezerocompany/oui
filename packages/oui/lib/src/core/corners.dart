import 'dart:math';

import 'package:flutter/painting.dart' as painting show BorderSide, Offset;
import 'package:flutter/widgets.dart'
    show
        BorderRadius,
        BorderRadiusGeometry,
        BorderStyle,
        BoxDecoration,
        BuildContext,
        Canvas,
        Clip,
        ClipPath,
        Decoration,
        EdgeInsets,
        EdgeInsetsGeometry,
        OutlinedBorder,
        Path,
        Radius,
        Rect,
        ShapeBorder,
        ShapeDecoration,
        StatelessWidget,
        TextDirection,
        Widget;
import 'package:oui/src/components/box.dart' show DecorationModifier;
import 'package:oui/src/core/interpolation.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'border.dart';
import 'component.dart';
import 'utils.dart';

/// A widget that clips its child using a custom corner border shape.
class ClipCornerRect extends StatelessWidget {
  /// Creates a widget that clips its child using a custom corner border shape.
  ///
  /// The [child] parameter must not be null.
  /// The [radius] parameter defaults to [CornerBorderRadius.zero].
  /// The [clipBehavior] parameter defaults to [Clip.antiAlias].
  const ClipCornerRect({
    super.key,
    this.child,
    this.radius = CornerBorderRadius.zero,
    this.clipBehavior = Clip.antiAlias,
  });

  /// The radius of the corners.
  ///
  /// Defaults to [CornerBorderRadius.zero].
  final CornerBorderRadius radius;

  /// The clip behavior to use when clipping.
  ///
  /// Defaults to [Clip.antiAlias].
  final Clip clipBehavior;

  /// The widget below this widget in the tree.
  ///
  /// This widget can be null.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath.shape(
      clipBehavior: clipBehavior,
      shape: CornerBorder(
        borderRadius: radius,
      ),
      child: child,
    );
  }
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
    BorderSide side = BorderSide.none,
    this.borderRadius = CornerBorderRadius.zero,
    this.borderAlign = BorderAlign.inside,
  }) : _side = side;

  final BorderSide _side;
  @override
  painting.BorderSide get side => _side.uiBorderSide;

  static const zero = CornerBorder(
    side: BorderSide.none,
    borderRadius: CornerBorderRadius.zero,
    borderAlign: BorderAlign.inside,
  );

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

  bool get shouldRender => borderRadius.shouldRender;

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
      side: _side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

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
  OutlinedBorder copyWith({
    painting.BorderSide? side,
    BorderAlign? align,
    CornerBorderRadius? radius,
  }) {
    return CornerBorder(
      side: side?.ouiBorderSide ?? _side,
      borderRadius: radius ?? borderRadius,
      borderAlign: align ?? borderAlign,
    );
  }

  @override
  int get hashCode => Object.hash(side, borderRadius, borderAlign);

  @override
  String toString() {
    return 'CornerBorder(side: $side, borderRadius: $borderRadius, borderAlign: $borderAlign)';
  }
}

/// An enumeration representing the four corners of a rectangle or square.
enum Corner { topLeft, topRight, bottomRight, bottomLeft }

extension CornerExtensions on Path {
  /// Adds a corner with a specific radius to the path.
  ///
  /// This method modifies the path to include a corner with the given radius at the specified corner of the rectangle.
  ///
  /// - [corner]: The corner of the rectangle where the radius should be applied.
  /// - [radius]: The processed radius information for the corner.
  /// - [rect]: The rectangle to which the corner belongs.
  void addCorner(
    Corner corner,
    ProcessedCornerRadius radius,
    Rect rect,
  ) {
    final width = rect.width;
    final height = rect.height;
    final cornerRadius = radius.radius.cornerRadius;
    final segmentA = radius.segmentA;
    final segmentB = radius.segmentB;
    final segmentC = radius.segmentC;
    final segmentD = radius.segmentD;
    final totalLength = radius.totalLength;
    final circularSectionLength = radius.circularSectionLength;

    switch (corner) {
      case Corner.topRight:
        if (cornerRadius > 0) {
          moveTo(max(width / 2, width - totalLength), 0);
          cubicTo(
            width - (totalLength - segmentA),
            0,
            width - (totalLength - segmentA - segmentB),
            0,
            width - (totalLength - segmentA - segmentB - segmentC),
            segmentD,
          );
          relativeArcToPoint(
            painting.Offset(circularSectionLength, circularSectionLength),
            radius: radius.radius,
          );
          cubicTo(
            width,
            totalLength - segmentA - segmentB,
            width,
            totalLength - segmentA,
            width,
            min(height / 2, totalLength),
          );
        } else {
          moveTo(width / 2, 0);
          lineTo(width, 0);
          lineTo(width, height / 2);
        }
        break;

      case Corner.bottomRight:
        if (cornerRadius > 0) {
          lineTo(width, max(height / 2, height - totalLength));
          cubicTo(
            width,
            height - (totalLength - segmentA),
            width,
            height - (totalLength - segmentA - segmentB),
            width - segmentD,
            height - (totalLength - segmentA - segmentB - segmentC),
          );
          relativeArcToPoint(
            painting.Offset(-circularSectionLength, circularSectionLength),
            radius: radius.radius,
          );
          cubicTo(
            width - (totalLength - segmentA - segmentB),
            height,
            width - (totalLength - segmentA),
            height,
            max(width / 2, width - totalLength),
            height,
          );
        } else {
          lineTo(width, height);
          lineTo(width / 2, height);
        }
        break;

      case Corner.bottomLeft:
        if (cornerRadius > 0) {
          lineTo(min(width / 2, totalLength), height);
          cubicTo(
            totalLength - segmentA,
            height,
            totalLength - segmentA - segmentB,
            height,
            totalLength - segmentA - segmentB - segmentC,
            height - segmentD,
          );
          relativeArcToPoint(
            painting.Offset(-circularSectionLength, -circularSectionLength),
            radius: radius.radius,
          );
          cubicTo(
            0,
            height - (totalLength - segmentA - segmentB),
            0,
            height - (totalLength - segmentA),
            0,
            max(height / 2, height - totalLength),
          );
        } else {
          lineTo(0, height);
          lineTo(0, height / 2);
        }
        break;

      case Corner.topLeft:
        if (cornerRadius > 0) {
          lineTo(0, min(height / 2, totalLength));
          cubicTo(
            0,
            totalLength - segmentA,
            0,
            totalLength - segmentA - segmentB,
            segmentD,
            totalLength - segmentA - segmentB - segmentC,
          );
          relativeArcToPoint(
            painting.Offset(circularSectionLength, -circularSectionLength),
            radius: radius.radius,
          );
          cubicTo(
            totalLength - segmentA - segmentB,
            0,
            totalLength - segmentA,
            0,
            min(width / 2, totalLength),
            0,
          );
          close();
        } else {
          lineTo(0, 0);
          close();
        }
        break;
    }
  }
}

/// A class representing a corner radius with additional smoothing property.
class CornerRadius extends Radius with Interpolable<CornerRadius> {
  /// Creates a [CornerRadius] with the given [radius] and [smoothing].
  const CornerRadius({
    required double radius,
    this.smoothing = 0,
  })  : assert(radius >= 0, 'Radius must be non-negative'),
        assert(smoothing >= 0, 'Smoothing must be non-negative'),
        assert(smoothing <= 1, 'Smoothing must be between 0 and 1'),
        super.circular(radius);

  /// The smoothing factor for the corner radius.
  ///
  /// The value should be between 0.0 and 1.0, where 0.0 represents no smoothing
  /// (a sharp corner) and 1.0 represents maximum smoothing (a fully rounded corner).
  final double smoothing;

  /// Gets the corner radius value.
  double get cornerRadius => x;

  /// A constant [CornerRadius] with zero radius and smoothing.
  static const zero = CornerRadius(
    radius: 0,
    smoothing: 0,
  );

  /// Negates the corner radius value.
  @override
  CornerRadius operator -() => CornerRadius(
        radius: -cornerRadius,
        smoothing: smoothing,
      );

  /// Subtracts another [Radius] from this [CornerRadius].
  @override
  CornerRadius operator -(Radius other) {
    if (other is CornerRadius) {
      return CornerRadius(
        radius: cornerRadius - other.cornerRadius,
        smoothing: (smoothing + other.smoothing) / 2,
      );
    }
    return CornerRadius(
      radius: cornerRadius - other.x,
      smoothing: smoothing,
    );
  }

  /// Adds another [Radius] to this [CornerRadius].
  @override
  CornerRadius operator +(Radius other) {
    if (other is CornerRadius) {
      return CornerRadius(
        radius: cornerRadius + other.cornerRadius,
        smoothing: (smoothing + other.smoothing) / 2,
      );
    }
    return CornerRadius(
      radius: cornerRadius + other.x,
      smoothing: smoothing,
    );
  }

  /// Multiplies the corner radius and smoothing by a scalar [operand].
  @override
  CornerRadius operator *(double operand) {
    assert(operand >= 0, 'Operand must be non-negative');
    return CornerRadius(
      radius: cornerRadius * operand,
      smoothing: smoothing * operand,
    );
  }

  /// Divides the corner radius and smoothing by a scalar [operand].
  @override
  CornerRadius operator /(double operand) {
    assert(operand != 0, 'Operand must not be zero');
    return CornerRadius(
      radius: cornerRadius / operand,
      smoothing: smoothing / operand,
    );
  }

  /// Integer divides the corner radius and smoothing by a scalar [operand].
  @override
  CornerRadius operator ~/(double operand) {
    assert(operand != 0, 'Operand must not be zero');
    return CornerRadius(
      radius: (cornerRadius ~/ operand).toDouble(),
      smoothing: (smoothing ~/ operand).toDouble(),
    );
  }

  /// Computes the remainder of the corner radius and smoothing divided by a scalar [operand].
  @override
  CornerRadius operator %(double operand) {
    assert(operand != 0, 'Operand must not be zero');
    return CornerRadius(
      radius: cornerRadius % operand,
      smoothing: smoothing % operand,
    );
  }

  /// Compares this instance with another object for equality.
  ///
  /// Returns `true` if the other object is identical to this instance,
  /// or if the other object is of the same runtime type and has the same
  /// `cornerRadius` and `smoothing` values.
  ///
  /// - Parameter other: The object to compare with this instance.
  /// - Returns: `true` if the objects are equal, `false` otherwise.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (runtimeType != other.runtimeType) {
      return false;
    }

    return other is CornerRadius &&
        other.cornerRadius == cornerRadius &&
        other.smoothing == smoothing;
  }

  @override
  int get hashCode => Object.hash(cornerRadius, smoothing);

  @override
  String toString() {
    return 'CornerRadius(cornerRadius: ${cornerRadius.toStringAsFixed(2)}, smoothing: ${smoothing.toStringAsFixed(2)})';
  }

  @override
  CornerRadius lerp(CornerRadius a, CornerRadius b, double t) {
    return CornerRadius(
      radius:
          const DoubleInterpolator().resolve(a.cornerRadius, b.cornerRadius, t),
      smoothing:
          const DoubleInterpolator().resolve(a.smoothing, b.smoothing, t),
    );
  }
}

class ProcessedCornerRadius {
  /// Constructs a [ProcessedCornerRadius] with pre-computed segments and lengths.
  ///
  /// Example:
  /// ```dart
  /// final radius = CornerRadius(radius: 10, smoothing: 0.5);
  /// final processedRadius = ProcessedCornerRadius(radius, width: 100, height: 100);
  /// ```
  ///
  /// Parameters:
  /// - [radius]: The [CornerRadius] object containing the radius and smoothing values.
  /// - [width]: The width of the component.
  /// - [height]: The height of the component.
  const ProcessedCornerRadius._({
    required this.segmentA,
    required this.segmentB,
    required this.segmentC,
    required this.segmentD,
    required this.totalLength,
    required this.width,
    required this.height,
    required this.radius,
    required this.circularSectionLength,
  });

  /// Creates a processed corner radius while computing trigonometric values.
  /// - α (angleAlpha) is derived from smoothing to shape the corner curvature.
  /// - β (angleBeta) adjusts curvature based on how close `cornerRadius` is to half the smaller dimension.
  /// - We use trigonometric identities (e.g. tan(θ/2), sin(β/2)) to split the corner into straight segments and a circular arc.
  /// - `totalLength` is bounded by the largest valid radius, ensuring we respect layout constraints.
  factory ProcessedCornerRadius(
    CornerRadius radius, {
    required double width,
    required double height,
  }) {
    assert(width > 0, 'Width must be greater than zero');
    assert(height > 0, 'Height must be greater than zero');

    final cornerSmoothing = radius.smoothing;
    var cornerRadius = radius.cornerRadius;

    final maxRadius = min(width, height) / 2;
    cornerRadius = min(cornerRadius, maxRadius);

    final totalLength = min((1 + cornerSmoothing) * cornerRadius, maxRadius);

    // Explanation: angleBeta is 90° minus a fraction of smoothing (and adjustments),
    // while angleAlpha is a portion of 45° times smoothing. This ensures consistent corner shape at any radius.
    final double angleAlpha, angleBeta;

    if (cornerRadius <= maxRadius / 2) {
      angleBeta = 90 * (1 - cornerSmoothing);
      angleAlpha = 45 * cornerSmoothing;
    } else {
      final diffRatio = (cornerRadius - maxRadius / 2) / (maxRadius / 2);
      angleBeta = 90 * (1 - cornerSmoothing * (1 - diffRatio));
      angleAlpha = 45 * cornerSmoothing * (1 - diffRatio);
    }

    final angleTheta = (90 - angleBeta) / 2;
    final angleThetaRadians = vector.radians(angleTheta / 2);
    final angleAlphaRadians = vector.radians(angleAlpha);
    final angleBetaRadians = vector.radians(angleBeta / 2);

    final tanAngleThetaRadians = tan(angleThetaRadians);
    final sinAngleBetaRadians = sin(angleBetaRadians);
    final cosAngleAlphaRadians = cos(angleAlphaRadians);
    final tanAngleAlphaRadians = tan(angleAlphaRadians);
    final sqrt2 = sqrt(2);

    final distanceP3ToP4 = cornerRadius * tanAngleThetaRadians;
    final circularSectionLength = sinAngleBetaRadians * cornerRadius * sqrt2;

    final segmentC = distanceP3ToP4 * cosAngleAlphaRadians;
    final segmentD = segmentC * tanAngleAlphaRadians;
    final segmentB =
        (totalLength - circularSectionLength - segmentC - segmentD) / 3;
    final segmentA = 2 * segmentB;

    return ProcessedCornerRadius._(
      segmentA: segmentA,
      segmentB: segmentB,
      segmentC: segmentC,
      segmentD: segmentD,
      totalLength: totalLength,
      width: width,
      height: height,
      radius: CornerRadius(
        radius: cornerRadius,
        smoothing: radius.smoothing,
      ),
      circularSectionLength: circularSectionLength,
    );
  }

  final CornerRadius radius;
  final double segmentA;
  final double segmentB;
  final double segmentC;
  final double segmentD;
  final double totalLength;
  final double circularSectionLength;
  final double width;
  final double height;

  double get cornerRadius => radius.cornerRadius;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is ProcessedCornerRadius) {
      return other.radius == radius &&
          other.width == width &&
          other.height == height;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(radius, height, width);

  @override
  String toString() {
    return 'ProcessedCornerRadius(radius: $radius, segmentA: ${segmentA.toStringAsFixed(2)}, segmentB: ${segmentB.toStringAsFixed(2)}, segmentC: ${segmentC.toStringAsFixed(2)}, segmentD: ${segmentD.toStringAsFixed(2)}, totalLength: ${totalLength.toStringAsFixed(2)}, circularSectionLength: ${circularSectionLength.toStringAsFixed(2)}, width: ${width.toStringAsFixed(2)}, height: ${height.toStringAsFixed(2)})';
  }
}

class ShapeCornerBorder extends ShapeBorder {
  final CornerBorderRadius borderRadius;

  const ShapeCornerBorder({required this.borderRadius});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) {
    return ShapeCornerBorder(borderRadius: borderRadius * t);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final rrect = borderRadius.resolve(textDirection).toRRect(rect);
    // Add smoothing logic here if needed
    return Path()..addRRect(rrect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // Custom painting logic, if necessary
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }
}

/// A class that defines the border radius with custom corner radii and smoothing.
class CornerBorderRadius extends BorderRadius
    with Interpolable<CornerBorderRadius> {
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
      vector.Matrix4.translationValues(rect.left, rect.top, 0).storage,
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

  @override
  CornerBorderRadius lerp(
    CornerBorderRadius a,
    CornerBorderRadius b,
    double t,
  ) {
    return CornerBorderRadius.only(
      topLeft: a._topLeft.lerpTo(b._topLeft, t),
      topRight: a._topRight.lerpTo(b._topRight, t),
      bottomLeft: a._bottomLeft.lerpTo(b._bottomLeft, t),
      bottomRight: a._bottomRight.lerpTo(b._bottomRight, t),
    );
  }
}

class CornerModifier extends ComponentModifier
    with DecorationModifier, ContentModifier {
  final SizeLevel? roundness;
  final CornerBorder? corner;
  final bool clip;

  const CornerModifier({
    this.corner,
    this.roundness,
    this.clip = false,
    super.condition,
  });

  CornerBorderRadius borderRadius(ComponentContext context) {
    if (corner != null) return corner!.borderRadius;

    if (roundness != null) {
      final configRoundness = context.config.screens.roundness;
      const interpolator = DoubleInterpolator();

      final radius = interpolator.resolve(
        configRoundness.start,
        configRoundness.end,
        roundness!.t,
      );
      return CornerBorderRadius.all(
        CornerRadius(
          radius: radius,
          smoothing: 0.7,
        ),
      );
    }
    return CornerBorderRadius.zero;
  }

  @override
  Decoration? decorate(
    Decoration decoration,
    ComponentContext context,
  ) {
    final borderRadius = this.borderRadius(context);
    if (!borderRadius.shouldRender) return null;

    final shape = (corner ?? CornerBorder.zero).copyWith(
      radius: borderRadius,
    );

    if (decoration is ShapeDecoration) {
      return decoration.copyWith(
        shape: shape,
      );
    }

    if (decoration is BoxDecoration) {
      return ShapeDecoration(
        shape: shape,
        color: decoration.color,
        image: decoration.image,
        gradient: decoration.gradient,
        shadows: decoration.boxShadow,
      );
    }

    return null;
  }

  @override
  Widget? modify(Widget? child, ComponentContext context) {
    final borderRadius = this.borderRadius(context);
    if (!borderRadius.shouldRender || !clip || child == null) return null;

    return ClipCornerRect(
      radius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is CornerModifier) return other;
    return this;
  }
}

mixin ModifiableCorner<Type extends Component> on Component<Type> {
  Type corner(
    CornerBorder corner, {
    bool clip = false,
  }) {
    return withModifier(
      CornerModifier(corner: corner, clip: clip),
    );
  }

  Type allCorners(
    double radius, {
    double smoothing = 0.7,
    bool clip = false,
  }) {
    return withModifier(
      CornerModifier(
        corner: CornerBorder(
          borderRadius: CornerBorderRadius.all(
            CornerRadius(
              radius: radius,
              smoothing: smoothing,
            ),
          ),
        ),
        clip: clip,
      ),
    );
  }

  Type rounded(
    SizeLevel? roundness, {
    bool clip = false,
  }) {
    return withModifier(
      CornerModifier(
        roundness: roundness,
        clip: clip,
      ),
    );
  }
}
