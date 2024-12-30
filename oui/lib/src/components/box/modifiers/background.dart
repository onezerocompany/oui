import 'package:flutter/widgets.dart' show Stack, Widget;
import 'package:oui/src/components/box/box_modifier.dart';

import '../../../core/colors/color.dart';
import '../../../core/colors/gradient.dart';
import '../background_image.dart';

/// A class that represents the background of a widget, which can be a color,
/// gradient, image, or a custom widget.
class Background extends BoxModifier {
  /// Use default background color.
  final bool isStandard;

  /// The background color.
  final Color? color;

  /// The background gradient.
  final Gradient? gradient;

  /// The background image.
  final BackgroundImage? image;

  /// A custom widget to be used as the background.
  final Widget? custom;

  /// Private constructor for creating an [Background] instance.
  const Background._({
    this.isStandard = false,
    this.color,
    this.gradient,
    this.image,
    this.custom,
  });

  const Background.standard() : this._(isStandard: true);

  /// Creates an [Background] with a solid color.
  ///
  /// [color] is the color to be used as the background.
  const Background.color(Color color) : this._(color: color);

  /// Creates an [Background] with a gradient.
  ///
  /// [gradient] is the gradient to be used as the background.
  const Background.gradient(Gradient gradient) : this._(gradient: gradient);

  /// Creates an [Background] with an image.
  ///
  /// [image] is the image to be used as the background.
  const Background.image(BackgroundImage image) : this._(image: image);

  /// Creates an [Background] with a custom widget.
  ///
  /// [custom] is the custom widget to be used as the background.
  const Background.custom(Widget custom) : this._(custom: custom);

  @override
  void modify(BoxModifierContext context) {
    if (isStandard) {
      context.decorate(
        context.decoration.copyWith(
          color: Color.white.uiColor,
        ),
      );
    }

    if (color != null || gradient != null || image != null) {
      context.decorate(
        context.decoration.copyWith(
          color: color?.uiColor,
          gradient: gradient?.uiGradient,
          image: image?.decorationImage,
        ),
      );
    }

    if (custom != null) {
      context.modifyContent(
        Stack(
          children: [
            custom!,
            context.content,
          ],
        ),
      );
    }
  }
}
