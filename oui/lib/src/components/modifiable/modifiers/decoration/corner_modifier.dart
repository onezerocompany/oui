import 'dart:ui';

import 'package:flutter/painting.dart'
    show BoxDecoration, Decoration, ShapeDecoration;
import 'package:flutter/widgets.dart' show BoxDecoration, Widget;
import 'package:oui/oui.dart';

class CornerModifier extends Modifier with DecorationModifier, ChildModifier {
  final CornerBorder corner;
  final bool clip;

  const CornerModifier(
    this.corner, {
    this.clip = false,
  });

  @override
  Decoration? decorate(
    Decoration decoration,
    ModifierContext context,
  ) {
    if (!corner.shouldRender) {
      return null;
    }

    final shape = corner.copyWith(
      radius: corner.borderRadius,
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
  Widget? modify(Widget child, ModifierContext context) {
    if (!corner.shouldRender || !clip) return null;

    return ClipCornerRect(
      radius: corner.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

mixin ModifiableCorner<Component extends Modifiable> on Modifiable<Component> {
  Component corner(CornerBorder corner) {
    return withModifier(
      CornerModifier(corner),
    );
  }

  Component allCorners(
    double radius, {
    double smoothing = 0.7,
  }) {
    return withModifier(
      CornerModifier(
        CornerBorder(
          borderRadius: CornerBorderRadius.all(
            CornerRadius(
              radius: radius,
              smoothing: smoothing,
            ),
          ),
        ),
      ),
      unique: true,
    );
  }
}
