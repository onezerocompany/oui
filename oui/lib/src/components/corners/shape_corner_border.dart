import 'package:flutter/material.dart';
import 'package:oui/src/components/corners/corner_border_radius.dart';

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
