enum BoxSide {
  top,
  right,
  bottom,
  left;

  BoxSide get opposite {
    switch (this) {
      case BoxSide.top:
        return BoxSide.bottom;
      case BoxSide.right:
        return BoxSide.left;
      case BoxSide.bottom:
        return BoxSide.top;
      case BoxSide.left:
        return BoxSide.right;
    }
  }
}
