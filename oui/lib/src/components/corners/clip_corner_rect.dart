import 'package:flutter/widgets.dart'
    show BuildContext, Clip, ClipPath, StatelessWidget, Widget;

import 'corner_border.dart';
import 'corner_border_radius.dart';

/// A widget that clips its child using a custom corner border shape.
class ClipCornerRect extends StatelessWidget {
  /// Creates a widget that clips its child using a custom corner border shape.
  ///
  /// The [child] parameter must not be null.
  /// The [radius] parameter defaults to [CornerBorderRadius.zero].
  /// The [clipBehavior] parameter defaults to [Clip.antiAlias].
  const ClipCornerRect({
    super.key,
    this.child,
    this.radius = CornerBorderRadius.zero,
    this.clipBehavior = Clip.antiAlias,
  });

  /// The radius of the corners.
  ///
  /// Defaults to [CornerBorderRadius.zero].
  final CornerBorderRadius radius;

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
      shape: CornerBorder(
        borderRadius: radius,
      ),
      child: child,
    );
  }
}
