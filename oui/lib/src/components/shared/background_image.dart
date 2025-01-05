import 'package:flutter/painting.dart'
    show DecorationImage, ImageProvider, ImageRepeat;

import '../../core/geometry/alignment.dart';
import '../box/box_fit.dart';

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
  final BoxFit fit;

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
    this.fit = BoxFit.cover,
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
