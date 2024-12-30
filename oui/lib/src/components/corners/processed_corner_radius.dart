import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector;

import 'corner_radius.dart';

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

    final maxRadius = math.min(width, height) / 2;
    cornerRadius = math.min(cornerRadius, maxRadius);

    final totalLength =
        math.min((1 + cornerSmoothing) * cornerRadius, maxRadius);

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

    final tanAngleThetaRadians = math.tan(angleThetaRadians);
    final sinAngleBetaRadians = math.sin(angleBetaRadians);
    final cosAngleAlphaRadians = math.cos(angleAlphaRadians);
    final tanAngleAlphaRadians = math.tan(angleAlphaRadians);
    final sqrt2 = math.sqrt(2);

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
