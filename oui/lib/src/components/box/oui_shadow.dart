import 'package:flutter/widgets.dart';

import 'oui_offset.dart';
import '../../core/colors/oui_color.dart';

/// A class representing a shadow effect that can be applied to a widget.
class OuiShadow {
  /// The blur radius of the shadow.
  final double radius;

  /// The spread radius of the shadow.
  final double spread;

  /// The color of the shadow.
  final OuiColor color;

  /// The offset of the shadow.
  final OuiOffset offset;

  /// Creates a new [OuiShadow] instance with the given properties.
  ///
  /// All parameters are required.
  const OuiShadow({
    required this.radius,
    required this.spread,
    required this.color,
    required this.offset,
  });

  /// A constant shadow with no effect.
  static const OuiShadow none = OuiShadow(
    radius: 0,
    spread: 0,
    color: OuiColor.clear,
    offset: OuiOffset.zero,
  );

  /// Determines whether the shadow should be rendered.
  ///
  /// Returns `true` if the shadow should be rendered, otherwise `false`.
  bool get shouldRender {
    if (color.isVisible) {
      return false;
    }

    if (radius == 0 && spread == 0 && offset == OuiOffset.zero) {
      return false;
    }

    return true;
  }

  /// Converts this [OuiShadow] to a [BoxShadow] object.
  ///
  /// Returns a [BoxShadow] with the same properties as this [OuiShadow].
  BoxShadow get boxShadow {
    return BoxShadow(
      blurRadius: radius,
      spreadRadius: spread,
      color: color.flutterColor,
      offset: Offset(offset.x, offset.y),
    );
  }

  /// Applies this shadow to a given [BoxDecoration].
  ///
  /// If the shadow should not be rendered, the original [BoxDecoration] is returned.
  /// Otherwise, a new [BoxDecoration] with this shadow added to the existing shadows is returned.
  BoxDecoration apply(BoxDecoration decoration) {
    if (!shouldRender) {
      return decoration;
    }

    return decoration.copyWith(
      boxShadow: [
        boxShadow,
        ...?decoration.boxShadow,
      ],
    );
  }
}
