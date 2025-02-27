import 'package:flutter/foundation.dart' show nonVirtual;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart'
    show
        AnimatedOpacity,
        BuildContext,
        Column,
        Curves,
        Expanded,
        GestureDetector,
        InheritedWidget,
        Row,
        StatefulWidget,
        StatelessWidget,
        Widget;
import 'package:flutter/widgets.dart' as widgets show State;
import 'package:oui/src/core/actions.dart' show Action, ActionContext;
import 'package:oui/src/core/config.dart' show Config;
import 'package:oui/src/core/modifiers.dart' show ModifierSorting;
import 'package:oui/src/core/utils.dart' show FirstOfTypeExtension;

import '../components/box.dart' show BoxLevel;
import 'colors.dart' show Accent, AccentModifier, BoxColors, ColorPalette;
import 'responsive.dart' show ResponsiveCondition, ResponsiveContext;
import 'state.dart' show State, StateModifier;

/// Context for modifiers, providing necessary information for modification.
class ComponentContext extends ResponsiveContext {
  final Type type;
  final BuildContext build;
  final BoxColors colors;
  final BoxLevel level;
  final Accent accent;
  final State state;
  final ComponentModifiers modifiers;

  const ComponentContext({
    required super.width,
    required super.height,
    required super.orientation,
    required super.density,
    required super.theme,
    required this.type,
    required this.build,
    required this.colors,
    required this.level,
    required this.accent,
    required this.state,
    required this.modifiers,
  });

  factory ComponentContext.withDetails(
    BuildContext context,
    Type type,
    ComponentModifiers modifiers, {
    BoxLevel? boxLevel,
  }) {
    final responsive = ResponsiveContext.of(context);
    final accent =
        modifiers.firstOfType<AccentModifier>()?.accent ?? Accent.of(context);
    final state =
        modifiers.firstOfType<StateModifier>()?.state ?? State.of(context);
    final palette = ColorPalette.of(context);
    final level = boxLevel ?? BoxLevel.of(context);
    final colors = palette.levels
        .get(responsive.theme)
        .get(level.level)
        .get(state)
        .accented(accent.level);

    return ComponentContext(
      type: type,
      build: context,
      colors: colors,
      width: responsive.width,
      height: responsive.height,
      orientation: responsive.orientation,
      density: responsive.density,
      theme: responsive.theme,
      accent: accent,
      state: state,
      level: level,
      modifiers: modifiers.resolve(responsive),
    );
  }

  Config get config => Config.of(build);

  @override
  String toString() {
    return 'ComponentContext{type: $type, width: $width, height: $height, orientation: $orientation, density: $density, theme: $theme, accent: $accent, state: $state}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComponentContext &&
        other.type == type &&
        other.width == width &&
        other.height == height &&
        other.orientation == orientation &&
        other.density == density &&
        other.theme == theme &&
        other.accent == accent &&
        other.state == state &&
        other.modifiers == modifiers;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        width.hashCode ^
        height.hashCode ^
        orientation.hashCode ^
        density.hashCode ^
        theme.hashCode ^
        accent.hashCode ^
        state.hashCode ^
        modifiers.hashCode;
  }

  static ComponentContext of(BuildContext buildContext) {
    final context = buildContext
        .dependOnInheritedWidgetOfExactType<ComponentContextProvider>()
        ?.context;
    assert(context != null, 'ComponentContext not found in widget tree');
    return context!;
  }
}

class ComponentContextProvider extends InheritedWidget {
  final ComponentContext context;

