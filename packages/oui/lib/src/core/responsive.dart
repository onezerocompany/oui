import 'package:flutter/widgets.dart' show BuildContext, MediaQuery;
import 'package:oui/oui.dart';

class ResponsiveBreakpoints {
  final double xs = 0;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  const ResponsiveBreakpoints({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  ScreenSize sizeFor(double width) {
    if (width > xxl) return ScreenSize.xxl;
    if (width > xl) return ScreenSize.xl;
    if (width > lg) return ScreenSize.lg;
    if (width > md) return ScreenSize.md;
    if (width > sm) return ScreenSize.sm;
    return ScreenSize.xs;
  }
}

enum ScreenSize {
  xs(0),
  sm(1),
  md(2),
  lg(3),
  xl(4),
  xxl(5);

  final int size;
  const ScreenSize(this.size);

  bool operator <(ScreenSize other) => size < other.size;
  bool operator <=(ScreenSize other) => size <= other.size;
  bool operator >(ScreenSize other) => size > other.size;
  bool operator >=(ScreenSize other) => size >= other.size;

  bool isBetween(ScreenSize min, ScreenSize max) => this >= min && this <= max;
  bool isGreaterThan(ScreenSize other) => this > other;
  bool isLessThan(ScreenSize other) => this < other;
  bool isGreaterThanOrEqualTo(ScreenSize other) => this >= other;
  bool isLessThanOrEqualTo(ScreenSize other) => this <= other;
  bool isEqualTo(ScreenSize other) => this == other;
}

enum ScreenOrientation {
  portrait,
  landscape;

  bool get isPortrait => this == ScreenOrientation.portrait;
  bool get isLandscape => this == ScreenOrientation.landscape;
}

enum Density {
  lowest(-1),
  low(-0.5),
  medium(0),
  high(0.5),
  highest(1);

  final double t;
  const Density(this.t);

  bool operator <(Density other) => t < other.t;
  bool operator <=(Density other) => t <= other.t;
  bool operator >(Density other) => t > other.t;
  bool operator >=(Density other) => t >= other.t;

  bool isBetween(Density min, Density max) => this >= min && this <= max;
  bool isGreaterThan(Density other) => this > other;
  bool isLessThan(Density other) => this < other;
  bool isGreaterThanOrEqualTo(Density other) => this >= other;
  bool isLessThanOrEqualTo(Density other) => this <= other;
  bool isEqualTo(Density other) => this == other;
}

class ResponsiveContext {
  final ScreenSize width;
  final ScreenSize height;
  final ScreenOrientation orientation;
  final Density density;
  final DynamicTheme theme;

  const ResponsiveContext({
    required this.width,
    required this.height,
    required this.orientation,
    required this.density,
    required this.theme,
  });

  factory ResponsiveContext.from(Config config, BuildContext context) {
    final query = MediaQuery.of(context);
    final screenSize = query.size;

    return ResponsiveContext(
      width: config.responsive.horizontal.sizeFor(screenSize.width),
      height: config.responsive.vertical.sizeFor(screenSize.height),
      orientation: screenSize.width > screenSize.height
          ? ScreenOrientation.landscape
          : ScreenOrientation.portrait,
      density: Density.medium,
      theme: DynamicTheme.of(context),
    );
  }

  static ResponsiveContext of(BuildContext context) {
    return DynamicAppContext.of(context).responsive;
  }

  @override
  String toString() {
    return 'ResponsiveContext{width: $width, height: $height, orientation: $orientation, density: $density, theme: $theme}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResponsiveContext &&
        other.width == width &&
        other.height == height &&
        other.orientation == orientation &&
        other.density == density &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return width.hashCode ^
        height.hashCode ^
        orientation.hashCode ^
        density.hashCode ^
        theme.hashCode;
  }
}

typedef ResponsiveCondition = bool Function(ResponsiveContext context);

class ResponsiveValueEntry<T> {
  final ResponsiveCondition condition;
  final T value;

  const ResponsiveValueEntry(
    this.condition,
    this.value,
  );
}

class ResponsiveValueContainer<T> {
  final T fallback;
  final List<ResponsiveValueEntry<T>> entries;

  const ResponsiveValueContainer(this.entries, this.fallback);

  T resolve(ResponsiveContext context) {
    return entries
        .firstWhere(
          (entry) => entry.condition(context),
          orElse: () => ResponsiveValueEntry((_) => true, fallback),
        )
        .value;
  }
}
