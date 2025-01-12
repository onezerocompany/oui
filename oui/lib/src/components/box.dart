import 'package:flutter/widgets.dart'
    show BuildContext, InheritedWidget, SizedBox, Widget;

import '../core/_index.dart';
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
        ModifiableContent<T>,
        ModifiableState<T>,
        ModifiableAccent<T> {
  const BoxLike({
    super.key,
    super.modifiers,
  });

  static const _modifierOrder = [
    // content providers
    ContentModifier,
    // content modifiers
    AlignmentModifier,
    InsetModifier,
    // decoration modifiers
    BackgroundModifier,
    CornerModifier,
    BorderModifier,
    ShadowModifier,
    // widget modifiers
    StateModifier,
    AccentModifier,
    SizeModifier,
  ];

  @override
  List<ComponentModifier> sortModifiers(List<ComponentModifier> modifiers) {
    modifiers.sort((a, b) {
      final aIndex = _modifierOrder.indexOf(a.runtimeType);
      final bIndex = _modifierOrder.indexOf(b.runtimeType);

      return (aIndex == -1 ? 1 : aIndex).compareTo(bIndex == -1 ? 1 : bIndex);
    });
    return modifiers;
  }

  @override
  Widget build(BuildContext context) {
    var widget = buildWithModifiers(
      ComponentContext(
        runtimeType,
        context,
        context.colors,
      ),
    );

    final hasBackground = modifiers.whereType<BackgroundModifier>().isNotEmpty;
    if (hasBackground) {
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

class ContentModifier extends ComponentModifier with ChildProviderModifier {
  final List<Widget> content;
  final Widget Function(ComponentContext)? builder;
  final FlowDirection direction;

  const ContentModifier({
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

mixin ModifiableContent<Type extends Component> on Component<Type> {
  Type contents(
    List<Widget> content, {
    FlowDirection direction = FlowDirection.topToBottom,
  }) {
    return withModifier(
      ContentModifier(
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
      ContentModifier(
        builder: builder,
      ),
    );
  }
}
