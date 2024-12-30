import 'package:flutter/rendering.dart' show CrossAxisAlignment;
import 'package:flutter/widgets.dart'
    show BuildContext, Column, Flexible, Row, StatelessWidget, Widget;

import '../box/box.dart';
import '../box/box_side.dart';
import '../box/modifiers/border.dart';

enum RailContainerStyle {
  // The rails on the sides reach the top and bottom of the container.
  fullHeight,

  // The rails on the top and bottom reach the sides of the container.
  fullWidth,
}

class Rail extends StatelessWidget {
  final BoxSide side;

  const Rail(
    this.side, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Box().border(
      Border.forBoxSide(
        side.opposite,
        BorderSide.none,
      ),
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
          const Rail(BoxSide.top),
          Flexible(
            child: content,
          ),
          const Rail(BoxSide.bottom),
        ],
      );
    }

    Row addVerticalRails(Widget content) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Rail(BoxSide.left),
          Flexible(
            child: content,
          ),
          const Rail(BoxSide.right),
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
