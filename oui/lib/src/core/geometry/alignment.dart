import 'package:flutter/rendering.dart' as rendering;
import 'package:flutter/widgets.dart' show AlignmentGeometry;
import 'package:oui/src/components/shared/flow_direction.dart';
import 'package:oui/src/components/shared/position.dart';

/// Class representing the alignment within a container.
class Alignment {
  /// The main position within the alignment.
  final Position main;

  /// The cross position within the alignment.
  final Position cross;

  /// The flow direction of the alignment.
  final FlowDirection direction;

  /// Creates an alignment with the given main position, cross position, and flow direction.
  const Alignment(
    this.main,
    this.cross, [
    this.direction = FlowDirection.leftToRight,
  ]);

  /// Predefined alignment for top-left.
  static const topLeft = Alignment(
    Position.leading,
    Position.leading,
  );

  /// Predefined alignment for top-center.
  static const topCenter = Alignment(
    Position.middle,
    Position.leading,
  );

  /// Predefined alignment for top-right.
  static const topRight = Alignment(
    Position.trailing,
    Position.leading,
  );

  /// Predefined alignment for center-left.
  static const centerLeft = Alignment(
    Position.leading,
    Position.middle,
  );

  /// Predefined alignment for center.
  static const center = Alignment(
    Position.middle,
    Position.middle,
  );

  /// Predefined alignment for center-right.
  static const centerRight = Alignment(
    Position.trailing,
    Position.middle,
  );

  /// Predefined alignment for bottom-left.
  static const bottomLeft = Alignment(
    Position.leading,
    Position.trailing,
  );

  /// Predefined alignment for bottom-center.
  static const bottomCenter = Alignment(
    Position.middle,
    Position.trailing,
  );

  /// Predefined alignment for bottom-right.
  static const bottomRight = Alignment(
    Position.trailing,
    Position.trailing,
  );

  /// Returns the opposite alignment.
  Alignment get opposite {
    return Alignment(
      main.opposite,
      cross.opposite,
      direction,
    );
  }

  /// Returns the flipped alignment.
  Alignment get flip {
    return Alignment(
      cross,
      main,
      direction.opposite,
    );
  }

  /// Converts the alignment to Flutter's [AlignmentGeometry].
  rendering.AlignmentGeometry get uiAlignment {
    return rendering.Alignment(
      direction.begin.x +
          (main == Position.middle
              ? 0
              : main == Position.trailing
                  ? 0.5
                  : -0.5),
      direction.begin.y +
          (cross == Position.middle
              ? 0
              : cross == Position.trailing
                  ? 0.5
                  : -0.5),
    );
  }
}
