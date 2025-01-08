import '../colors/color.dart';

class ColorConfig {
  final Color seed;
  final int levels;

  const ColorConfig({
    this.seed = Color.white,
    this.levels = 6,
  });
}
