import 'package:oui/src/core/colors.dart' show DynamicTheme;
import 'package:oui/src/core/state.dart' show State;

enum ScreenDimensionSize { xs, sm, md, lg, xl, xxl }

enum ScreenOrientation { portrait, landscape }

enum Density {
  lowest(0),
  low(0.5),
  medium(1),
  high(1.5),
  highest(2);

  final double t;
  const Density(this.t);
}

class ResponsiveContext {
  final ScreenDimensionSize width;
  final ScreenDimensionSize height;
  final ScreenOrientation orientation;
  final Density density;
  final DynamicTheme theme;
  final State state;

  const ResponsiveContext({
    required this.width,
    required this.height,
    required this.orientation,
    required this.density,
    required this.theme,
    required this.state,
  });
}

class ResponsiveValueEntry<T> {
  final bool Function(ResponsiveContext context) condition;
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
