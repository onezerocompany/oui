import '../color.dart';
import 'box_colors.dart';

enum ColorPaletteAlgorithm {
  /// A color palette that uses a single color.
  monochromatic,
}

class ColorPaletteDetails {
  final ColorPaletteAlgorithm algorithm;
  final int levels;

  const ColorPaletteDetails({
    this.algorithm = ColorPaletteAlgorithm.monochromatic,
    this.levels = 5,
  });
}

class ColorPalette {
  /// The levels of the color palette.
  final ColorPaletteLevels levels;

  /// A dynamic color used as a barrier.
  final DynamicColor barrier;

  /// Creates a new instance of [ColorPalette].
  const ColorPalette({
    required this.levels,
    required this.barrier,
  });

  @override
  int get hashCode {
    return Object.hash(levels, barrier);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ColorPalette) return false;
    return levels == other.levels && barrier == other.barrier;
  }
}
