import 'package:flutter/painting.dart' as painting show BoxShadow;
import 'package:flutter/widgets.dart'
    show BoxDecoration, BoxShadow, Decoration, ShapeDecoration;

import 'colors.dart';
import 'component.dart';
import 'geometry.dart';

/// A class representing a shadow effect.
class Shadow {
  /// The blur radius of the shadow.
  final double blur;

  /// The spread radius of the shadow.
  final double spread;

  /// The color of the shadow.
  final Color color;

  /// The offset of the shadow.
  final Offset offset;

  /// Creates a new [Shadow] instance with the given properties.
  ///
  /// All parameters are required.
  const Shadow({
    required this.blur,
    required this.spread,
    required this.color,
    required this.offset,
  });

  Shadow withColor(Color color) {
    return Shadow(
      blur: blur,
      spread: spread,
      color: color,
      offset: offset,
    );
  }

  /// Determines whether the shadow should be rendered.
  ///
  /// Returns `true` if the shadow should be rendered, otherwise `false`.
  bool get shouldRender {
    if (color.isVisible != true) return false;
    if (blur == 0 && spread == 0 && offset == Offset.zero) return false;
    return true;
  }

  /// Converts this [Shadow] to a [BoxShadow] object.
  ///
  /// Returns a [BoxShadow] with the same properties as this [Shadow].
  painting.BoxShadow get boxShadow {
    return painting.BoxShadow(
      blurRadius: blur,
      spreadRadius: spread,
      color: color.uiColor,
      offset: offset.uiOffset,
    );
  }
}

/// A class representing a shadow effect that can be applied to a widget.
class ShadowModifier extends ComponentModifier with DecorationModifier {
  final bool auto;

  /// The shadow effect.
  final Shadow shadow;

  /// Creates a new [ShadowModifier] instance with the given properties.
  ///
  /// All parameters are required.
  const ShadowModifier(
    this.auto,
    this.shadow,
  );

  @override
  Decoration? decorate(
    Decoration decoration,
    ComponentContext context,
  ) {
    if (!shadow.shouldRender) return null;

    final normalizedShadow = auto
        ? shadow.withColor(
            context.colors.shadow,
          )
        : shadow;

    if (decoration is BoxDecoration) {
      return decoration.copyWith(
        boxShadow: [
          normalizedShadow.boxShadow,
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
          normalizedShadow.boxShadow,
          ...?decoration.shadows,
        ],
      );
    }

    return null;
  }
}

mixin ModifiableShadow<Type extends Component> on Component<Type> {
  /// Adds a shadow effect to the widget.
  ///
  /// [blur] - The blur radius of the shadow.
  /// [spread] - The spread radius of the shadow.
  /// [color] - The color of the shadow.
  /// [offset] - The offset of the shadow.
  Type shadow({
    double blur = 0,
    double spread = 0,
    Color? color,
    Offset offset = Offset.zero,
  }) {
    return withModifier(
      ShadowModifier(
        color == null,
        Shadow(
          blur: blur,
          spread: spread,
          color: color ?? Color.black,
          offset: offset,
        ),
      ),
    );
  }
}
