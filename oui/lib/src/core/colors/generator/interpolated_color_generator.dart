import '../hsl_color.dart';

class InterpolatedColorGenerator {
  final HslColor first;
  final HslColor second;
  final int steps;

  const InterpolatedColorGenerator(
    this.first,
    this.second, [
    this.steps = 5,
  ]);

  HslColor generate(int step) {
    final double ratio = step / steps;
    return first.lerpWith(second, ratio);
  }
}
