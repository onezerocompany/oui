import 'package:flutter/rendering.dart' show BoxShadow;

import '../../../core/colors/color.dart';
import '../../../core/geometry/offset.dart';
import '../box_modifier.dart';

/// A class representing a shadow effect that can be applied to a widget.
class Shadow extends BoxModifier {
  /// The blur radius of the shadow.
  final double radius;

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
    required this.radius,
    required this.spread,
    required this.color,
    required this.offset,
  });

  /// A constant shadow with no effect.
  static const Shadow none = Shadow(
    radius: 0,
    spread: 0,
    color: Color.clear,
    offset: Offset.zero,
  );

  /// Determines whether the shadow should be rendered.
  ///
  /// Returns `true` if the shadow should be rendered, otherwise `false`.
  bool get shouldRender {
    if (color.isVisible == true) {
      return false;
    }

    if (radius == 0 && spread == 0 && offset == Offset.zero) {
      return false;
    }

    return true;
  }

  /// Converts this [Shadow] to a [BoxShadow] object.
  ///
  /// Returns a [BoxShadow] with the same properties as this [Shadow].
  BoxShadow get boxShadow {
    return BoxShadow(
      blurRadius: radius,
      spreadRadius: spread,
      color: color.uiColor,
      offset: offset.uiOffset,
    );
  }

  @override
  void modify(BoxModifierContext context) {
    if (shouldRender) {
      context.decorate(
        context.decoration.copyWith(
          boxShadow: [
            boxShadow,
            ...?context.decoration.boxShadow,
          ],
        ),
      );
    }
  }
}