  const ComponentContextProvider({
    super.key,
    required this.context,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return context != (oldWidget as ComponentContextProvider).context;
  }
}

typedef ComponentModifierConditional = bool Function(ComponentContext context);

abstract class ComponentModifier {
  final ResponsiveCondition? condition;
  ComponentModifier merge(ComponentModifier other);
  const ComponentModifier({
    this.condition,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComponentModifier && other.condition == condition;
  }

  @override
  int get hashCode => condition.hashCode;
}

typedef ComponentModifiers = List<ComponentModifier>;

mixin WrapperModifier on ComponentModifier {
  Widget wrap(
    Widget child,
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

  /// Adds a modifier to the component
  ComponentType withModifier(
    ComponentModifier modifier, {
    bool stacks = false,
  }) {
    if (modifier.condition == null && !stacks) {
      return copyWith(
        modifiers: [
          ...modifiers.where(
            (m) => m.runtimeType != modifier.runtimeType || m.condition != null,
          ),
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

  Widget builder(ComponentContext context);

  Widget _wrapComponent(ComponentContext context, Widget child) {
    return context.modifiers.whereType<WrapperModifier>().fold(
      child,
      (Widget acc, WrapperModifier modifier) {
        return modifier.wrap(acc, context);
      },
    );
  }

  ComponentContext _componentContext(BuildContext context) {
    return ComponentContext.withDetails(
      context,
      runtimeType,
      modifiers,
    );
  }

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    final componentContext = _componentContext(context);
    return ComponentContextProvider(
      context: componentContext,
      child: _wrapComponent(
        componentContext,
        builder(componentContext),
      ),
    );
  }
}

typedef ComponentWidgetBuilder = Widget Function(ComponentContext context);
typedef ComponentCondition = bool Function(ComponentContext context);

class ConditionalComponent {
  final ComponentCondition? condition;
  final ComponentWidgetBuilder builder;

  const ConditionalComponent({
    this.condition,
    required this.builder,
  });

  bool isAvailable(ComponentContext context) {
    return condition?.call(context) ?? true;
  }
}

class InteractiveWrapper extends StatefulWidget {
  final Widget child;
  final Action? tapAction;

  const InteractiveWrapper({
    super.key,
    required this.child,
    this.tapAction,
  });

  @override
  widgets.State<InteractiveWrapper> createState() => _InteractiveWrapperState();
}

class _InteractiveWrapperState extends widgets.State<InteractiveWrapper> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.selectionClick();
        setState(() {
          pressed = true;
        });
      },
      onTapUp: (_) {
        HapticFeedback.lightImpact();
        setState(() {
          pressed = false;
        });
        widget.tapAction?.execute(ActionContext());
      },
      onTapCancel: () {
        setState(() {
          pressed = false;
        });
      },
      child: AnimatedOpacity(
        opacity: pressed ? 0.2 : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.fastOutSlowIn,
        child: widget.child,
      ),
    );
  }
}

class InteractiveModifier extends ComponentModifier with WrapperModifier {
  final bool enabled;
  final Action? tapAction;

  const InteractiveModifier({
    this.enabled = true,
    this.tapAction,
    super.condition,
  });

  @override
  Widget wrap(Widget child, ComponentContext context) {
    if (enabled) {
      return InteractiveWrapper(child: child);
    } else {
      return child;
    }
  }

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is InteractiveModifier) {
      return InteractiveModifier(
        enabled: other.enabled,
        tapAction: other.tapAction,
      );
    }
    return this;
  }
}

mixin ModifiableInteractive<Type extends Component> on Component<Type> {
  Type interactive({
    bool enabled = true,
    Action? tapAction,
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      InteractiveModifier(
        enabled: enabled,
        condition: condition,
        tapAction: tapAction,
      ),
    );
  }
}

class ExpandableModifier extends ComponentModifier with WrapperModifier {
  final bool horizontal;
  final bool vertical;

  const ExpandableModifier({
    this.horizontal = false,
    this.vertical = false,
    super.condition,
  });

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is ExpandableModifier) {
      return ExpandableModifier(
        horizontal: other.horizontal,
        vertical: other.vertical,
      );
    }
    return this;
  }

  @override
  Widget wrap(Widget child, ComponentContext context) {
    if (horizontal && vertical) {
      return Expanded(child: child);
    } else if (horizontal) {
      return Row(children: [Expanded(child: child)]);
    } else if (vertical) {
      return Column(children: [Expanded(child: child)]);
    } else {
      return child;
    }
  }
}

mixin ModifiableExpandable<Type extends Component> on Component<Type> {
  Type expands({
    bool horizontal = true,
    bool vertical = true,
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      ExpandableModifier(
        horizontal: horizontal,
        vertical: vertical,
        condition: condition,
      ),
    );
  }
}
