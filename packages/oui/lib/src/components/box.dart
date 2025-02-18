import 'package:flutter/widgets.dart'
    show BuildContext, InheritedWidget, SizedBox, Widget;
import 'package:oui/src/core/background.dart'
    show BackgroundModifier, ModifiableBackground;
import 'package:oui/src/core/border.dart' show ModifiableBorder;
import 'package:oui/src/core/colors.dart' show ModifiableAccent;
import 'package:oui/src/core/component.dart'
    show
        ChildProviderModifier,
        Component,
        ComponentContext,
        ComponentModifiers,
        ComponentModifier;
import 'package:oui/src/core/corners.dart' show ModifiableCorner;
import 'package:oui/src/core/geometry.dart'
    show FlowDirection, ModifiableAlignment, ModifiableInset, ModifiableSize;
import 'package:oui/src/core/modifiers.dart';
import 'package:oui/src/core/shadow.dart' show ModifiableShadow;
import 'package:oui/src/core/state.dart' show ModifiableState;

import 'aligner.dart';

class BoxLevel extends InheritedWidget {
  final int level;

  const BoxLevel({
    super.key,
    required this.level,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return level != (oldWidget as BoxLevel).level;
  }

  static BoxLevel? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BoxLevel>();
  }
}

extension BoxLevelExtension on BuildContext {
  int get boxLevel {
    return BoxLevel.of(this)?.level ?? 0;
  }
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
        ModifiableBoxContent<T>,
        ModifiableState<T>,
        ModifiableAccent<T> {
  const BoxLike({
    super.key,
    super.modifiers,
  });

  @override
  Widget build(BuildContext context) {
    var widget = buildWithModifiers(
      ComponentContext(
        runtimeType,
        context,
      ),
    );

    if (modifiers.hasModifier<BackgroundModifier>()) {
      return BoxLevel(
        level: context.boxLevel + 1,
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
}

class BoxContentModifier extends ComponentModifier with ChildProviderModifier {
  final List<Widget> content;
  final Widget Function(ComponentContext)? builder;
  final FlowDirection direction;

  const BoxContentModifier({
    this.content = const [],
    this.builder,
    this.direction = FlowDirection.topToBottom,
  });

  @override
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

mixin ModifiableBoxContent<Type extends Component> on Component<Type> {
  Type contents(
    List<Widget> content, {
    FlowDirection direction = FlowDirection.topToBottom,
  }) {
    return withModifier(
      BoxContentModifier(
        content: content,
        direction: direction,
      ),
    );
  }

  Type content(Widget content) => contents([content]);

  Type contentBuilder(
    Widget Function(ComponentContext) builder,
  ) {
    return withModifier(
      BoxContentModifier(
        builder: builder,
      ),
    );
  }
}
