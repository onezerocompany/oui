import 'package:flutter/widgets.dart'
    show
        BoxDecoration,
        BuildContext,
        Decoration,
        DecorationImage,
        ImageProvider,
        ImageRepeat,
        ShapeDecoration,
        Stack,
        Widget;
import 'package:oui/src/core/responsive.dart';

import 'colors.dart';
import 'component.dart';
import 'geometry.dart';
import 'utils.dart';

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
    Widget? child,
    ComponentContext context,
  ) {
    if (custom == null) return null;
    return Stack(
      children: [
        custom!,
        if (child != null) child,
      ],
    );
  }
}

/// Enum representing the different background repeat options for an image.
///
/// This enum provides four options for repeating a background image:
/// - `noRepeat`: The image is not repeated.
/// - `repeat`: The image is repeated both horizontally and vertically.
/// - `repeatX`: The image is repeated only horizontally.
/// - `repeatY`: The image is repeated only vertically.
///
/// Each option is associated with a corresponding `ImageRepeat` value.
///
/// Example usage:
/// ```dart
/// BackgroundRepeat backgroundRepeat = BackgroundRepeat.repeat;
/// print(backgroundRepeat.imageRepeat); // Output: ImageRepeat.repeat
/// ```
///
/// This can be useful when you need to specify how a background image should be repeated
/// in a custom UI component.
enum BackgroundRepeat {
  noRepeat(ImageRepeat.noRepeat),
  repeat(ImageRepeat.repeat),
  repeatX(ImageRepeat.repeatX),
  repeatY(ImageRepeat.repeatY);

  final ImageRepeat imageRepeat;
  const BackgroundRepeat(this.imageRepeat);
}

/// A class that represents a background image with various properties
/// such as alignment, repeat behavior, fit, opacity, and scale.
class BackgroundImage {
  /// The image to be used as the background.
  final ImageProvider image;

  /// The alignment of the background image.
  /// Defaults to [Alignment.center].
  final Alignment alignment;

  /// The repeat behavior of the background image.
  /// Defaults to [BackgroundRepeat.noRepeat].
  final BackgroundRepeat repeat;

  /// How the image should be inscribed into the box.
  /// Defaults to [BoxFit.cover].
  final RectangleFit fit;

  /// The opacity of the background image.
  /// Defaults to 1 (fully opaque).
  final double opacity;

  /// The scale of the background image.
  /// Defaults to 1 (no scaling).
  final double scale;

  /// Creates a [BackgroundImage] with the given properties.
  ///
  /// All properties are optional except for [image].
  const BackgroundImage({
    required this.image,
    this.alignment = Alignment.center,
    this.repeat = BackgroundRepeat.noRepeat,
    this.fit = RectangleFit.cover,
    this.opacity = 1,
    this.scale = 1,
  });

  DecorationImage get decorationImage {
    return DecorationImage(
      image: image,
      alignment: alignment.uiAlignment,
      repeat: repeat.imageRepeat,
      fit: fit.boxFit,
      opacity: opacity,
      scale: scale,
    );
  }
}

class BackgroundModifier extends ComponentModifier
    with ChildModifier, DecorationModifier {
  final bool auto;
  final Background? background;

  const BackgroundModifier(
    this.background, {
    this.auto = false,
    super.condition,
  });

  @override
  Decoration? decorate(
    Decoration decoration,
    ComponentContext context,
  ) {
    if (background == null) {
      final color = context.colors.surface;
      return Background.color(color).decorate(
        decoration,
        context.build,
      );
    }

    return background?.decorate(
      decoration,
      context.build,
    );
  }

  @override
  Widget? modify(
    Widget? child,
    ComponentContext context,
  ) {
    return background?.modify(child, context);
  }
}

mixin ModifiableBackground<Type extends Component> on Component<Type> {
  Type background(Background? background, {ResponsiveCondition? condition}) {
    return withModifier(
      BackgroundModifier(
        background,
        auto: background == null,
        condition: condition,
      ),
    );
  }

  Type backgroundColor(Color color, {ResponsiveCondition? condition}) {
    return withModifier(
      BackgroundModifier(
        Background.color(color),
        condition: condition,
      ),
    );
  }

  Type backgroundImage(
    BackgroundImage image, {
    ResponsiveCondition? condition,
  }) {
    return withModifier(
      BackgroundModifier(
        Background.image(image),
        condition: condition,
      ),
    );
  }

  Type backgroundGradient(Gradient gradient, {ResponsiveCondition? condition}) {
    return withModifier(
      BackgroundModifier(
        Background.gradient(gradient),
        condition: condition,
      ),
    );
  }
}
