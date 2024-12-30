import 'generator.dart';

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

  /// Indicates that the object has encountered an error.
  /// In this state, the component may display an error message or icon, and may change color to indicate an issue (e.g., red).
  errored,

  /// Indicates that the object has successfully completed an operation.
  /// In this state, the component may display a success message or icon, and may change color to indicate success (e.g., green).
  succeeded,

  /// Indicates that the object is in a warning state.
  /// In this state, the component may display a warning message or icon, and may change color to indicate caution (e.g., yellow).
  warned,

  /// Indicates that the object is inactive, such as a placeholder.
  /// In this state, the component may have a subdued visual styling to indicate it is not active.
  inactive,
}

class StatefulContainer<T> {
  final T normal;
  final T? highlighted;
  final T? disabled;
  final T? loading;
  final T? errored;
  final T? succeeded;
  final T? warned;
  final T? inactive;

  const StatefulContainer({
    required this.normal,
    this.highlighted,
    this.disabled,
    this.loading,
    this.errored,
    this.succeeded,
    this.warned,
    this.inactive,
  });

  T? get(State state) {
    switch (state) {
      case State.highlighted:
        return highlighted;
      case State.disabled:
        return disabled;
      case State.loading:
        return loading;
      case State.errored:
        return errored;
      case State.succeeded:
        return succeeded;
      case State.warned:
        return warned;
      case State.inactive:
        return inactive;
      default:
        return normal;
    }
  }

  T? operator [](State state) {
    return get(state);
  }

  @override
  int get hashCode => Object.hash(
        normal,
        highlighted,
        disabled,
        loading,
        errored,
        succeeded,
        warned,
        inactive,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StatefulContainer) return false;
    return normal == other.normal &&
        highlighted == other.highlighted &&
        disabled == other.disabled &&
        loading == other.loading &&
        errored == other.errored &&
        succeeded == other.succeeded &&
        warned == other.warned &&
        inactive == other.inactive;
  }
}

class StatefulContainerGenerator<T> extends Generator<StatefulContainer<T>> {
  final T Function(State state) generator;

  const StatefulContainerGenerator(this.generator);

  @override
  StatefulContainer<T> generate() => StatefulContainer(
        normal: generator(State.normal),
        highlighted: generator(State.highlighted),
        disabled: generator(State.disabled),
        loading: generator(State.loading),
        errored: generator(State.errored),
        succeeded: generator(State.succeeded),
        warned: generator(State.warned),
        inactive: generator(State.inactive),
      );
}
