import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart'
    show
        BoxDecoration,
        BuildContext,
        DecoratedBox,
        Decoration,
        InheritedWidget,
        SizedBox,
        StatelessWidget,
        Text,
        TextStyle,
        Widget;
import 'package:oui/src/components/aligner.dart' show Aligner;
import 'package:oui/src/core/config.dart' show Config;
import 'package:oui/src/core/geometry.dart' show FlowDirection;
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
        other.state == state;
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
        state.hashCode;
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

/// Base class for all modifiers.
abstract class ComponentModifier {
  /// Whether the modifier can be applied multiple times.
  final bool multi;

  final ResponsiveCondition? condition;
  const ComponentModifier({
    this.condition,
    this.multi = false,
  });
}

typedef ComponentModifiers = List<ComponentModifier>;

class ChildProviderModifier extends ComponentModifier {
  final List<Widget> content;
  final Widget Function(ComponentContext)? builder;
  final FlowDirection direction;

  const ChildProviderModifier({
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
      return Aligner(
        flowDirection: direction,
        children: content,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

mixin ModifiableChildProvider<Type extends Component> on Component<Type> {
  Type contents(
    List<Widget> content, {
    FlowDirection direction = FlowDirection.topToBottom,
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      ChildProviderModifier(
        content: content,
        direction: direction,
        condition: condition,
      ),
    );
  }

  Type content(Widget content) => contents([content]);

  Type contentBuilder(
    Widget Function(ComponentContext) builder,
    ResponsiveCondition? condition,
  ) {
    return withModifier(
      ChildProviderModifier(
        builder: builder,
        condition: condition,
      ),
    );
  }
}

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

typedef ComponentBuilder = Widget Function(
  ComponentContext context,
  Widget? child,
);

/// Abstract class for widgets that can be modified with a list of [ComponentModifier]s.
abstract class Component<ComponentType extends Widget> extends StatelessWidget {
  final ComponentModifiers modifiers;

  const Component({
    super.key,
    this.modifiers = const [],
    this.builder,
  });

  /// Creates a copy of the component with the given modifiers.
  ComponentType copyWith({
    ComponentModifiers? modifiers,
  });

  /// Adds a modifier to the component, optionally ensuring uniqueness.
  ComponentType withModifier(
    ComponentModifier modifier,
  ) {
    return copyWith(
      modifiers: [
        ...modifiers,
        modifier,
      ],
    );
  }

  final ComponentBuilder? builder;

  /// Builds the widget with the applied modifiers.
  Widget _buildWithModifiers(BuildContext buildContext) {
    final context = ComponentContext.of(buildContext);
    Decoration? decoration;
    Widget? widget = builder?.call(context, null);

    final lastDecorationModifierIndex = context.modifiers.lastIndexWhere(
      (m) => m is DecorationModifier,
    );

    for (int i = 0; i < context.modifiers.length; i++) {
      final modifier = context.modifiers[i];
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
    return ComponentContextProvider(
      context: _componentContext(context),
      child: _buildWithModifiers(context),
    );
  }
}
