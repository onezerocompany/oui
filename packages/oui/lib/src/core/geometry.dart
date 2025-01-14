import 'package:flutter/rendering.dart' as rendering
    show Alignment, AlignmentGeometry, EdgeInsets, Offset, BoxFit;
import 'package:flutter/widgets.dart'
    show
        Align,
        AlignmentGeometry,
        BoxConstraints,
        ConstrainedBox,
        EdgeInsets,
        Padding,
        SizedBox,
        Widget;
import 'package:oui/src/core/app.dart';
import 'package:oui/src/core/screen.dart';

import 'component.dart';
import 'utils.dart';

/// Enum representing the flow direction within a container.
enum FlowDirection {
  /// Flow from top to bottom.
  topToBottom,

  /// Flow from bottom to top.
  bottomToTop,

  /// Flow from left to right.
  leftToRight,

  /// Flow from right to left.
  rightToLeft;

  /// Checks if the flow direction is horizontal.
  bool get isHorizontal {
    return this == FlowDirection.leftToRight ||
        this == FlowDirection.rightToLeft;
  }

  /// Checks if the flow direction is vertical.
  bool get isVertical {
    return this == FlowDirection.topToBottom ||
        this == FlowDirection.bottomToTop;
  }

  /// Checks if the flow direction is reversed.
  bool get isReversed {
    return this == FlowDirection.bottomToTop ||
        this == FlowDirection.rightToLeft;
  }

  Alignment get defaultAlignment {
    switch (this) {
      case FlowDirection.topToBottom:
        return Alignment.topLeft;
      case FlowDirection.bottomToTop:
        return Alignment.bottomLeft;
      case FlowDirection.leftToRight:
        return Alignment.topLeft;
      case FlowDirection.rightToLeft:
        return Alignment.topRight;
    }
  }

  /// Returns the alignment at the beginning of the flow direction.
  rendering.Alignment get begin {
    switch (this) {
      case FlowDirection.topToBottom:
        return rendering.Alignment.topCenter;
      case FlowDirection.bottomToTop:
        return rendering.Alignment.bottomCenter;
      case FlowDirection.leftToRight:
        return rendering.Alignment.centerLeft;
      case FlowDirection.rightToLeft:
        return rendering.Alignment.centerRight;
    }
  }

  /// Returns the alignment at the end of the flow direction.
  rendering.Alignment get end {
    switch (this) {
      case FlowDirection.topToBottom:
        return rendering.Alignment.bottomCenter;
      case FlowDirection.bottomToTop:
        return rendering.Alignment.topCenter;
      case FlowDirection.leftToRight:
        return rendering.Alignment.centerRight;
      case FlowDirection.rightToLeft:
        return rendering.Alignment.centerLeft;
    }
  }

  /// Returns the opposite flow direction.
  FlowDirection get opposite {
    switch (this) {
      case FlowDirection.topToBottom:
        return FlowDirection.bottomToTop;
      case FlowDirection.bottomToTop:
        return FlowDirection.topToBottom;
      case FlowDirection.leftToRight:
        return FlowDirection.rightToLeft;
      case FlowDirection.rightToLeft:
        return FlowDirection.leftToRight;
    }
  }
}

/// Enum representing the position within a container.
enum Position {
  /// Leading position (start).
  leading,

  /// Middle position (center).
  middle,

  /// Trailing position (end).
  trailing;

  /// Returns the opposite position.
  Position get opposite {
    switch (this) {
      case Position.leading:
        return Position.trailing;
      case Position.middle:
        return Position.middle;
      case Position.trailing:
        return Position.leading;
    }
  }
}

/// Class representing the alignment within a container.
class Alignment {
  /// The main position within the alignment.
  final Position main;

  /// The cross position within the alignment.
  final Position cross;

  /// The flow direction of the alignment.
  final FlowDirection direction;

  /// Creates an alignment with the given main position, cross position, and flow direction.
  const Alignment(
    this.main,
    this.cross, [
    this.direction = FlowDirection.leftToRight,
  ]);

  /// Predefined alignment for top-left.
  static const topLeft = Alignment(
    Position.leading,
    Position.leading,
  );

  /// Predefined alignment for top-center.
  static const topCenter = Alignment(
    Position.middle,
    Position.leading,
  );

  /// Predefined alignment for top-right.
  static const topRight = Alignment(
    Position.trailing,
    Position.leading,
  );

  /// Predefined alignment for center-left.
  static const centerLeft = Alignment(
    Position.leading,
    Position.middle,
  );

  /// Predefined alignment for center.
  static const center = Alignment(
    Position.middle,
    Position.middle,
  );

