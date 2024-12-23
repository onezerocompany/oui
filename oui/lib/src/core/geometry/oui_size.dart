import 'package:oui/oui.dart';

/// A class representing a size with width and height dimensions.
///
/// The `OuiSize` class allows you to define fixed or dynamic sizes for UI components.
///
/// Example usage:
///
/// ```dart
/// // Creating a fixed size
/// OuiSize fixedSize = OuiSize.fixed(width: 100, height: 200);
///
/// // Creating a dynamic size
/// OuiSize dynamicSize = OuiSize.dynamic(
///   minWidth: 50,
///   maxWidth: 150,
///   minHeight: 100,
///   maxHeight: 300,
/// );
/// ```
class OuiSize {
  /// The width dimension of the size.
  final OuiRangedDimension width;

  /// The height dimension of the size.
  final OuiRangedDimension height;

  /// Creates an instance of `OuiSize` with the given width and height dimensions.
  const OuiSize({
    required this.width,
    required this.height,
  });

  /// Creates a fixed size with the specified width and height.
  ///
  /// The width and height are set to fixed values.
  ///
  /// [width] - The fixed width value. Defaults to 0.
  /// [height] - The fixed height value. Defaults to 0.
  factory OuiSize.fixed({
    double width = 0,
    double height = 0,
  }) {
    return OuiSize(
      width: OuiRangedDimension.fixed(width),
      height: OuiRangedDimension.fixed(height),
    );
  }

  /// Creates a dynamic size with the specified minimum and maximum width and height.
  ///
  /// The width and height can vary between the specified minimum and maximum values.
  ///
  /// [minWidth] - The minimum width value. Defaults to 0.
  /// [maxWidth] - The maximum width value. Defaults to double.infinity.
  /// [minHeight] - The minimum height value. Defaults to 0.
  /// [maxHeight] - The maximum height value. Defaults to double.infinity.
  factory OuiSize.dynamic({
    double minWidth = 0,
    double maxWidth = double.infinity,
    double minHeight = 0,
    double maxHeight = double.infinity,
  }) {
    return OuiSize(
      width: OuiRangedDimension.dynamic(
        minimum: minWidth,
        maximum: maxWidth,
      ),
      height: OuiRangedDimension.dynamic(
        minimum: minHeight,
        maximum: maxHeight,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is OuiSize && other.width == width && other.height == height;
  }

  @override
  int get hashCode => Object.hash(width, height);

  @override
  String toString() {
    return 'OuiSize(width: $width, height: $height)';
  }
}
