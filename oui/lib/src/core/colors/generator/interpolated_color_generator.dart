import '../hsl_color.dart';

class InterpolatedColorGenerator {
  final HslColor first;
  final HslColor second;
  final int steps;

  const InterpolatedColorGenerator(
    this.first,
    this.second, [
    this.steps = 5,
  ]) : assert(steps > 0, 'Steps must be greater than zero');

  HslColor generate(int step) {
    final double ratio = (step / steps);
    return first.lerpTo(second, ratio);
  }
}
