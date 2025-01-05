enum RectangleSide {
  top,
  right,
  bottom,
  left;

  RectangleSide get opposite {
    switch (this) {
      case RectangleSide.top:
        return RectangleSide.bottom;
      case RectangleSide.right:
        return RectangleSide.left;
      case RectangleSide.bottom:
        return RectangleSide.top;
      case RectangleSide.left:
        return RectangleSide.right;
    }
  }
}
