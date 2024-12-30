import 'dart:ui' as ui show Color;

import 'package:flutter/rendering.dart' as rendering
    show Gradient, SweepGradient, LinearGradient, RadialGradient, Offset;

import '../../components/shared/flow_direction.dart';
import 'color.dart';

/// Enum representing the types of gradients available.
enum GradientType {
  linear,
  radial,
  sweep,
}

/// Class representing a gradient stop with an offset and a color.
class GradientStop {
  /// The offset of the gradient stop.
  final double offset;

  /// The color of the gradient stop.
  final Color color;

  /// Creates a gradient stop with the given offset and color.
  GradientStop(this.offset, this.color);
}

/// Class representing a gradient with multiple stops, direction, and type.
class Gradient {
  /// The list of gradient stops.
  final List<GradientStop> stops;

  /// The direction of the gradient flow.
  final FlowDirection direction;

  /// The type of the gradient.
  final GradientType type;

  /// Creates a gradient with the given stops, direction, and type.
  const Gradient({
    required this.stops,
    this.direction = FlowDirection.leftToRight,
    this.type = GradientType.linear,
  });

  /// Creates a linear gradient with the given stops and direction.
  const Gradient.linear({
    required List<GradientStop> stops,
    FlowDirection direction = FlowDirection.topToBottom,
  }) : this(
          stops: stops,
          direction: direction,
          type: GradientType.linear,
        );

  /// Creates a radial gradient with the given stops.
  const Gradient.radial({
    required List<GradientStop> stops,
  }) : this(
          stops: stops,
          type: GradientType.radial,
        );

  /// Creates a sweep gradient with the given stops.
  const Gradient.sweep({
    required List<GradientStop> stops,
  }) : this(
          stops: stops,
          type: GradientType.sweep,
        );

  /// Converts the Gradient to a Flutter Gradient.
  rendering.Gradient get uiGradient {
    final List<rendering.Offset> offsets = stops.map((stop) {
      return rendering.Offset(stop.offset, 0);
    }).toList();

    final List<ui.Color> colors = stops.map((stop) {
      return stop.color.uiColor;
    }).toList();

    switch (type) {
      case GradientType.linear:
        return rendering.LinearGradient(
          colors: colors,
          stops: offsets.map((offset) => offset.dx).toList(),
          begin: direction.begin,
          end: direction.end,
        );
      case GradientType.radial:
        return rendering.RadialGradient(
          colors: colors,
          stops: offsets.map((offset) => offset.dx).toList(),
          radius: 1,
        );
      case GradientType.sweep:
        return rendering.SweepGradient(
          colors: colors,
          stops: offsets.map((offset) => offset.dx).toList(),
          startAngle: 0,
          endAngle: 2 * 3.14,
        );
    }
  }

  @override
  int get hashCode {
    return Object.hash(stops, direction, type);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Gradient) return false;
    return stops == other.stops &&
        direction == other.direction &&
        type == other.type;
  }
}
