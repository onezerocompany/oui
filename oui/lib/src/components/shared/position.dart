/// Enum representing the position within a container.
enum Position {
  /// Leading position (start).
  leading,

  /// Middle position (center).
  middle,

  /// Trailing position (end).
  trailing;

  /// Returns the opposite position.
  Position get opposite {
    switch (this) {
      case Position.leading:
        return Position.trailing;
      case Position.middle:
        return Position.middle;
      case Position.trailing:
        return Position.leading;
    }
  }
}
