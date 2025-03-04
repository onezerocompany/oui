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

mixin ResponsiveContext {
  ScreenSize get width;
  ScreenSize get height;
  ScreenOrientation get orientation;
  Density get density;
}
