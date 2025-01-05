import 'package:flutter/painting.dart';
import 'package:oui/src/components/modifiable/modifiable.dart';
import 'package:oui/src/components/modifiable/modifier.dart';

import '../../../core/colors/color.dart';
import '../../../core/geometry/offset.dart';

/// A class representing a shadow effect that can be applied to a widget.
class ShadowModifier extends Modifier with DecorationModifier {
  /// The blur radius of the shadow.
  final double radius;

  /// The spread radius of the shadow.
  final double spread;

  /// The color of the shadow.
  final Color? color;

  /// The offset of the shadow.
  final Offset offset;

  /// Creates a new [ShadowModifier] instance with the given properties.
  ///
  /// All parameters are required.
  const ShadowModifier({
    required this.radius,
    required this.spread,
    required this.color,
    required this.offset,
  });

  /// A constant shadow with no effect.
  static const ShadowModifier none = ShadowModifier(
    radius: 0,
    spread: 0,
    color: Color.clear,
    offset: Offset.zero,
  );

  /// Determines whether the shadow should be rendered.
  ///
  /// Returns `true` if the shadow should be rendered, otherwise `false`.
  bool get shouldRender {
    if (color?.isVisible != true) {
      return false;
    }

    if (radius == 0 && spread == 0 && offset == Offset.zero) {
      return false;
    }

    return true;
  }

  /// Converts this [ShadowModifier] to a [BoxShadow] object.
  ///
  /// Returns a [BoxShadow] with the same properties as this [ShadowModifier].
  BoxShadow get boxShadow {
    return BoxShadow(
      blurRadius: radius,
      spreadRadius: spread,
      color: color?.uiColor ?? Color.black.uiColor,
      offset: offset.uiOffset,
    );
  }

  @override
  Decoration? decorate(
    Decoration decoration,
    ModifierContext context,
  ) {
    if (!shouldRender) return null;

    if (decoration is BoxDecoration) {
      return decoration.copyWith(
        boxShadow: [
          boxShadow,
          ...?decoration.boxShadow,
        ],
      );
    }

    if (decoration is ShapeDecoration) {
      return ShapeDecoration(
        shape: decoration.shape,
        color: decoration.color,
        image: decoration.image,
        gradient: decoration.gradient,
        shadows: [
          boxShadow,
          ...?decoration.shadows,
        ],
      );
    }
    return null;
  }
}

mixin ModifiableShadow<Component extends Modifiable> on Modifiable<Component> {
  /// Adds a shadow effect to the widget.
  ///
  /// [radius] - The blur radius of the shadow.
  /// [spread] - The spread radius of the shadow.
  /// [color] - The color of the shadow.
  /// [offset] - The offset of the shadow.
  Component shadow({
    double radius = 0,
    double spread = 0,
    Color? color,
    Offset offset = Offset.zero,
  }) {
    return withModifier(
      ShadowModifier(
        radius: radius,
        spread: spread,
        color: color,
        offset: offset,
      ),
    );
  }
}
