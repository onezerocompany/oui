import 'package:flutter/rendering.dart';

/// Enum representing the position within a container.
enum OuiPosition {
  /// Leading position (start).
  leading,

  /// Middle position (center).
  middle,

  /// Trailing position (end).
  trailing;

  /// Returns the opposite position.
  OuiPosition get opposite {
    switch (this) {
      case OuiPosition.leading:
        return OuiPosition.trailing;
      case OuiPosition.middle:
        return OuiPosition.middle;
      case OuiPosition.trailing:
        return OuiPosition.leading;
    }
  }
}

/// Enum representing the flow direction within a container.
enum OuiFlowDirection {
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
    return this == OuiFlowDirection.leftToRight ||
        this == OuiFlowDirection.rightToLeft;
  }

  /// Checks if the flow direction is vertical.
  bool get isVertical {
    return this == OuiFlowDirection.topToBottom ||
        this == OuiFlowDirection.bottomToTop;
  }

  /// Returns the alignment at the beginning of the flow direction.
  Alignment get begin {
    switch (this) {
      case OuiFlowDirection.topToBottom:
        return Alignment.topCenter;
      case OuiFlowDirection.bottomToTop:
        return Alignment.bottomCenter;
      case OuiFlowDirection.leftToRight:
        return Alignment.centerLeft;
      case OuiFlowDirection.rightToLeft:
        return Alignment.centerRight;
    }
  }

  /// Returns the alignment at the end of the flow direction.
  Alignment get end {
    switch (this) {
      case OuiFlowDirection.topToBottom:
        return Alignment.bottomCenter;
      case OuiFlowDirection.bottomToTop:
        return Alignment.topCenter;
      case OuiFlowDirection.leftToRight:
        return Alignment.centerRight;
      case OuiFlowDirection.rightToLeft:
        return Alignment.centerLeft;
    }
  }

  /// Returns the opposite flow direction.
  OuiFlowDirection get opposite {
    switch (this) {
      case OuiFlowDirection.topToBottom:
        return OuiFlowDirection.bottomToTop;
      case OuiFlowDirection.bottomToTop:
        return OuiFlowDirection.topToBottom;
      case OuiFlowDirection.leftToRight:
        return OuiFlowDirection.rightToLeft;
      case OuiFlowDirection.rightToLeft:
        return OuiFlowDirection.leftToRight;
    }
  }
}

/// Class representing the alignment within a container.
class OuiAlignment {
  /// The main position within the alignment.
  final OuiPosition main;

  /// The cross position within the alignment.
  final OuiPosition cross;

  /// The flow direction of the alignment.
  final OuiFlowDirection direction;

  /// Creates an alignment with the given main position, cross position, and flow direction.
  const OuiAlignment(
    this.main,
    this.cross, [
    this.direction = OuiFlowDirection.leftToRight,
  ]);

  /// Predefined alignment for top-left.
  static const topLeft = OuiAlignment(
    OuiPosition.leading,
    OuiPosition.leading,
  );

  /// Predefined alignment for top-center.
  static const topCenter = OuiAlignment(
    OuiPosition.middle,
    OuiPosition.leading,
  );

  /// Predefined alignment for top-right.
  static const topRight = OuiAlignment(
    OuiPosition.trailing,
    OuiPosition.leading,
  );

  /// Predefined alignment for center-left.
  static const centerLeft = OuiAlignment(
    OuiPosition.leading,
    OuiPosition.middle,
  );

  /// Predefined alignment for center.
  static const center = OuiAlignment(
    OuiPosition.middle,
    OuiPosition.middle,
  );

  /// Predefined alignment for center-right.
  static const centerRight = OuiAlignment(
    OuiPosition.trailing,
    OuiPosition.middle,
  );

  /// Predefined alignment for bottom-left.
  static const bottomLeft = OuiAlignment(
    OuiPosition.leading,
    OuiPosition.trailing,
  );

  /// Predefined alignment for bottom-center.
  static const bottomCenter = OuiAlignment(
    OuiPosition.middle,
    OuiPosition.trailing,
  );

  /// Predefined alignment for bottom-right.
  static const bottomRight = OuiAlignment(
    OuiPosition.trailing,
    OuiPosition.trailing,
  );

  /// Returns the opposite alignment.
  OuiAlignment get opposite {
    return OuiAlignment(
      main.opposite,
      cross.opposite,
      direction,
    );
  }

  /// Returns the flipped alignment.
  OuiAlignment get flip {
    return OuiAlignment(
      cross,
      main,
      direction.opposite,
    );
  }

  /// Converts the alignment to Flutter's [AlignmentGeometry].
  AlignmentGeometry get flutterAlignment {
    return Alignment(
      direction.begin.x +
          (main == OuiPosition.middle
              ? 0
              : main == OuiPosition.trailing
                  ? 0.5
                  : -0.5),
      direction.begin.y +
          (cross == OuiPosition.middle
              ? 0
              : cross == OuiPosition.trailing
                  ? 0.5
                  : -0.5),
    );
  }
}
