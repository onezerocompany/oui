enum OuiSide {
  leading,
  middle,
  trailing,
}

enum OuiFlowDirection {
  topToBottom,
  bottomToTop,
  leftToRight,
  rightToLeft;

  bool get isHorizontal {
    return this == OuiFlowDirection.leftToRight ||
        this == OuiFlowDirection.rightToLeft;
  }

  bool get isVertical {
    return this == OuiFlowDirection.topToBottom ||
        this == OuiFlowDirection.bottomToTop;
  }
}

class OuiAlignment {
  final OuiSide side;
  final OuiFlowDirection direction;

  const OuiAlignment(this.side, this.direction);
}

enum OuiRectSide {
  top(OuiSide.leading, OuiFlowDirection.topToBottom),
  bottom(OuiSide.trailing, OuiFlowDirection.topToBottom),
  left(OuiSide.leading, OuiFlowDirection.leftToRight),
  right(OuiSide.trailing, OuiFlowDirection.leftToRight);

  static const horizontal = [left, right];
  static const vertical = [top, bottom];
  static const all = [top, bottom, left, right];

  OuiRectSide get opposite {
    switch (this) {
      case top:
        return bottom;
      case bottom:
        return top;
      case left:
        return right;
      case right:
        return left;
    }
  }

  final OuiSide side;
  final OuiFlowDirection direction;

  const OuiRectSide(this.side, this.direction);
}
