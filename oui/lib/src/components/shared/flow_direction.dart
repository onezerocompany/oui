import 'package:flutter/rendering.dart' as rendering;

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
