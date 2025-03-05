import 'package:contour/contour.dart';
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

import '../components/box.dart' show BoxLevel;
import 'actions.dart' show Action, ActionContext;
import 'colors.dart' show Accent, AccentModifier, BoxColors;
import 'context.dart' show ContextCondition, DynamicContext;
import 'modifiers.dart';
import 'state.dart' show State, StateModifier;
import 'utils.dart' show FirstOfTypeExtension;

class ComponentContext extends DynamicContext {
  const ComponentContext({
    required super.config,
    required super.router,
    required super.palette,
    required super.typography,
    required super.registry,
    required super.locale,
    required super.width,
    required super.height,
    required super.orientation,
    required super.density,
    required super.theme,
    required super.build,
    required super.auth,
    required this.colors,
    required this.level,
    required this.accent,
    required this.state,
    required this.modifiers,
    required this.data,
  });

  factory ComponentContext.forContexts(
    BuildContext buildContext,
    DynamicContext dynamicContext,
    ComponentModifiers modifiers,
  ) {
    final parent = ComponentContext.maybeOf(buildContext);

    final accent = modifiers.firstOfType<AccentModifier>()?.accent ??
        Accent.of(buildContext);
    final state =
        modifiers.firstOfType<StateModifier>()?.state ?? State.of(buildContext);
    final data =
        modifiers.whereType<DataModifier>().fold<Map<String, VariableInstance>>(
              parent?.data ?? {},
              (acc, modifier) =>
                  modifier.merge(DataModifier(acc)) is DataModifier
                      ? (modifier.merge(DataModifier(acc)) as DataModifier).data
                      : acc,
            );

    final level = BoxLevel.of(buildContext);

    final colors = dynamicContext.palette.levels
        .get(dynamicContext.theme)
        .get(level.level)
        .get(state)
        .accented(accent.level);

    return ComponentContext(
      config: dynamicContext.config,
      router: dynamicContext.router,
      palette: dynamicContext.palette,
      typography: dynamicContext.typography,
      registry: dynamicContext.registry,
      locale: dynamicContext.locale,
      width: dynamicContext.width,
      height: dynamicContext.height,
      orientation: dynamicContext.orientation,
      density: dynamicContext.density,
      theme: dynamicContext.theme,
      auth: dynamicContext.auth,
      build: buildContext,
      colors: colors,
      level: level,
      accent: accent,
      state: state,
      modifiers: modifiers.resolve(dynamicContext),
      data: data,
    );
  }

  final BoxColors colors;
  final BoxLevel level;
  final Accent accent;
  final State state;
  final ComponentModifiers modifiers;
  final Map<String, VariableInstance> data;

  Type get type => build.widget.runtimeType;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComponentContext &&
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
    return Object.hash(
      width,
      height,
      orientation,
      density,
      theme,
      accent,
      state,
      modifiers,
    );
  }

  static ComponentContext of(BuildContext buildContext) {
    final context = buildContext
        .dependOnInheritedWidgetOfExactType<ComponentContextProvider>()
        ?.context;
    assert(context != null, 'ComponentContext not found in widget tree');
    return context!;
  }

  static ComponentContext? maybeOf(BuildContext buildContext) {
    return buildContext
        .dependOnInheritedWidgetOfExactType<ComponentContextProvider>()
        ?.context;
  }

  @override
  String toString() {
    return 'ComponentContext{width: $width, height: $height, orientation: $orientation, density: $density, theme: $theme, accent: $accent, state: $state}';
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
  final ContextCondition? condition;
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

  ComponentType data(String key, ContourType type) {
    return withModifier(
      DataModifier({
        key: type.instance(key),
      }),
      stacks: true,
    );
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

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    final componentContext = ComponentContext.forContexts(
      context,
      DynamicContext.of(context),
      modifiers,
    );
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
    final componentContext = ComponentContext.of(context);
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.selectionClick();
        setState(() {
          pressed = true;
        });
      },
      onTapUp: (_) {
        widget.tapAction?.execute(ActionContext.from(componentContext));
        HapticFeedback.lightImpact();
        setState(() {
          pressed = false;
        });
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
      return InteractiveWrapper(
        tapAction: tapAction,
        child: child,
      );
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
    ContextCondition? condition,
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

class DataWrapper extends StatefulWidget {
  final ComponentContext context;
  final Widget child;

  const DataWrapper({
    super.key,
    required this.child,
    required this.context,
  });

  @override
  widgets.State<DataWrapper> createState() => _DataWrapperState();
}

class _DataWrapperState extends widgets.State<DataWrapper> {
  List<Subscription> subscriptions = [];

  @override
  void initState() {
    super.initState();
    _initializeListeners();
  }

  @override
  void didUpdateWidget(DataWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.context.data != widget.context.data) {
      _removeListeners();
      _initializeListeners();
    }
  }

  void _initializeListeners() {
    for (var instance in widget.context.data.values) {
      final subscription = instance.subscribe((listener) {
        if (mounted) {
          setState(() {});
        }
      });
      subscriptions.add(subscription);
    }
  }

  void _removeListeners() {
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class DataModifier extends ComponentModifier with WrapperModifier {
  final Map<String, VariableInstance> data;

  const DataModifier(
    this.data, {
    super.condition,
  });

  @override
  Widget wrap(Widget child, ComponentContext context) {
    return DataWrapper(
      context: context,
      child: child,
    );
  }

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is DataModifier) {
      return DataModifier(
        {...data, ...other.data},
      );
    }
    return this;
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
    ContextCondition? condition,
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
