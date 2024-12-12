import 'package:oui/oui.dart';

/// A class that defines the border properties for Oui components.
class OuiBorder {
  /// A border with no thickness and a transparent color.
  static const none = OuiBorder(thickness: 0, color: Color(0x00000000));

  /// The thickness of the border.
  final double thickness;

  /// The color of the border.
  final Color color;

  /// Creates a border with the given [thickness] and [color].
  const OuiBorder({
    this.thickness = 1.0,
    required this.color,
  });

  /// Whether the border should be rendered.
  bool get shouldRender => thickness > 0 && color.alpha > 0;

  /// Returns a [BorderSide] if the border should be rendered, otherwise null.
  BorderSide? get borderSide =>
      shouldRender ? BorderSide(width: thickness, color: color) : null;

  /// Returns a [Border] for the given [sides].
  ///
  /// If no sides are specified, all sides will be used.
  Border? borderFor([List<OuiRectSide> sides = OuiRectSide.all]) {
    final borderSide = this.borderSide;
    if (borderSide == null) {
      return null;
    }

    return Border(
      top: sides.contains(OuiRectSide.top) ? borderSide : BorderSide.none,
      bottom: sides.contains(OuiRectSide.bottom) ? borderSide : BorderSide.none,
      left: sides.contains(OuiRectSide.left) ? borderSide : BorderSide.none,
      right: sides.contains(OuiRectSide.right) ? borderSide : BorderSide.none,
    );
  }
}
