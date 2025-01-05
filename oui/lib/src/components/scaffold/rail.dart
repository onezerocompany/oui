import 'package:flutter/rendering.dart' show CrossAxisAlignment;
import 'package:flutter/widgets.dart'
    show BuildContext, Column, Flexible, Row, StatelessWidget, Widget;

import '../../core/geometry/rectangle_side.dart';
import '../borders/border_side.dart';
import '../box/box.dart';

enum RailContainerStyle {
  // The rails on the sides reach the top and bottom of the container.
  fullHeight,

  // The rails on the top and bottom reach the sides of the container.
  fullWidth,
}

class Rail extends StatelessWidget {
  final RectangleSide side;

  const Rail(
    this.side, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Box().borderForSide(
      side.opposite,
      BorderSide.none,
    );
  }
}

class RailedContainer extends StatelessWidget {
  final Widget child;
  final RailContainerStyle style;

  const RailedContainer({
    super.key,
    required this.child,
    this.style = RailContainerStyle.fullHeight,
  });

  @override
  Widget build(BuildContext context) {
    Column addHorizontalRails(Widget content) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Rail(RectangleSide.top),
          Flexible(
            child: content,
          ),
          const Rail(RectangleSide.bottom),
        ],
      );
    }

    Row addVerticalRails(Widget content) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Rail(RectangleSide.left),
          Flexible(
            child: content,
          ),
          const Rail(RectangleSide.right),
        ],
      );
    }

    switch (style) {
      case RailContainerStyle.fullHeight:
        return addVerticalRails(
          addHorizontalRails(child),
        );
      case RailContainerStyle.fullWidth:
        return addHorizontalRails(
          addVerticalRails(child),
        );
    }
  }
}
