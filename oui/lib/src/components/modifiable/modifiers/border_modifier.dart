import 'package:flutter/painting.dart'
    show BoxDecoration, Decoration, ShapeDecoration;
import 'package:oui/oui.dart';

/// A class that modifies a border.
class BorderModifier extends Modifier with DecorationModifier {
  final Border border;

  /// Creates a border modifier with the given border.
  const BorderModifier(
    this.border,
  );

  @override
  Decoration? decorate(
    Decoration decoration,
    ModifierContext context,
  ) {
    if (!border.shouldRender) return null;

    if (decoration is ShapeDecoration) {
      if (decoration.shape is CornerBorder) {
        final current = decoration.shape as CornerBorder;
        return decoration.copyWith(
          shape: current.copyWith(
            side: border.side.uiBorderSide,
            align: border.align,
          ),
        );
      } else {
        return decoration.copyWith(
          shape: CornerBorder(
            side: border.side,
          ),
        );
      }
    }

    if (decoration is BoxDecoration) {
      return decoration.copyWith(
        border: border.uiBorder,
      );
    }

    return null;
  }

  @override
  String toString() {
    return 'BorderModifier(border: $border)';
  }
}

mixin ModifiableBorder<Component extends Modifiable> on Modifiable<Component> {
  Component borders({
    BorderSide? top,
    BorderSide? right,
    BorderSide? bottom,
    BorderSide? left,
  }) {
    return withModifier(
      BorderModifier(
        Border.only(
          top: top,
          right: right,
          bottom: bottom,
          left: left,
        ),
      ),
    );
  }

  Component borderForSide(
    RectangleSide boxSide,
    BorderSide borderSide,
  ) {
    return withModifier(
      BorderModifier(
        Border.forBoxSide(
          boxSide,
          borderSide,
        ),
      ),
    );
  }

  Component border({
    double thickness = 1,
    Color color = Color.black,
  }) {
    return withModifier(
      BorderModifier(
        Border.all(
          BorderSide(
            thickness: thickness,
            color: color,
          ),
        ),
      ),
    );
  }
}
