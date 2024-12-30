import '../../shared/dynamic_container.dart';
import '../../shared/leveled_container.dart';
import '../../shared/stateful_container.dart';
import 'accentable_color.dart';

class BoxColors {
  final AccentableColor surface;
  final AccentableColor content;
  final AccentableColor decoration;
  final AccentableColor shadow;
  final AccentableColor edge;
  final AccentableColor placeholder;

  const BoxColors({
    required this.content,
    required this.surface,
    required this.decoration,
    required this.shadow,
    required this.edge,
    required this.placeholder,
  });

  @override
  int get hashCode {
    return Object.hash(
      content,
      surface,
      decoration,
      shadow,
      edge,
      placeholder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BoxColors) return false;
    return content == other.content &&
        surface == other.surface &&
        decoration == other.decoration &&
        shadow == other.shadow &&
        edge == other.edge &&
        placeholder == other.placeholder;
  }
}

typedef StatefulBoxColors = StatefulContainer<BoxColors>;
typedef LeveledStatefulBoxColors = LeveledContainer<StatefulBoxColors>;
typedef ColorPaletteLevels = DynamicContainer<LeveledStatefulBoxColors>;
