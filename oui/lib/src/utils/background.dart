import 'package:oui/oui.dart';

class Background extends StatelessWidget {
  final Color? color;
  final Gradient? gradient;
  final Widget Function(BuildContext)? custom;

  const Background({
    super.key,
    this.color,
    this.gradient,
    this.custom,
  });

  factory Background.color(Color color) => Background(color: color);

  factory Background.gradient(Gradient gradient) =>
      Background(gradient: gradient);

  factory Background.custom(
    Widget Function(BuildContext) custom, {
    Color? color,
    Gradient? gradient,
  }) =>
      Background(
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
      background = Container(color: color);
    }

    if (custom != null && background != null) {
      background = Stack(
        children: [
          background,
          custom!(context),
        ],
      );
    } else {
      background = custom!(context);
    }

    return background;
  }
}
