import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../actions/oui_action.dart';
import '../app/oui_app_context.dart';

/// Represents the state of the Pressable widget.
enum OuiPressableState {
  idle,
  hover,
  active,
}

/// Represents the type of press interaction.
enum OuiPressType {
  tap,
  longPress,
  doubleTap,
}

/// Callback type for press interactions.
typedef OuiPressableCallback = void Function(OuiPressType state);

class OuiPressableThemeState {
  final double scale;
  final double opacity;

  const OuiPressableThemeState({
    this.scale = 1,
    this.opacity = 1,
  });
}

class OuiPressableTheme {
  final OuiPressableThemeState idle;
  final OuiPressableThemeState hover;
  final OuiPressableThemeState active;

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

class OuiPressableActions {
  final OuiAction? tap;
  final OuiAction? longPress;
  final OuiAction? doubleTap;

  const OuiPressableActions({
    required this.tap,
    required this.longPress,
    required this.doubleTap,
  }) : assert(tap != null || longPress != null || doubleTap != null);

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
