import 'package:flutter/painting.dart' show BoxDecoration, Decoration;
import 'package:flutter/widgets.dart'
    show BuildContext, DecoratedBox, InheritedWidget, Widget;
import 'package:oui/src/core/background.dart'
    show BackgroundModifier, ModifiableBackground;
import 'package:oui/src/core/border.dart' show ModifiableBorder;
import 'package:oui/src/core/colors.dart' show ModifiableAccent;
import 'package:oui/src/core/component.dart'
    show
        Component,
        ComponentContext,
        ComponentModifier,
        ComponentModifiers,
        ModifiableContentProvider;
import 'package:oui/src/core/corners.dart' show ModifiableCorner;
import 'package:oui/src/core/geometry.dart'
    show ModifiableAlignment, ModifiableInset, ModifiableSize;
import 'package:oui/src/core/modifiers.dart';
import 'package:oui/src/core/shadow.dart' show ModifiableShadow;
import 'package:oui/src/core/state.dart' show ModifiableState;

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

abstract class BoxLike<T extends Component<T>> extends Component<T>
    with
        ModifiableSize<T>,
        ModifiableAlignment<T>,
        ModifiableCorner<T>,
        ModifiableBackground<T>,
        ModifiableInset<T>,
        ModifiableBorder<T>,
        ModifiableShadow<T>,
        ModifiableContentProvider<T>,
        ModifiableState<T>,
        ModifiableAccent<T> {
  const BoxLike({
    super.key,
    super.modifiers,
  });

  @override
  Widget builder(ComponentContext context) {
    var widget = super.builder(context);

    final decorators = context.modifiers.whereType<DecorationModifier>();
    if (decorators.isNotEmpty) {
      final Decoration decoration = decorators.fold(
        const BoxDecoration(),
        (Decoration acc, decorator) {
          return decorator.decorate(acc, context) ?? acc;
        },
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
}
