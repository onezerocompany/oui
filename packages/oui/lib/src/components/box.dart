import 'package:flutter/painting.dart' show BoxDecoration, Decoration;
import 'package:flutter/widgets.dart'
    show BuildContext, DecoratedBox, InheritedWidget, Widget, SizedBox;

import '../core/background.dart' show BackgroundModifier, ModifiableBackground;
import '../core/border.dart' show ModifiableBorder;
import '../core/colors.dart' show ModifiableAccent;
import '../core/component.dart'
    show
        Component,
        ComponentContext,
        ComponentModifier,
        ComponentModifiers,
        ComponentWidgetBuilder,
        ModifiableExpandable,
        ModifiableInteractive;
import '../core/corners.dart' show ModifiableCorner;
import '../core/geometry.dart'
    show
        FlowDirection,
        ModifiableAlignment,
        ModifiableInset,
        ModifiableSize,
        MultiChildAligner;
import '../core/modifiers.dart';
import '../core/responsive.dart' show ResponsiveCondition;
import '../core/shadow.dart' show ModifiableShadow;
import '../core/state.dart' show ModifiableState;
import '../core/utils.dart' show FirstOfTypeExtension;

/// Mixin for modifiers that decorate widgets.
mixin DecorationModifier on ComponentModifier {
  Decoration? decorate(
    Decoration decoration,
    ComponentContext context,
  );
}

class BoxLevel {
  final int level;
  const BoxLevel(this.level);

  BoxLevel increase(int amount) {
    return BoxLevel(level + amount);
  }

  static BoxLevel of(BuildContext context) {
    final boxLevel =
        context.dependOnInheritedWidgetOfExactType<BoxLevelContext>();
    return boxLevel?.level ?? const BoxLevel(0);
  }
}

class BoxLevelContext extends InheritedWidget {
  final BoxLevel level;

  const BoxLevelContext({
    super.key,
    required this.level,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return level != (oldWidget as BoxLevelContext).level;
  }

  static BoxLevel of(BuildContext context) {
    final boxLevel =
        context.dependOnInheritedWidgetOfExactType<BoxLevelContext>();
    return boxLevel?.level ?? const BoxLevel(0);
  }
}

class BoxContentProviderModifier extends ComponentModifier {
  final List<Widget> content;
  final ComponentWidgetBuilder? builder;
  final FlowDirection direction;

  const BoxContentProviderModifier({
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
  BoxContentProviderModifier merge(ComponentModifier other) {
    if (other is BoxContentProviderModifier) {
      return BoxContentProviderModifier(
        content: [...content, ...other.content],
        builder: other.builder ?? builder,
        direction: other.direction,
      );
    } else {
      return this;
    }
  }
}

mixin ContentModifier on ComponentModifier {
  Widget? modify(
    Widget? child,
    ComponentContext context,
  );
}

abstract class BoxLike<T extends Component<T>> extends Component<T>
    with
        ModifiableSize<T>,
        ModifiableAlignment<T>,
        ModifiableCorner<T>,
        ModifiableBackground<T>,
        ModifiableInset<T>,
        ModifiableBorder<T>,
        ModifiableShadow<T>,
        ModifiableState<T>,
        ModifiableAccent<T>,
        ModifiableInteractive<T>,
        ModifiableExpandable<T> {
  const BoxLike({
    super.key,
    super.modifiers,
  });

  @override
  Widget builder(ComponentContext context) {
    Widget widget = context.modifiers
            .firstOfType<BoxContentProviderModifier>()
            ?.provide(context) ??
        const SizedBox.shrink();

    widget = context.modifiers.whereType<ContentModifier>().fold(
      widget,
      (Widget acc, ContentModifier modifier) {
        return modifier.modify(acc, context) ?? acc;
      },
    );

    final decorators = context.modifiers.whereType<DecorationModifier>();
    if (decorators.isNotEmpty) {
      final Decoration decoration = decorators.fold(
        const BoxDecoration(),
        (Decoration acc, DecorationModifier decorator) =>
            decorator.decorate(acc, context) ?? acc,
      );
      widget = DecoratedBox(decoration: decoration, child: widget);
    }

    final hasBackground = context.modifiers.hasModifier<BackgroundModifier>();
    if (hasBackground) {
      widget = BoxLevelContext(
        level: BoxLevel.of(context.build).increase(1),
        child: widget,
      );
    }
    return widget;
  }
}

class Box extends BoxLike<Box> {
  const Box({
    super.key,
    super.modifiers,
  });

  @override
  Box copyWith({
    ComponentModifiers? modifiers,
  }) {
    return Box(
      key: key,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  Box contents(
    List<Widget> content, {
    FlowDirection direction = FlowDirection.topToBottom,
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      BoxContentProviderModifier(
        content: content,
        direction: direction,
        condition: condition,
      ),
    );
  }

  Box content(
    Widget content, {
    ResponsiveCondition? condition,
  }) {
    return contents(
      [content],
      direction: FlowDirection.topToBottom,
      condition: condition,
    );
  }

  Box contentBuilder(
    ComponentWidgetBuilder builder, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      BoxContentProviderModifier(
        builder: builder,
        condition: condition,
      ),
    );
  }
}
