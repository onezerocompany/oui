import 'package:flutter/widgets.dart' show Padding, Widget;
import 'package:oui/src/components/modifiable/modifier.dart';
import 'package:oui/src/core/geometry/insets.dart';

import '../../modifiable.dart';

/// A class representing insets (padding or margins) for a box and modifying a widget.
class InsetModifier extends Modifier with ChildModifier {
  final Insets insets;

  const InsetModifier(this.insets);

  @override
  Widget? modify(Widget child, ModifierContext context) {
    if (!insets.shouldRender) return null;

    return Padding(
      padding: insets.edgeInsets,
      child: child,
    );
  }

  @override
  String toString() {
    return 'InsetModifier(insets: $insets)';
  }
}

mixin ModifiableInset<Component extends Modifiable> on Modifiable<Component> {
  Component inset(Insets insets) {
    return withModifier(InsetModifier(insets));
  }
}
