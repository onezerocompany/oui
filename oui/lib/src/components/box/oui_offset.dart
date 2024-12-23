import 'dart:ui';

/// A class representing a 2D point with x and y coordinates.
///
/// The [OuiOffset] class is immutable and provides a way to represent
/// a point in a 2D space. It also provides a method to convert to a
/// Flutter [Offset] object.
class OuiOffset {
  /// The x-coordinate of the point.
  final double x;

  /// The y-coordinate of the point.
  final double y;

  /// Creates an [OuiOffset] with the given x and y coordinates.
  ///
  /// Both [x] and [y] are required and must be non-null.
  const OuiOffset({
    required this.x,
    required this.y,
  });

  /// A constant [OuiOffset] representing the origin (0, 0).
  static const zero = OuiOffset(x: 0, y: 0);

  /// Converts this [OuiOffset] to a Flutter [Offset] object.
  ///
  /// This is useful when working with Flutter's painting and layout
  /// system, which uses the [Offset] class to represent 2D points.
  Offset get flutterOffset => Offset(x, y);
}
