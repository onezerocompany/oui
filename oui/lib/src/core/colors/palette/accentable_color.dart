import 'package:oui/src/core/colors/color.dart';
import 'package:oui/src/core/shared/leveled_container.dart';

class AccentableColor {
  final Color normal;
  final LeveledContainer<Color> _levels;

  /// Creates an [AccentableColor] with a normal color and a leveled container of colors.
  ///
  /// The [normal] color must not be null.
  /// The [_levels] container must not be null.
  const AccentableColor(
    this.normal,
    this._levels,
  );

  /// Returns the color at the specified [level].
  ///
  /// If the levels container is empty, returns the normal color.
  Color accented(int level) {
    if (_levels.isEmpty) {
      return normal;
    }
    return _levels.get(level);
  }

  @override
  int get hashCode {
    return _levels.hashCode ^ normal.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AccentableColor) return false;
    return _levels == other._levels && normal == other.normal;
  }
}
