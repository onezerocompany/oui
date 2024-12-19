import 'package:flutter/widgets.dart';

class Background extends StatelessWidget {
  final Color? color;
  final Gradient? gradient;
  final Widget Function(BuildContext)? custom;

  const Background._({
    this.color,
    this.gradient,
    this.custom,
  });

  factory Background.color(Color color) => Background._(color: color);

  factory Background.gradient(Gradient gradient) =>
      Background._(gradient: gradient);

  factory Background.custom(
    Widget Function(BuildContext) custom, {
    Color? color,
    Gradient? gradient,
  }) =>
      Background._(
        color: color,
        gradient: gradient,
        custom: custom,
      );

  @override
  Widget build(BuildContext context) {
    Widget? background;

    if (gradient != null) {
      background = Container(
        decoration: BoxDecoration(gradient: gradient),
      );
    } else if (color != null) {
      background = Container(
        decoration: BoxDecoration(color: color),
      );
    }

    if (custom != null) {
      if (background != null) {
        background = Stack(
          children: [
            background,
            custom!(context),
          ],
        );
      } else {
        background = custom!(context);
      }
    }

    // Fallback to an empty widget if all parameters are null
    return background ?? const SizedBox.shrink();
  }
}
