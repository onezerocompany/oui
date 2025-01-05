import 'package:flutter/widgets.dart'
    show
        BoxDecoration,
        BuildContext,
        Decoration,
        ShapeDecoration,
        Stack,
        Widget;

import '../../core/colors/color.dart';
import '../../core/colors/gradient.dart';
import '../modifiable/modifier.dart';
import 'background_image.dart';
import 'shape_decoration.dart';

/// A class that represents the background of a widget, which can be a color,
/// gradient, image, or a custom widget.
class Background {
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
    this.color,
    this.gradient,
    this.image,
    this.custom,
  });

  /// Creates an [Background] with a solid color.
  ///
  /// [color] is the color to be used as the background.
  const Background.color(Color color) : this._(color: color);

  /// Creates an [Background] with a gradient.
  /// w t
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

  bool get shouldRender =>
      color != null || gradient != null || image != null || custom != null;

  Decoration? decorate(
    Decoration decoration,
    BuildContext context,
  ) {
    if (color == null && gradient == null && image == null) {
      return null;
    }

    if (decoration is BoxDecoration) {
      return decoration.copyWith(
        color: color?.uiColor,
        image: image?.decorationImage,
        gradient: gradient?.uiGradient,
      );
    }

    if (decoration is ShapeDecoration) {
      return decoration.copyWith(
        color: color?.uiColor,
        image: image?.decorationImage,
        gradient: gradient?.uiGradient,
      );
    }

    return null;
  }

  Widget? modify(
    Widget child,
    ModifierContext context,
  ) {
    if (custom == null) return null;
    return Stack(
      children: [
        custom!,
        child,
      ],
    );
  }
}
