import 'package:flutter/widgets.dart';
import 'package:oui/src/core/component.dart';
import 'package:oui/src/core/utils.dart';

/// Represents the various states that an object can be in within the OUI framework.
enum State {
  /// The default state, indicating normal operation.
  /// In this state, the component behaves as expected with no special visual or functional changes.
  normal,

  /// Indicates a state where the object has reached its peak performance or usage.
  /// In this state, the component may have enhanced visual styling to draw attention, such as a brighter color or a glow effect.
  highlighted,

  /// Indicates a state where the object is disabled and not functional.
  /// In this state, the component is typically grayed out and does not respond to user interactions.
  disabled,

  /// Indicates that the object is in a loading state.
  /// In this state, the component may display a loading spinner or progress bar, and user interactions may be temporarily disabled.
  loading,

  /// Indicates that the object has successfully completed an operation.
  /// In this state, the component may display a success message or icon, and may change color to indicate success (e.g., green).
  succeeded,

  /// Indicates that the object is in a warning state.
  /// In this state, the component may display a warning message or icon, and may change color to indicate caution (e.g., yellow).
  warned,

  /// Indicates that the object has encountered an error.
  /// In this state, the component may display an error message or icon, and may change color to indicate an issue (e.g., red).
  errored,
}

class StatefulContainer<T> extends EnumContainer<State, T> {
  StatefulContainer(super.values);

  StatefulContainer.generate(T Function(State) generator)
      : super.generate(generator, State.values);

  T get normal => this[State.normal];

  @override
  List<State> get keys => State.values;
}

class ComponentState extends InheritedWidget {
  final State state;

  const ComponentState({
    super.key,
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return state != (oldWidget as ComponentState).state;
  }

  static State of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<ComponentState>()
            ?.state ??
        State.normal;
  }
}

extension ComponentStateExtension on BuildContext {
  State get state {
    return ComponentState.of(this);
  }
}

class StateModifier extends ComponentModifier with ChildModifier {
  final State state;

  const StateModifier(this.state);

  @override
  Widget? modify(Widget? child, ComponentContext context) {
    if (child == null) return null;
    return ComponentState(
      state: state,
      child: child,
    );
  }
}

mixin ModifiableState<Type extends Component<Type>> on Component<Type> {
  Type state(State state) {
    return withModifier(StateModifier(state));
  }

  Type get normal => state(State.normal);
  Type get disabled => state(State.disabled);
}
