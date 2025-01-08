import 'generator.dart';

/// Enum representing different themes for dynamic colors in the Oui library.
///
/// The `DynamicTheme` enum provides four different themes:
///
/// - `light`: Represents a light theme.
/// - `muted`: Represents a slightly darkened light theme.
/// - `dimmed`: Represents a slightly lifted dark theme.
/// - `dark`: Represents a dark theme.
enum DynamicTheme {
  light,
  muted,
  dimmed,
  dark,
}

class DynamicContainer<T> {
  final T light;
  final T muted;
  final T dimmed;
  final T dark;

  const DynamicContainer({
    required this.light,
    required this.muted,
    required this.dimmed,
    required this.dark,
  });

  T get(DynamicTheme theme) {
    switch (theme) {
      case DynamicTheme.light:
        return light;
      case DynamicTheme.muted:
        return muted;
      case DynamicTheme.dimmed:
        return dimmed;
      case DynamicTheme.dark:
        return dark;
    }
  }

  T operator [](DynamicTheme theme) {
    return get(theme);
  }

  @override
  int get hashCode {
    return Object.hash(light, muted, dimmed, dark);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DynamicContainer) return false;
    return light == other.light &&
        muted == other.muted &&
        dimmed == other.dimmed &&
        dark == other.dark;
  }

  @override
  String toString() {
    return 'DynamicContainer(\n  light: $light,\n  muted: $muted,\n  dimmed: $dimmed,\n  dark: $dark\n)';
  }
}

class DynamicContainerGenerator<T> extends Generator<DynamicContainer<T>> {
  final T Function(DynamicTheme theme) generator;

  const DynamicContainerGenerator(this.generator);

  @override
  DynamicContainer<T> generate() => DynamicContainer(
        light: generator(DynamicTheme.light),
        muted: generator(DynamicTheme.muted),
        dimmed: generator(DynamicTheme.dimmed),
        dark: generator(DynamicTheme.dark),
      );
}
