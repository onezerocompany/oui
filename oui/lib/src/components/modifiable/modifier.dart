import 'package:flutter/widgets.dart' show BuildContext, Decoration, Widget;

import '../../core/colors/palette/box_colors.dart';

class ModifierContext {
  final Type componentType;
  final BuildContext buildContext;
  final BoxColors boxColors;

  ModifierContext(
    this.componentType,
    this.buildContext,
    this.boxColors,
  );
}

abstract class Modifier {
  const Modifier();
}

mixin ChildModifier on Modifier {
  bool get postDecoration => false;
  Widget? modify(
    Widget child,
    ModifierContext context,
  );
}

mixin DecorationModifier on Modifier {
  Decoration? decorate(
    Decoration decoration,
    ModifierContext context,
  );
}

typedef Modifiers = List<Modifier>;
