import 'dart:ui';
import 'dart:math' as math;

import 'processed_corner_radius.dart';

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
          moveTo(math.max(width / 2, width - totalLength), 0);
          cubicTo(
            width - (totalLength - segmentA),
            0,
            width - (totalLength - segmentA - segmentB),
            0,
            width - (totalLength - segmentA - segmentB - segmentC),
            segmentD,
          );
          relativeArcToPoint(
            Offset(circularSectionLength, circularSectionLength),
            radius: radius.radius,
          );
          cubicTo(
            width,
            totalLength - segmentA - segmentB,
            width,
            totalLength - segmentA,
            width,
            math.min(height / 2, totalLength),
          );
        } else {
          moveTo(width / 2, 0);
          lineTo(width, 0);
          lineTo(width, height / 2);
        }
        break;

      case Corner.bottomRight:
        if (cornerRadius > 0) {
          lineTo(width, math.max(height / 2, height - totalLength));
          cubicTo(
            width,
            height - (totalLength - segmentA),
            width,
            height - (totalLength - segmentA - segmentB),
            width - segmentD,
            height - (totalLength - segmentA - segmentB - segmentC),
          );
          relativeArcToPoint(
            Offset(-circularSectionLength, circularSectionLength),
            radius: radius.radius,
          );
          cubicTo(
            width - (totalLength - segmentA - segmentB),
            height,
            width - (totalLength - segmentA),
            height,
            math.max(width / 2, width - totalLength),
            height,
          );
        } else {
          lineTo(width, height);
          lineTo(width / 2, height);
        }
        break;

      case Corner.bottomLeft:
        if (cornerRadius > 0) {
          lineTo(math.min(width / 2, totalLength), height);
          cubicTo(
            totalLength - segmentA,
            height,
            totalLength - segmentA - segmentB,
            height,
            totalLength - segmentA - segmentB - segmentC,
            height - segmentD,
          );
          relativeArcToPoint(
            Offset(-circularSectionLength, -circularSectionLength),
            radius: radius.radius,
          );
          cubicTo(
            0,
            height - (totalLength - segmentA - segmentB),
            0,
            height - (totalLength - segmentA),
            0,
            math.max(height / 2, height - totalLength),
          );
        } else {
          lineTo(0, height);
          lineTo(0, height / 2);
        }
        break;

      case Corner.topLeft:
        if (cornerRadius > 0) {
          lineTo(0, math.min(height / 2, totalLength));
          cubicTo(
            0,
            totalLength - segmentA,
            0,
            totalLength - segmentA - segmentB,
            segmentD,
            totalLength - segmentA - segmentB - segmentC,
          );
          relativeArcToPoint(
            Offset(circularSectionLength, -circularSectionLength),
            radius: radius.radius,
          );
          cubicTo(
            totalLength - segmentA - segmentB,
            0,
            totalLength - segmentA,
            0,
            math.min(width / 2, totalLength),
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
