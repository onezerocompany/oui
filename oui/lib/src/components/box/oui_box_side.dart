enum OuiBoxSide {
  top,
  right,
  bottom,
  left;

  OuiBoxSide get opposite {
    switch (this) {
      case OuiBoxSide.top:
        return OuiBoxSide.bottom;
      case OuiBoxSide.right:
        return OuiBoxSide.left;
      case OuiBoxSide.bottom:
        return OuiBoxSide.top;
      case OuiBoxSide.left:
        return OuiBoxSide.right;
    }
  }
}