  /// Predefined alignment for center-right.
  static const centerRight = Alignment(
    Position.trailing,
    Position.middle,
  );

  /// Predefined alignment for bottom-left.
  static const bottomLeft = Alignment(
    Position.leading,
    Position.trailing,
  );

  /// Predefined alignment for bottom-center.
  static const bottomCenter = Alignment(
    Position.middle,
    Position.trailing,
  );

  /// Predefined alignment for bottom-right.
  static const bottomRight = Alignment(
    Position.trailing,
    Position.trailing,
  );

  /// Returns the opposite alignment.
  Alignment get opposite {
    return Alignment(
      main.opposite,
      cross.opposite,
      direction,
    );
  }

  /// Returns the flipped alignment.
  Alignment get flip {
    return Alignment(
      cross,
      main,
      direction.opposite,
    );
  }

  /// Converts the alignment to Flutter's [AlignmentGeometry].
  rendering.AlignmentGeometry get uiAlignment {
    return rendering.Alignment(
      main == Position.leading
          ? -1
          : main == Position.middle
              ? 0
              : 1,
      cross == Position.leading
          ? -1
          : cross == Position.middle
              ? 0
              : 1,
    );
  }
}

class AlignmentModifier extends ComponentModifier with ChildModifier {
  final Alignment alignment;

  const AlignmentModifier(this.alignment);

  @override
  Widget? modify(Widget? child, ComponentContext context) {
    if (child == null) return null;

    /// TODO: Use the new aligner component
    return Align(
      alignment: alignment.uiAlignment,
      child: child,
    );
  }
}

mixin ModifiableAlignment<Type extends Component> on Component<Type> {
  Type get centered => alignment(Alignment.center);

  Type alignment(Alignment alignment) {
    return withModifier(
      AlignmentModifier(alignment),
    );
  }
}

/// A class representing insets (padding or margins) for a box.
class Insets {
  /// The top inset value.
  final double top;

  /// The right inset value.
  final double right;

  /// The bottom inset value.
  final double bottom;

  /// The left inset value.
  final double left;

  /// Creates insets with the same value for all sides.
  ///
  /// [value] The value to be applied to all sides.
  const Insets.all(double value)
      : top = value,
        right = value,
        bottom = value,
        left = value;

  /// Creates insets with separate values for vertical and horizontal sides.
  ///
  /// [vertical] The value to be applied to the top and bottom sides.
  /// [horizontal] The value to be applied to the left and right sides.
  const Insets.symmetric({
    double vertical = 0,
    double horizontal = 0,
  })  : top = vertical,
        bottom = vertical,
        right = horizontal,
        left = horizontal;

