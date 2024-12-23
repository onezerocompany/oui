import 'package:flutter/widgets.dart';

import 'oui_corner_border.dart';
import 'oui_corner_border_radius.dart';

/// A widget that clips its child using a custom corner border shape.
class ClipOuiCornerRect extends StatelessWidget {
  /// Creates a widget that clips its child using a custom corner border shape.
  ///
  /// The [child] parameter must not be null.
  /// The [radius] parameter defaults to [OuiCornerBorderRadius.zero].
  /// The [clipBehavior] parameter defaults to [Clip.antiAlias].
  const ClipOuiCornerRect({
    super.key,
    this.child,
    this.radius = OuiCornerBorderRadius.zero,
    this.clipBehavior = Clip.antiAlias,
  });

  /// The radius of the corners.
  ///
  /// Defaults to [OuiCornerBorderRadius.zero].
  final OuiCornerBorderRadius radius;

  /// The clip behavior to use when clipping.
  ///
  /// Defaults to [Clip.antiAlias].
  final Clip clipBehavior;

  /// The widget below this widget in the tree.
  ///
  /// This widget can be null.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath.shape(
      clipBehavior: clipBehavior,
      shape: OuiCornerBorder(
        borderRadius: radius,
      ),
      child: child,
    );
  }
}
