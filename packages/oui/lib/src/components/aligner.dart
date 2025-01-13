import 'dart:math';

import 'package:flutter/widgets.dart'
    show
        Align,
        BuildContext,
        Flow,
        FlowDelegate,
        FlowPaintingContext,
        Matrix4,
        StatelessWidget,
        Widget;

import '../core/geometry.dart';

class Aligner extends StatelessWidget {
  final List<Widget> children;
  final Alignment alignment;
  final FlowDirection flowDirection;
  final bool scrollable;

  const Aligner({
    super.key,
    required this.children,
    this.alignment = Alignment.center,
    this.flowDirection = FlowDirection.leftToRight,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment.uiAlignment,
      child: Flow(
        delegate: AlignerDelegate(flowDirection),
        children: children,
      ),
    );
  }
}

class AlignerDelegate extends FlowDelegate {
  final FlowDirection flowDirection;
  final Alignment alignment;
  final int maxLines;

  const AlignerDelegate(
    this.flowDirection, [
    this.alignment = Alignment.center,
    this.maxLines = 1,
  ]);

  @override
  void paintChildren(FlowPaintingContext context) {
    double x = flowDirection.isReversed && flowDirection.isHorizontal
        ? context.size.width
        : 0.0;
    double y = flowDirection.isReversed && flowDirection.isVertical
        ? context.size.height
        : 0.0;
    double maxWidth = 0.0;
    double maxHeight = 0.0;
    int currentLine = 1;

    for (var i = 0; i < context.childCount; i++) {
      final childSize = context.getChildSize(i);
      if (childSize == null) continue;

      final overflow = flowDirection.isHorizontal
          ? x + childSize.width > context.size.width
          : y + childSize.height > context.size.height;

      if (overflow) {
        currentLine++;
        if (currentLine > maxLines) break;

        if (flowDirection.isHorizontal) {
          x = flowDirection.isReversed ? context.size.width : 0.0;
          y += maxHeight;
          maxHeight = 0.0;
        } else {
          y = flowDirection.isReversed ? context.size.height : 0.0;
          x += maxWidth;
          maxWidth = 0.0;
        }
      }

      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          x -
              (flowDirection.isReversed && flowDirection.isHorizontal
                  ? childSize.width
                  : 0.0),
          y -
              (flowDirection.isReversed && flowDirection.isVertical
                  ? childSize.height
                  : 0.0),
          0.0,
        ),
      );

      if (flowDirection.isHorizontal) {
        x += flowDirection.isReversed ? -childSize.width : childSize.width;
        maxHeight = max(maxHeight, childSize.height);
      } else {
        y += flowDirection.isReversed ? -childSize.height : childSize.height;
        maxWidth = max(maxWidth, childSize.width);
      }
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return oldDelegate is! AlignerDelegate ||
        oldDelegate.flowDirection != flowDirection ||
        oldDelegate.maxLines != maxLines;
  }
}
