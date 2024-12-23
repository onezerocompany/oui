/// Represents the various states that an object can be in within the OUI framework.
enum OuiState {
  /// The default state, indicating normal operation.
  /// In this state, the component behaves as expected with no special visual or functional changes.
  normal,

  /// Indicates a state where the object has reached its peak performance or usage.
  /// In this state, the component may have enhanced visual styling to draw attention, such as a brighter color or a glow effect.
  highlight,

  /// Indicates a state where the object is disabled and not functional.
  /// In this state, the component is typically grayed out and does not respond to user interactions.
  disabled,

  /// Indicates that the object is in a loading state.
  /// In this state, the component may display a loading spinner or progress bar, and user interactions may be temporarily disabled.
  loading,

  /// Indicates that the object has encountered an error.
  /// In this state, the component may display an error message or icon, and may change color to indicate an issue (e.g., red).
  error,

  /// Indicates that the object has successfully completed an operation.
  /// In this state, the component may display a success message or icon, and may change color to indicate success (e.g., green).
  success,

  /// Indicates that the object is in a warning state.
  /// In this state, the component may display a warning message or icon, and may change color to indicate caution (e.g., yellow).
  warning,

  /// Indicates that the object is inactive but not disabled.
  /// In this state, the component may appear dimmed or less prominent, but can still respond to user interactions.
  inactive,
}
