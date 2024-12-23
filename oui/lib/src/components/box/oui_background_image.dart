import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';

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
/// OuiBackgroundRepeat backgroundRepeat = OuiBackgroundRepeat.repeat;
/// print(backgroundRepeat.imageRepeat); // Output: ImageRepeat.repeat
/// ```
///
/// This can be useful when you need to specify how a background image should be repeated
/// in a custom UI component.
enum OuiBackgroundRepeat {
  noRepeat(ImageRepeat.noRepeat),
  repeat(ImageRepeat.repeat),
  repeatX(ImageRepeat.repeatX),
  repeatY(ImageRepeat.repeatY);

  final ImageRepeat imageRepeat;
  const OuiBackgroundRepeat(this.imageRepeat);
}

/// A class that represents a background image with various properties
/// such as alignment, repeat behavior, fit, opacity, and scale.
class OuiBackgroundImage {
  /// The image to be used as the background.
  final Image image;

  /// The alignment of the background image.
  /// Defaults to [OuiAlignment.center].
  final OuiAlignment alignment;

  /// The repeat behavior of the background image.
  /// Defaults to [OuiBackgroundRepeat.noRepeat].
  final OuiBackgroundRepeat repeat;

  /// How the image should be inscribed into the box.
  /// Defaults to [OuiBoxFit.cover].
  final OuiBoxFit fit;

  /// The opacity of the background image.
  /// Defaults to 1 (fully opaque).
  final double opacity;

  /// The scale of the background image.
  /// Defaults to 1 (no scaling).
  final double scale;

  /// Creates a [OuiBackgroundImage] with the given properties.
  ///
  /// All properties are optional except for [image].
  const OuiBackgroundImage({
    required this.image,
    this.alignment = OuiAlignment.center,
    this.repeat = OuiBackgroundRepeat.noRepeat,
    this.fit = OuiBoxFit.cover,
    this.opacity = 1,
    this.scale = 1,
  });

  /// Applies the background image properties to a given [BoxDecoration].
  ///
  /// Returns a new [BoxDecoration] with the background image applied.
  BoxDecoration apply(BoxDecoration decoration) {
    return decoration.copyWith(
      image: DecorationImage(
        image: image.image,
        alignment: alignment.flutterAlignment,
        repeat: repeat.imageRepeat,
        fit: BoxFit.cover,
        opacity: opacity,
        scale: scale,
      ),
    );
  }
}
