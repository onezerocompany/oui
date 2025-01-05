import 'package:flutter/material.dart';

class ModifierContext {
  final Type componentType;
  final BuildContext buildContext;

  ModifierContext(
    this.componentType,
    this.buildContext,
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
