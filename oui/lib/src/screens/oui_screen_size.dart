/// Represents a screen size dimension with a minimum and maximum width, and a weight.
///
/// The [OuiScreenSizeDimension] class is used to define a range of screen widths
/// and assign a weight to that range. This can be useful for responsive design
/// calculations.
///
/// Example:
/// ```dart
/// const dimension = OuiScreenSizeDimension(
///   minimum: 320,
///   maximum: 1024,
///   weight: 2,
/// );
/// ```
///
/// The default values are:
/// - `minimum`: 300
/// - `maximum`: 1400
/// - `weight`: 1
class OuiScreenSizeDimension {
  /// The minimum width of the screen size dimension.
  final double minimum;

  /// The maximum width of the screen size dimension.
  final double maximum;

  /// The weight assigned to this screen size dimension.
  final int weight;

  /// Creates a new [OuiScreenSizeDimension] with the given [minimum], [maximum], and [weight].
  ///
  /// Example:
  /// ```dart
  /// const dimension = OuiScreenSizeDimension(
  ///   minimum: 320,
  ///   maximum: 1024,
  ///   weight: 2,
  /// );
  /// ```
  const OuiScreenSizeDimension({
    this.minimum = 300,
    this.maximum = 1400,
    this.weight = 1,
  }) : assert(minimum <= maximum,
            'minimum must be less than or equal to maximum');

  /// Checks if the given [width] is within the range defined by [minimum] and [maximum].
  ///
  /// Returns `true` if the [width] is within the range, otherwise `false`.
  bool contains(double width) {
    return width >= minimum && width <= maximum;
  }
}

/// A class representing the screen size with width and height dimensions.
///
/// The [OuiScreenSize] class holds the width and height dimensions of a screen.
class OuiScreenSize {
  final OuiScreenSizeDimension width;
  final OuiScreenSizeDimension height;

  /// Creates a new [OuiScreenSize] with the given [width] and [height] dimensions.
  ///
  /// Example usage:
  /// ```dart
  /// final screenSize = OuiScreenSize(
  ///   width: OuiScreenSizeDimension(minimum: 1080, maximum: 1920),
  ///   height: OuiScreenSizeDimension(minimum: 1080, maximum: 1920),
  /// );
  /// ```
  ///
  /// The default constructor initializes both width and height to default [OuiScreenSizeDimension].
  ///
  /// Example usage with default dimensions:
  /// ```dart
  /// final defaultScreenSize = OuiScreenSize();
  /// ```
  const OuiScreenSize({
    this.width = const OuiScreenSizeDimension(),
    this.height = const OuiScreenSizeDimension(),
  });
}
