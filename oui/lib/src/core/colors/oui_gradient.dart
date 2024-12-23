import 'package:flutter/rendering.dart';

import '../../components/box/oui_alignment.dart';
import 'oui_color.dart';

enum OuiGradientType {
  linear,
  radial,
  sweep,
}

class OuiGradientStop {
  final double offset;
  final OuiColor color;

  OuiGradientStop(this.offset, this.color);
}

class OuiGradient {
  final List<OuiGradientStop> stops;
  final OuiFlowDirection direction;
  final OuiGradientType type;

  const OuiGradient({
    required this.stops,
    this.direction = OuiFlowDirection.leftToRight,
    this.type = OuiGradientType.linear,
  });

  const OuiGradient.linear({
    required List<OuiGradientStop> stops,
    OuiFlowDirection direction = OuiFlowDirection.leftToRight,
  }) : this(
          stops: stops,
          direction: direction,
          type: OuiGradientType.linear,
        );

  const OuiGradient.radial({
    required List<OuiGradientStop> stops,
  }) : this(
          stops: stops,
          type: OuiGradientType.radial,
        );

  const OuiGradient.sweep({
    required List<OuiGradientStop> stops,
  }) : this(
          stops: stops,
          type: OuiGradientType.sweep,
        );

  Gradient get flutterGradient {
    final List<Offset> offsets = stops.map((stop) {
      return Offset(stop.offset, 0);
    }).toList();

    final List<Color> colors = stops.map((stop) {
      return stop.color.flutterColor;
    }).toList();

    switch (type) {
      case OuiGradientType.linear:
        return LinearGradient(
          colors: colors,
          stops: offsets.map((offset) => offset.dx).toList(),
          begin: direction.begin,
          end: direction.end,
        );
      case OuiGradientType.radial:
        return RadialGradient(
          colors: colors,
          stops: offsets.map((offset) => offset.dx).toList(),
          radius: 1,
        );
      case OuiGradientType.sweep:
        return SweepGradient(
          colors: colors,
          stops: offsets.map((offset) => offset.dx).toList(),
          startAngle: 0,
          endAngle: 2 * 3.14,
        );
    }
  }
}
