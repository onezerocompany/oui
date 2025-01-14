import 'package:flutter/widgets.dart'
    show
        BoxDecoration,
        BuildContext,
        DecoratedBox,
        Decoration,
        SizedBox,
        StatelessWidget,
        Widget;
import 'package:oui/src/core/app.dart';

import 'colors.dart';
import 'config.dart';
import 'geometry.dart';

/// Context for modifiers, providing necessary information for modification.
class ComponentContext {
  final Type componentType;
  final BuildContext buildContext;
  final BoxColors boxColors;

  BoxColors get colors => buildContext.colors;
  Config get config => buildContext.config;

  ComponentContext(
    this.componentType,
    this.buildContext,
    this.boxColors,
  );
}

/// Base class for all modifiers.
abstract class ComponentModifier {
  const ComponentModifier();
}

typedef ComponentModifiers = List<ComponentModifier>;

/// Mixin for modifiers that modify child widgets.
mixin ChildModifier on ComponentModifier {
  Widget? modify(
    Widget? child,
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

/// Mixin for modifiers that provide child widgets.
mixin ChildProviderModifier on ComponentModifier {
  Widget provide(
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

  static const _defaultModifierTypeOrder = [
    ChildProviderModifier,
    ChildModifier,
    DecorationModifier,
  ];

  /// Sorts the modifiers based on their type.
  List<ComponentModifier> sortModifiers(List<ComponentModifier> modifiers) {
    modifiers.sort((a, b) {
      final aIndex = _defaultModifierTypeOrder.indexOf(a.runtimeType);
      final bIndex = _defaultModifierTypeOrder.indexOf(b.runtimeType);

      // Ensure SizeModifier is always last
      if (a is SizeModifier) return 1;
      if (b is SizeModifier) return -1;

      return (aIndex == -1 ? 1 : aIndex).compareTo(bIndex == -1 ? 1 : bIndex);
    });
    return modifiers;
  }

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

    final sortedModifiers = sortModifiers(modifiers);
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
      context.colors,
    );
    return buildWithModifiers(
      componentCtx,
      null,
    );
  }
}
