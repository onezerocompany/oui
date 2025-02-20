import 'package:flutter/widgets.dart'
    show BuildContext, InheritedWidget, Widget;
import 'package:oui/src/core/background.dart'
    show BackgroundModifier, ModifiableBackground;
import 'package:oui/src/core/border.dart' show ModifiableBorder;
import 'package:oui/src/core/colors.dart' show ModifiableAccent;
import 'package:oui/src/core/component.dart'
    show
        Component,
        ComponentContext,
        ComponentModifiers,
        ModifiableChildProvider;
import 'package:oui/src/core/corners.dart' show ModifiableCorner;
import 'package:oui/src/core/geometry.dart'
    show ModifiableAlignment, ModifiableInset, ModifiableSize;
import 'package:oui/src/core/modifiers.dart';
import 'package:oui/src/core/shadow.dart' show ModifiableShadow;
import 'package:oui/src/core/state.dart' show ModifiableState;

class BoxLevel {
  final int level;
  const BoxLevel(this.level);

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
        ModifiableChildProvider<T>,
        ModifiableState<T>,
        ModifiableAccent<T> {
  const BoxLike({
    super.key,
    super.modifiers,
  });

  @override
  Widget build(BuildContext context) {
    var widget = _buildWithModifiers(
      ComponentContext(
        runtimeType,
        context,
      ),
    );

    if (modifiers.hasModifier<BackgroundModifier>()) {
      return BoxLevelContext(
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
