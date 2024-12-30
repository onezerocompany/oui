import 'package:oui/src/core/colors/color.dart';
import 'package:oui/src/core/shared/leveled_container.dart';

class AccentableColor {
  final Color normal;
  final LeveledContainer<Color> _levels;

  const AccentableColor(
    this.normal,
    this._levels,
  );

  Color accented(int level) => _levels.get(level);

  @override
  int get hashCode {
    return _levels.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AccentableColor) return false;
    return _levels == other._levels;
  }
}
