import 'package:oui/src/components/box/box_modifier.dart';

import '../../../core/geometry/size.dart';

class BoxSize extends BoxModifier {
  final Size size;

  const BoxSize(this.size);

  /// Creates a `BoxSize` with a fixed size.
  ///
  /// [width] - The fixed width value. Defaults to 0.
  /// [height] - The fixed height value. Defaults to 0.
  BoxSize.fixed({
    double? width,
    double? height,
  }) : size = Size.fixed(width: width, height: height);

  /// Creates a `BoxSize` with a dynamic size.
  ///
  /// [minWidth] - The minimum width value. Defaults to 0.
  /// [maxWidth] - The maximum width value. Defaults to double.infinity.
  /// [minHeight] - The minimum height value. Defaults to 0.
  /// [maxHeight] - The maximum height value. Defaults to double.infinity.
  BoxSize.dynamic({
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
  void modify(BoxModifierContext context) {
    // Do not modify here, this modifier is applied in the Box widget
  }
}
