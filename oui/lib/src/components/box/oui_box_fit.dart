import 'package:flutter/widgets.dart';

/// Enum representing different types of BoxFit options.
///
/// This enum provides various options for how an image should be fitted within a given box.
/// Each option corresponds to a specific way of scaling or positioning the image.
enum OuiBoxFit {
  /// Scales the image to cover the target box.
  ///
  /// The image is scaled to maintain its aspect ratio while ensuring that it completely covers the target box.
  /// This may result in some parts of the image being clipped.
  cover(BoxFit.cover),

  /// Scales the image to contain within the target box.
  ///
  /// The image is scaled to maintain its aspect ratio while ensuring that it fits entirely within the target box.
  /// This may result in empty space around the image.
  contain(BoxFit.contain),

  /// Stretches the image to fill the target box.
  ///
  /// The image is stretched to fill the entire target box, which may distort its aspect ratio.
  fill(BoxFit.fill),

  /// Scales the image to fit the width of the target box.
  ///
  /// The image is scaled to maintain its aspect ratio while ensuring that its width matches the width of the target box.
  /// This may result in some parts of the image being clipped vertically.
  fitWidth(BoxFit.fitWidth),

  /// Scales the image to fit the height of the target box.
  ///
  /// The image is scaled to maintain its aspect ratio while ensuring that its height matches the height of the target box.
  /// This may result in some parts of the image being clipped horizontally.
  fitHeight(BoxFit.fitHeight),

  /// Displays the image at its natural size.
  ///
  /// The image is displayed at its original size, without any scaling.
  /// This may result in the image being clipped if it is larger than the target box.
  none(BoxFit.none),

  /// Scales the image down to fit within the target box.
  ///
  /// The image is scaled down to maintain its aspect ratio while ensuring that it fits entirely within the target box.
  /// If the image is smaller than the target box, it is not scaled up.
  scaleDown(BoxFit.scaleDown);

  /// The BoxFit value associated with this enum.
  final BoxFit boxFit;

  /// Constructor for the OuiBoxFit enum.
  ///
  /// Associates a BoxFit value with each enum value.
  const OuiBoxFit(this.boxFit);
}
