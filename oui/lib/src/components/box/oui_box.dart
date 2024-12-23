import 'package:flutter/widgets.dart';

import '../../core/geometry/oui_size.dart';
import '../corners/oui_corner_border_radius.dart';
import '../corners/oui_corner_clip.dart';
import 'oui_alignment.dart';
import 'oui_background.dart';
import 'oui_border.dart';
import 'oui_insets.dart';
import 'oui_shadow.dart';

/// A custom box widget that allows for extensive styling options.
///
/// The [OuiBox] widget provides a flexible container with various styling
/// options such as background, corner radius, shadow, border, padding, and
/// alignment. It can be used to create complex UI elements with ease.
class OuiBox extends StatelessWidget {
  /// The child widget to be displayed inside the box.
  final Widget? child;

  /// The background styling for the box.
  final OuiBackground? background;

  /// The corner radius for the box.
  final OuiCornerBorderRadius? corner;

  /// The shadow styling for the box.
  final OuiShadow? shadow;

  /// The border styling for the box.
  final OuiBorder? border;

  /// The padding inside the box.
  final OuiInsets? padding;

  /// The alignment of the child widget inside the box.
  final OuiAlignment? alignment;

  /// The size of the box.
  final OuiSize? size;

  /// Creates a new [OuiBox] widget.
  ///
  /// All parameters are optional and can be used to customize the appearance
  /// of the box.
  const OuiBox({
    super.key,
    this.child,
    this.background,
    this.shadow,
    this.corner,
    this.padding,
    this.border,
    this.alignment,
    this.size, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration();

    Widget? content = child;

    // Align the child widget if alignment is provided.
    if (alignment != null) {
      content = Align(
        alignment: alignment!.flutterAlignment,
        child: content,
      );
    }

    // Apply various styles to the decoration.
    corner?.apply(decoration);
    shadow?.apply(decoration);
    border?.apply(decoration);
    padding?.apply(decoration);
    background?.apply(decoration);

    // Handle custom background rendering with corner clipping if necessary.
    if (background?.custom != null) {
      var background = this.background!.custom!;
      if (corner?.shouldRender == true) {
        background = ClipOuiCornerRect(
          radius: corner!,
          child: background,
        );
      }

      content = Stack(
        children: [
          background,
          if (content != null) content,
        ],
      );
    }

    // Return the decorated box with the child content.
    return DecoratedBox(
      decoration: decoration,
      child: content,
    );
  }
}
