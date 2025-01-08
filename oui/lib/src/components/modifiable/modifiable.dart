import 'package:flutter/widgets.dart'
    show
        BoxDecoration,
        BuildContext,
        DecoratedBox,
        Decoration,
        SizedBox,
        StatelessWidget,
        Widget;
import 'package:oui/src/components/app/static_app_context.dart';

import 'modifier.dart';

abstract class Modifiable<Component extends Widget> extends StatelessWidget {
  final Modifiers modifiers;

  const Modifiable({
    super.key,
    this.modifiers = const [],
  });

  Component copyWith({
    Modifiers? modifiers,
  });

  Component withModifier(Modifier modifier, {bool unique = true}) {
    if (unique) {
      return copyWith(
        modifiers: [
          ...modifiers.where((m) => m.runtimeType != modifier.runtimeType),
          modifier,
        ],
      );
    } else {
      return copyWith(
        modifiers: [
          ...modifiers,
          modifier,
        ],
      );
    }
  }

  Widget buildWithModifiers(
    Widget? child,
    ModifierContext context,
  ) {
    var modified = child ?? const SizedBox.shrink();

    for (final modifier in modifiers.whereType<ChildModifier>().where(
          (element) => !element.postDecoration,
        )) {
      modified = modifier.modify(modified, context) ?? modified;
    }

    Decoration? decoration;
    for (final modifier in modifiers.whereType<DecorationModifier>()) {
      decoration = modifier.decorate(
            decoration ?? const BoxDecoration(),
            context,
          ) ??
          decoration;
    }

    if (decoration != null) {
      modified = DecoratedBox(
        decoration: decoration,
        child: modified,
      );
    }

    for (final modifier in modifiers.whereType<ChildModifier>().where(
          (element) => element.postDecoration,
        )) {
      modified = modifier.modify(modified, context) ?? modified;
    }

    return modified;
  }

  @override
  Widget build(BuildContext context) {
    final modifierContext = ModifierContext(
      runtimeType,
      context,
      context.boxColors.normal,
    );
    return buildWithModifiers(
      null,
      modifierContext,
    );
  }
}