  /// Creates insets with specific values for each side.
  ///
  /// [top] The value for the top side.
  /// [right] The value for the right side.
  /// [bottom] The value for the bottom side.
  /// [left] The value for the left side.
  const Insets.only({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  /// Creates a copy of this insets object with the given values replaced.
  ///
  /// [top] The new value for the top side.
  /// [right] The new value for the right side.
  /// [bottom] The new value for the bottom side.
  /// [left] The new value for the left side.
  ///
  /// Returns a new [Insets] object with the updated values.
  Insets copyWith({
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    return Insets.only(
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
    );
  }

  bool get shouldRender => top > 0 || right > 0 || bottom > 0 || left > 0;

  /// Adds the values of another [Insets] object to this one.
  ///
  /// [other] The other [Insets] object.
  ///
  /// Returns a new [Insets] object with the combined values.
  Insets operator +(Insets other) {
    return Insets.only(
      top: top + other.top,
      right: right + other.right,
      bottom: bottom + other.bottom,
      left: left + other.left,
    );
  }

  /// Subtracts the values of another [Insets] object from this one.
  ///
  /// [other] The other [Insets] object.
  ///
  /// Returns a new [Insets] object with the subtracted values.
  Insets operator -(Insets other) {
    return Insets.only(
      top: top - other.top,
      right: right - other.right,
      bottom: bottom - other.bottom,
      left: left - other.left,
    );
  }

  /// Multiplies the values of this [Insets] object by a factor.
  ///
  /// [factor] The factor to multiply by.
  ///
  /// Returns a new [Insets] object with the multiplied values.
  Insets operator *(double factor) {
    return Insets.only(
      top: top * factor,
      right: right * factor,
      bottom: bottom * factor,
      left: left * factor,
    );
  }

  /// Divides the values of this [Insets] object by a factor.
  ///
  /// [factor] The factor to divide by.
  ///
  /// Returns a new [Insets] object with the divided values.
  Insets operator /(double factor) {
    return Insets.only(
      top: top / factor,
      right: right / factor,
      bottom: bottom / factor,
      left: left / factor,
    );
  }

  /// Converts this [Insets] object to an [EdgeInsets] object.
  ///
  /// Returns an [EdgeInsets] object with the same values.
  rendering.EdgeInsets get edgeInsets => rendering.EdgeInsets.only(
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      );

  /// Returns a string representation of this [Insets] object.
  @override
  String toString() {
    return 'Insets(top: $top, right: $right, bottom: $bottom, left: $left)';
  }
}

/// A class representing insets (padding or margins) for a box and modifying a widget.
class InsetModifier extends ComponentModifier with ChildModifier {
  final Insets insets;

  const InsetModifier(this.insets);

  @override
  Widget? modify(Widget? child, ComponentContext context) {
    if (!insets.shouldRender || child == null) return null;

    return Padding(
      padding: insets.edgeInsets,
      child: child,
    );
  }

  @override
  String toString() {
    return 'InsetModifier(insets: $insets)';
  }
}

mixin ModifiableInset<Type extends Component> on Component<Type> {
  Type inset(Insets insets) {
    return withModifier(InsetModifier(insets));
  }
}

/// A class representing a 2D point with x and y coordinates.
///
/// The [Offset] class is immutable and provides a way to represent
/// a point in a 2D space. It also provides a method to convert to a
/// Flutter [Offset] object.
class Offset {
  /// The x-coordinate of the point.
  final double x;

  /// The y-coordinate of the point.
  final double y;

  /// Creates an [Offset] with the given x and y coordinates.
  ///
  /// Both [x] and [y] are required and must be non-null.
  const Offset({
    required this.x,
    required this.y,
  });

  /// A constant [Offset] representing the origin (0, 0).
  static const zero = Offset(x: 0, y: 0);

  /// Converts this [Offset] to a Flutter [Offset] object.
  ///
  /// This is useful when working with Flutter's painting and layout
  /// system, which uses the [Offset] class to represent 2D points.
  rendering.Offset get uiOffset => rendering.Offset(x, y);
}

/// A class representing a ranged dimension with a minimum and maximum value.
///
/// This class is useful for scenarios where you need to define a range of values,
/// such as in UI components, data validation, or any other context where a bounded
/// range is required.
///
/// Example usage:
///
/// ```dart
/// void main() {
///   RangedDimension dimension = RangedDimension.dynamic(minimum: 0, maximum: 100);
/// }
/// ```
///
/// In this example, a `RangedDimension` object is created with a minimum value of 0
/// and a maximum value of 100. The `inside` method is then used to check if
/// a given value falls within the specified range, and the `outside` method checks if
/// a value is outside the range.
class RangedDimension extends Range<double> {
  /// Weight of the dimension in a flexible layout.
  final int weight;

  /// Private constructor for creating a ranged dimension.
  const RangedDimension(
    super.start,
    super.end, {
    this.weight = 1,
  });

  /// A constant representing a range with both minimum and maximum set to zero.
  static const zero = RangedDimension(0, 0);

  /// A constant representing an infinite range.
  static const infinite = RangedDimension(
    double.negativeInfinity,
    double.infinity,
  );

  /// A constant representing a range from zero to infinity.
  static const zeroToInfinity = RangedDimension(0, double.infinity);

  /// Creates a fixed ranged dimension where minimum and maximum are the same.
  const RangedDimension.fixed(
    double value, [
    int weight = 1,
  ]) : this(value, value, weight: weight);

  /// Creates a dynamic ranged dimension with specified minimum and maximum values.
  const RangedDimension.dynamic({
    double minimum = 0,
    double maximum = double.infinity,
    int weight = 1,
  }) : this(minimum, maximum, weight: weight);

  @override
  String toString() {
    if (isUnbounded) {
      return 'RangedDimension.infinite';
    } else if (isFixed) {
      return 'RangedDimension.fixed($start)';
    } else {
      return 'RangedDimension.dynamic($start, $end)';
    }
  }
}

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

class SizeModifier extends ComponentModifier with ChildModifier {
  final Size? size;

  const SizeModifier(this.size);

  /// Creates a `BoxSize` with a fixed size.
  ///
  /// [width] - The fixed width value. Defaults to 0.
  /// [height] - The fixed height value. Defaults to 0.
  SizeModifier.fixed({
    double? width,
    double? height,
  }) : size = Size.fixed(width: width, height: height);

  /// Creates a `BoxSize` with a dynamic size.
  ///
  /// [minWidth] - The minimum width value. Defaults to 0.
  /// [maxWidth] - The maximum width value. Defaults to double.infinity.
  /// [minHeight] - The minimum height value. Defaults to 0.
  /// [maxHeight] - The maximum height value. Defaults to double.infinity.
  SizeModifier.dynamic({
    double minWidth = 0,
    double maxWidth = double.infinity,
    double minHeight = 0,
    double maxHeight = double.infinity,
  }) : size = Size.dynamic(
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
          maxHeight: maxHeight,
        );

  @override
  Widget modify(Widget? child, ComponentContext context) {
    if (child == null) return const SizedBox.shrink();
    if (size == null && context.componentType == Screen) {
      final config = context.buildContext.config.screens;
      if (config.defaultPanelWidth != null) {
        return Size(
          config.defaultPanelWidth!,
          RangedDimension.zeroToInfinity,
        ).apply(child);
      }
    }
    return size?.apply(child) ?? child;
  }
}

mixin ModifiableSize<Type extends Component> on Component<Type> {
  Type size(Size size) {
    return withModifier(SizeModifier(size));
  }

  Type fixedSize({
    double? width,
    double? height,
  }) {
    return withModifier(
      SizeModifier.fixed(
        width: width,
        height: height,
      ),
    );
  }

  Type dynamicSize({
    double minWidth = 0,
    double maxWidth = double.infinity,
    double minHeight = 0,
    double maxHeight = double.infinity,
  }) {
    return withModifier(
      SizeModifier.dynamic(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
    );
  }

  Size? get _currentSize {
    return modifiers.whereType<SizeModifier>().lastOrNull?.size;
  }

  RangedDimension? get width => _currentSize?.width;
  RangedDimension? get height => _currentSize?.height;
}

enum RectangleSide {
  top,
  right,
  bottom,
  left;

  RectangleSide get opposite {
    switch (this) {
      case RectangleSide.top:
        return RectangleSide.bottom;
      case RectangleSide.right:
        return RectangleSide.left;
      case RectangleSide.bottom:
        return RectangleSide.top;
      case RectangleSide.left:
        return RectangleSide.right;
    }
  }
}

typedef RectangleSides = Set<RectangleSide>;

extension RectangleSidesExtension on RectangleSides {
  static const RectangleSides all = {
    RectangleSide.top,
    RectangleSide.right,
    RectangleSide.bottom,
    RectangleSide.left,
  };
}

/// Enum representing different types of BoxFit options.
///
/// This enum provides various options for how an image should be fitted within a given box.
/// Each option corresponds to a specific way of scaling or positioning the image.
enum RectangleFit {
  /// Scales the image to cover the target box.
  ///
  /// The image is scaled to maintain its aspect ratio while ensuring that it completely covers the target box.
  /// This may result in some parts of the image being clipped.
  cover(rendering.BoxFit.cover),

  /// Scales the image to contain within the target box.
  ///
  /// The image is scaled to maintain its aspect ratio while ensuring that it fits entirely within the target box.
  /// This may result in empty space around the image.
  contain(rendering.BoxFit.contain),

  /// Stretches the image to fill the target box.
  ///
  /// The image is stretched to fill the entire target box, which may distort its aspect ratio.
  fill(rendering.BoxFit.fill),

  /// Scales the image to fit the width of the target box.
  ///
  /// The image is scaled to maintain its aspect ratio while ensuring that its width matches the width of the target box.
  /// This may result in some parts of the image being clipped vertically.
  fitWidth(rendering.BoxFit.fitWidth),

  /// Scales the image to fit the height of the target box.
  ///
  /// The image is scaled to maintain its aspect ratio while ensuring that its height matches the height of the target box.
  /// This may result in some parts of the image being clipped horizontally.
  fitHeight(rendering.BoxFit.fitHeight),

  /// Displays the image at its natural size.
  ///
  /// The image is displayed at its original size, without any scaling.
  /// This may result in the image being clipped if it is larger than the target box.
  none(rendering.BoxFit.none),

  /// Scales the image down to fit within the target box.
  ///
  /// The image is scaled down to maintain its aspect ratio while ensuring that it fits entirely within the target box.
  /// If the image is smaller than the target box, it is not scaled up.
  scaleDown(rendering.BoxFit.scaleDown);

  /// The BoxFit value associated with this enum.
  final rendering.BoxFit boxFit;

  /// Constructor for the BoxFit enum.
  ///
  /// Associates a BoxFit value with each enum value.
  const RectangleFit(this.boxFit);
}
