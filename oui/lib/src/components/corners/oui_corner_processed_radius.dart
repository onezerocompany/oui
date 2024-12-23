import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector;
import 'oui_corner_radius.dart';

class ProcessedOuiCornerRadius {
  /// Constructs a [ProcessedOuiCornerRadius] with pre-computed segments and lengths.
  ///
  /// Example:
  /// ```dart
  /// final radius = OuiCornerRadius(radius: 10, smoothing: 0.5);
  /// final processedRadius = ProcessedOuiCornerRadius(radius, width: 100, height: 100);
  /// ```
  ///
  /// Parameters:
  /// - [radius]: The [OuiCornerRadius] object containing the radius and smoothing values.
  /// - [width]: The width of the component.
  /// - [height]: The height of the component.
  const ProcessedOuiCornerRadius._({
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
  factory ProcessedOuiCornerRadius(
    OuiCornerRadius radius, {
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

    return ProcessedOuiCornerRadius._(
      segmentA: segmentA,
      segmentB: segmentB,
      segmentC: segmentC,
      segmentD: segmentD,
      totalLength: totalLength,
      width: width,
      height: height,
      radius: OuiCornerRadius(
        radius: cornerRadius,
        smoothing: radius.smoothing,
      ),
      circularSectionLength: circularSectionLength,
    );
  }

  final OuiCornerRadius radius;
  final double segmentA;
  final double segmentB;
  final double segmentC;
  final double segmentD;
  final double totalLength;
  final double circularSectionLength;
  final double width;
  final double height;

  double get cornerRadius => radius.cornerRadius;

  /// Compares this corner radius with another, prioritizing logical equivalence.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    if (other is OuiCornerRadius) return other == radius;
    if (other is ProcessedOuiCornerRadius) return other.radius == radius;
    return false;
  }

  @override
  int get hashCode => radius.hashCode;

  @override
  String toString() {
    return 'ProcessedOuiCornerRadius(radius: $radius, segmentA: ${segmentA.toStringAsFixed(2)}, segmentB: ${segmentB.toStringAsFixed(2)}, segmentC: ${segmentC.toStringAsFixed(2)}, segmentD: ${segmentD.toStringAsFixed(2)}, totalLength: ${totalLength.toStringAsFixed(2)}, circularSectionLength: ${circularSectionLength.toStringAsFixed(2)}, width: ${width.toStringAsFixed(2)}, height: ${height.toStringAsFixed(2)})';
  }
}
