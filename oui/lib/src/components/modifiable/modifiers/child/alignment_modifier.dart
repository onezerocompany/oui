import 'package:flutter/widgets.dart' show Align, Widget;

import '../../../../core/geometry/alignment.dart';
import '../../modifiable.dart';
import '../../modifier.dart';

class AlignmentModifier extends Modifier with ChildModifier {
  final Alignment alignment;

  const AlignmentModifier(this.alignment);

  @override
  Widget? modify(Widget child, ModifierContext context) {
    return Align(
      alignment: alignment.uiAlignment,
      child: child,
    );
  }
}

mixin ModifiableAlignment<Component extends Modifiable>
    on Modifiable<Component> {
  Component alignment(Alignment alignment) {
    return withModifier(
      AlignmentModifier(alignment),
      unique: true,
    );
  }
}
