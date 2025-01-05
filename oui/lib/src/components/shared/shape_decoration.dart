import 'package:flutter/painting.dart'
    show
        BoxShadow,
        Color,
        DecorationImage,
        Gradient,
        ShapeBorder,
        ShapeDecoration;

extension OuiShapeDecoration on ShapeDecoration {
  ShapeDecoration copyWith({
    ShapeBorder? shape,
    List<BoxShadow>? shadows,
    Gradient? gradient,
    Color? color,
    DecorationImage? image,
  }) {
    return ShapeDecoration(
      shape: shape ?? this.shape,
      shadows: shadows ?? this.shadows,
      gradient: gradient ?? this.gradient,
      color: color ?? this.color,
      image: image ?? this.image,
    );
  }
}
