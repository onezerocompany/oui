import 'package:flutter/widgets.dart'
    show BoxConstraints, ConstrainedBox, SizedBox, Widget;

import 'ranged_dimension.dart';

/// A class representing a size with width and height dimensions.
///
/// The `Size` class allows you to define fixed or dynamic sizes for UI components.
///
/// Example usage:
///
/// ```dart
/// // Creating a fixed size
/// Size fixedSize = Size.fixed(width: 100, height: 200);
///
/// // Creating a dynamic size
/// Size dynamicSize = Size.dynamic(
///   minWidth: 50,
///   maxWidth: 150,
///   minHeight: 100,
///   maxHeight: 300,
/// );
/// ```
class Size {
  /// The width dimension of the size.
  final RangedDimension width;

  /// The height dimension of the size.
  final RangedDimension height;

  /// Creates an instance of `Size` with the given width and height dimensions.
  const Size(
    this.width,
    this.height,
  );

  static const Size zero = Size(
    RangedDimension.fixed(0),
    RangedDimension.fixed(0),
  );

  static const Size infinite = Size(
    RangedDimension.zeroToInfinity,
    RangedDimension.zeroToInfinity,
  );

  /// Creates a fixed size with the specified width and height.
  ///
  /// The width and height are set to fixed values.
  ///
  /// [width] - The fixed width value. Defaults to 0.
  /// [height] - The fixed height value. Defaults to 0.
  Size.fixed({
    double? width,
    double? height,
  }) : this(
          width != null
              ? RangedDimension.fixed(width)
              : RangedDimension.zeroToInfinity,
          height != null
              ? RangedDimension.fixed(height)
              : RangedDimension.zeroToInfinity,
        );

  /// Creates a dynamic size with the specified minimum and maximum width and height.
  ///
  /// The width and height can vary between the specified minimum and maximum values.
  ///
  /// [minWidth] - The minimum width value. Defaults to 0.
  /// [maxWidth] - The maximum width value. Defaults to double.infinity.
  /// [minHeight] - The minimum height value. Defaults to 0.
  /// [maxHeight] - The maximum height value. Defaults to double.infinity.
  Size.dynamic({
    double minWidth = 0,
    double maxWidth = double.infinity,
    double minHeight = 0,
    double maxHeight = double.infinity,
  }) : this(
          RangedDimension.dynamic(
            minimum: minWidth,
            maximum: maxWidth,
          ),
          RangedDimension.dynamic(
            minimum: minHeight,
            maximum: maxHeight,
          ),
        );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Size && other.width == width && other.height == height;
  }

  @override
  int get hashCode => Object.hash(width, height);

  /// Whether the size is a fixed size.
  bool get isFixed => width.isFixed && height.isFixed;

  bool get shouldRender => width.start > 0 && height.start > 0;

  Widget apply(Widget? child) {
    if (isFixed) {
      return SizedBox(
        width: width.start,
        height: height.start,
        child: child,
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width.start,
          maxWidth: width.end,
          minHeight: height.start,
          maxHeight: height.end,
        ),
        child: child,
      );
    }
  }

  @override
  String toString() {
    return 'Size(width: $width, height: $height)';
  }
}
