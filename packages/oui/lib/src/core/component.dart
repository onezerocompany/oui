import 'package:flutter/widgets.dart'
    show
        BoxDecoration,
        BuildContext,
        DecoratedBox,
        Decoration,
        SizedBox,
        StatelessWidget,
        Text,
        TextStyle,
        Widget;
import 'package:oui/src/core/app.dart';
import 'package:oui/src/core/modifiers.dart';
import 'package:oui/src/core/state.dart' show ComponentStateExtension, State;

import 'colors.dart';
import 'config.dart';

/// Context for modifiers, providing necessary information for modification.
class ComponentContext {
  final Type componentType;
  final BuildContext buildContext;

  BoxColors get colors => buildContext.colors;
  Config get config => buildContext.config;

  int get accent => buildContext.accent;
  State get state => buildContext.state;

  ComponentContext(
    this.componentType,
    this.buildContext,
  );
}

typedef ComponentModifierConditional = bool Function(ComponentContext context);

/// Base class for all modifiers.
abstract class ComponentModifier {
  final ComponentModifierConditional? condition;
  const ComponentModifier({this.condition});
}

typedef ComponentModifiers = List<ComponentModifier>;

class ComponentTypeModifier extends ComponentModifier {}

/// Mixin for modifiers that modify child widgets.
mixin ChildModifier on ComponentModifier {
  Widget? modify(
    Widget? child,
    ComponentContext context,
  );
}

/// Mixin for modifiers that provide child widgets.
mixin ChildProviderModifier on ComponentModifier {
  Widget provide(
    ComponentContext context,
  );
}

/// Mixin for modifiers that decorate widgets.
mixin DecorationModifier on ComponentModifier {
  Decoration? decorate(
    Decoration decoration,
    ComponentContext context,
  );
}

/// Mixin for modifiers that modify text styles.
mixin TextStyleModifier on ComponentModifier {
  TextStyle modify(
    TextStyle style,
    ComponentContext context,
  );
}

/// Mixin for modifiers that modify labels.
mixin TextModifier on ComponentModifier {
  Text modify(
    Text text,
    ComponentContext context,
  );
}

/// Abstract class for widgets that can be modified with a list of [ComponentModifier]s.
abstract class Component<ComponentType extends Widget> extends StatelessWidget {
  final ComponentModifiers modifiers;

  const Component({
    super.key,
    this.modifiers = const [],
  });

  /// Creates a copy of the component with the given modifiers.
  ComponentType copyWith({
    ComponentModifiers? modifiers,
  });

  /// Adds a modifier to the component, optionally ensuring uniqueness.
  ComponentType withModifier(ComponentModifier modifier, {bool unique = true}) {
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

  /// Builds the widget with the applied modifiers.
  Widget buildWithModifiers(
    ComponentContext context, [
    Widget? child,
  ]) {
    Decoration? decoration;
    Widget? widget = child;

    final sortedModifiers = modifiers.sorted;
    final lastDecorationModifierIndex = sortedModifiers.lastIndexWhere(
      (m) => m is DecorationModifier,
    );
    for (int i = 0; i < sortedModifiers.length; i++) {
      final modifier = sortedModifiers[i];
      if (modifier is ChildProviderModifier) {
        widget = modifier.provide(context);
      }
      if (modifier is ChildModifier) {
        widget = modifier.modify(widget, context) ?? widget;
      }
      if (modifier is DecorationModifier) {
        decoration = modifier.decorate(
              decoration ?? const BoxDecoration(),
              context,
            ) ??
            decoration;
      }
      if (i == lastDecorationModifierIndex && decoration != null) {
        widget = DecoratedBox(
          decoration: decoration,
          child: widget,
        );
      }
    }

    return widget ?? const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final componentCtx = ComponentContext(
      runtimeType,
      context,
    );
    return buildWithModifiers(
      componentCtx,
      null,
    );
  }
}
