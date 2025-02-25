import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart'
    show BuildContext, InheritedWidget, SizedBox, StatelessWidget, Widget;
import 'package:oui/src/core/config.dart' show Config;
import 'package:oui/src/core/geometry.dart'
    show MultiChildAligner, FlowDirection;
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

class ContentProviderModifier extends ComponentModifier {
  final List<Widget> content;
  final Widget Function(ComponentContext)? builder;
  final FlowDirection direction;

  const ContentProviderModifier({
    this.content = const [],
    this.builder,
    this.direction = FlowDirection.topToBottom,
    super.condition,
  });

  Widget provide(ComponentContext context) {
    if (builder != null) {
      return builder!(context);
    } else if (content.length == 1) {
      return content.first;
    } else if (content.isNotEmpty) {
      return MultiChildAligner(
        flowDirection: direction,
        children: content,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  ContentProviderModifier merge(ComponentModifier other) {
    if (other is ContentProviderModifier) {
      return ContentProviderModifier(
        content: [...content, ...other.content],
        builder: other.builder ?? builder,
        direction: other.direction,
      );
    } else {
      return this;
    }
  }
}

mixin ModifiableContentProvider<Type extends Component> on Component<Type> {
  Type contents(
    List<Widget> content, {
    FlowDirection direction = FlowDirection.topToBottom,
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      ContentProviderModifier(
        content: content,
        direction: direction,
        condition: condition,
      ),
    );
  }

  Type content(
    Widget content, {
    FlowDirection direction = FlowDirection.topToBottom,
    ResponsiveCondition? condition,
  }) =>
      contents([content], direction: direction, condition: condition);

  Type items(
    List<Widget> children, {
    FlowDirection direction = FlowDirection.topToBottom,
    ResponsiveCondition? condition,
  }) =>
      contents(children, direction: direction, condition: condition);

  Type contentBuilder(
    Widget Function(ComponentContext) builder, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      ContentProviderModifier(
        builder: builder,
        condition: condition,
      ),
    );
  }
}

/// Mixin for modifiers that modify child widgets.
mixin ContentModifier on ComponentModifier {
  Widget? modify(
    Widget? child,
    ComponentContext context,
  );
}

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
    ComponentModifier modifier,
  ) {
    if (modifier.condition == null) {
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

  Widget builder(ComponentContext context) {
    var widget = context.modifiers
            .firstOfType<ContentProviderModifier>()
            ?.provide(context) ??
        const SizedBox.shrink();

    widget = context.modifiers.whereType<ContentModifier>().fold(
      widget,
      (Widget acc, ContentModifier modifier) {
        return modifier.modify(acc, context) ?? acc;
      },
    );

    return widget;
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
    print('Building $runtimeType');
    final componentContext = _componentContext(context);
    return ComponentContextProvider(
      context: componentContext,
      child: builder(componentContext),
    );
  }
}
