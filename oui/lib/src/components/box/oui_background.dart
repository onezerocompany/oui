import 'package:flutter/widgets.dart';
import 'package:oui/src/components/box/oui_background_image.dart';
import 'package:oui/src/core/colors/oui_gradient.dart';
import '../../core/colors/oui_color.dart';

/// A class that represents the background of a widget, which can be a color,
/// gradient, image, or a custom widget.
class OuiBackground {
  /// The background color.
  final OuiColor? color;

  /// The background gradient.
  final OuiGradient? gradient;

  /// The background image.
  final OuiBackgroundImage? image;

  /// A custom widget to be used as the background.
  final Widget? custom;

  /// Private constructor for creating an [OuiBackground] instance.
  const OuiBackground._({
    this.color,
    this.gradient,
    this.image,
    this.custom,
  });

  /// Checks if the background should be rendered.
  ///
  /// Returns `true` if any of [color], [gradient], or [image] is not null.
  bool get shouldRender {
    return color != null || gradient != null || image != null;
  }

  /// Creates an [OuiBackground] with a solid color.
  ///
  /// [color] is the color to be used as the background.
  const OuiBackground.color(OuiColor color) : this._(color: color);

  /// Creates an [OuiBackground] with a gradient.
  ///
  /// [gradient] is the gradient to be used as the background.
  const OuiBackground.gradient(OuiGradient gradient)
      : this._(gradient: gradient);

  /// Creates an [OuiBackground] with an image.
  ///
  /// [image] is the image to be used as the background.
  const OuiBackground.image(OuiBackgroundImage image) : this._(image: image);

  /// Creates an [OuiBackground] with a custom widget.
  ///
  /// [custom] is the custom widget to be used as the background.
  const OuiBackground.custom(Widget custom) : this._(custom: custom);

  /// Applies the background properties to a given [BoxDecoration].
  ///
  /// [decoration] is the original [BoxDecoration] to which the background
  /// properties will be applied.
  ///
  /// Returns a new [BoxDecoration] with the background properties applied.
  BoxDecoration apply(BoxDecoration decoration) {
    if (!shouldRender) {
      return decoration;
    }

    var newDecoration = decoration.copyWith(
      color: color?.flutterColor,
      gradient: gradient?.flutterGradient,
    );

    if (image != null) {
      return image!.apply(newDecoration);
    }

    return newDecoration;
  }
}
