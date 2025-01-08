import 'package:flutter/widgets.dart' show Widget;
import 'package:oui/oui.dart';

class SizeModifier extends Modifier with ChildModifier {
  final Size size;

  const SizeModifier(this.size);

  @override
  bool get postDecoration => true;

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
  Widget modify(Widget child, ModifierContext context) {
    return size.apply(child);
  }
}

mixin ModifiableSize<Component extends Modifiable> on Modifiable<Component> {
  Component size(Size size) {
    return withModifier(SizeModifier(size));
  }

  Component fixedSize({
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

  Component dynamicSize({
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
