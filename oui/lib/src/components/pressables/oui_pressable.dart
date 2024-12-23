import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../core/actions/oui_action.dart';
import '../app/oui_app_context.dart';

/// Represents the state of the Pressable widget.
enum OuiPressableState {
  /// The widget is in its default state.
  idle,

  /// The widget is being hovered over.
  hover,

  /// The widget is being actively pressed.
  active,
}

/// Represents the type of press interaction.
enum OuiPressType {
  /// A single tap interaction.
  tap,

  /// A long press interaction.
  longPress,

  /// A double tap interaction.
  doubleTap,
}

/// Callback type for press interactions.
typedef OuiPressableCallback = void Function(OuiPressType state);

/// Defines the visual state of the Pressable widget.
class OuiPressableThemeState {
  /// The scale of the widget.
  final double scale;

  /// The opacity of the widget.
  final double opacity;

  /// Creates a theme state with the given scale and opacity.
  const OuiPressableThemeState({
    this.scale = 1,
    this.opacity = 1,
  });
}

/// Defines the theme for the Pressable widget in different states.
class OuiPressableTheme {
  /// The theme state when the widget is idle.
  final OuiPressableThemeState idle;

  /// The theme state when the widget is hovered over.
  final OuiPressableThemeState hover;

  /// The theme state when the widget is actively pressed.
  final OuiPressableThemeState active;

  /// Creates a theme with the given states for idle, hover, and active.
  const OuiPressableTheme({
    this.idle = const OuiPressableThemeState(),
    this.hover = const OuiPressableThemeState(
      opacity: 0.9,
      scale: 1.02,
    ),
    this.active = const OuiPressableThemeState(
      opacity: 0.7,
      scale: 0.99,
    ),
  });

  /// Returns the opacity for the given state.
  double opacity(OuiPressableState state) {
    switch (state) {
      case OuiPressableState.idle:
        return idle.opacity;
      case OuiPressableState.hover:
        return hover.opacity;
      case OuiPressableState.active:
        return active.opacity;
    }
  }

  /// Returns the scale for the given state.
  double scale(OuiPressableState state) {
    switch (state) {
      case OuiPressableState.idle:
        return idle.scale;
      case OuiPressableState.hover:
        return hover.scale;
      case OuiPressableState.active:
        return active.scale;
    }
  }
}

/// Defines the actions to be performed on different press interactions.
class OuiPressableActions {
  /// Action to be performed on a tap interaction.
  final OuiAction? tap;

  /// Action to be performed on a long press interaction.
  final OuiAction? longPress;

  /// Action to be performed on a double tap interaction.
  final OuiAction? doubleTap;

  /// Creates a set of actions for tap, long press, and double tap interactions.
  const OuiPressableActions({
    required this.tap,
    required this.longPress,
    required this.doubleTap,
  }) : assert(tap != null || longPress != null || doubleTap != null);

  /// Returns the action for the given press type.
  OuiAction? call(OuiPressType type) {
    switch (type) {
      case OuiPressType.tap:
        return tap;
      case OuiPressType.longPress:
        return longPress;
      case OuiPressType.doubleTap:
        return doubleTap;
    }
  }

  /// Creates a set of actions with only a tap action.
  factory OuiPressableActions.tap(OuiAction action) {
    return OuiPressableActions(
      tap: action,
      longPress: null,
      doubleTap: null,
    );
  }
}

/// A widget that detects various press interactions and changes its state accordingly.
class OuiPressable extends HookWidget {
  /// The child widget to display inside the Pressable.
  final Widget child;

  /// Callback to be called when a press interaction occurs.
  final OuiPressableActions? actions;

  /// Creates a Pressable widget.
  const OuiPressable(
    this.child,
    this.actions, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hovering = useState(false);
    final state = useState<OuiPressableState>(OuiPressableState.idle);
    final theme = context.config.pressableTheme;
    return MouseRegion(
      onEnter: (_) {
        hovering.value = true;
        state.value = OuiPressableState.hover;
      },
      onExit: (_) {
        hovering.value = false;
        state.value = OuiPressableState.idle;
      },
      child: GestureDetector(
        onTapDown: (_) {
          state.value = OuiPressableState.active;
        },
        onTapUp: (_) {
          if (hovering.value) {
            state.value = OuiPressableState.hover;
          } else {
            state.value = OuiPressableState.idle;
          }
        },
        onTapCancel: () {
          state.value = OuiPressableState.idle;
        },
        onTap: () {
          actions?.call(OuiPressType.tap);
        },
        onLongPress: () {
          actions?.call(OuiPressType.longPress);
        },
        onDoubleTap: () {
          actions?.call(OuiPressType.doubleTap);
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: theme.opacity(state.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.ease,
            transformAlignment: Alignment.center,
            transform: state.value == OuiPressableState.active
                ? Matrix4.diagonal3Values(
                    theme.scale(state.value),
                    theme.scale(state.value),
                    1,
                  )
                : Matrix4.identity(),
            child: child,
          ),
        ),
      ),
    );
  }
}
