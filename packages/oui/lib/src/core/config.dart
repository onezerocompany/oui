import 'package:oui/oui.dart';

class Version {
  final int major;
  final int minor;
  final int patch;

  const Version(
    this.major,
    this.minor,
    this.patch,
  );

  const Version.zero()
      : major = 0,
        minor = 0,
        patch = 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Version &&
        other.major == major &&
        other.minor == minor &&
        other.patch == patch;
  }

  @override
  int get hashCode => major.hashCode ^ minor.hashCode ^ patch.hashCode;

  @override
  String toString() => '$major.$minor.$patch';
}

class AppDetails extends Metadata {
  final Version version;

  const AppDetails({
    required super.id,
    required super.name,
    super.icon,
    super.attributes,
    required this.version,
  });

  @override
  Metadata copyWith({
    String? id,
    Localized<String>? name,
    Localized<Icon?>? icon,
    Localized<List<String>>? tags,
    Localized<Map<String, dynamic>>? attributes,
    Version? version,
  }) {
    return AppDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      attributes: attributes ?? this.attributes,
      version:
          version ?? this.version, // changed to use this.version for clarity
    );
  }
}

class ColorConfig {
  final Color seed;
  final int levels;

  const ColorConfig({
    this.seed = Color.white,
    this.levels = 6,
  });
}

class ScaffoldConfig {
  final bool usePanels;
  final Size defaultPanelSize;
  final double defaultRailWidth = 68;

  const ScaffoldConfig({
    this.usePanels = true,
    this.defaultPanelSize = Size.infinite,
  });
}

class ResponsiveConfig {
  final ResponsiveBreakpoints horizontal;
  final ResponsiveBreakpoints vertical;

  const ResponsiveConfig({
    this.horizontal = const ResponsiveBreakpoints(
      sm: 300,
      md: 768,
      lg: 991,
      xl: 1200,
      xxl: 1600,
    ),
    this.vertical = const ResponsiveBreakpoints(
      sm: 300,
      md: 768,
      lg: 991,
      xl: 1200,
      xxl: 1600,
    ),
  });
}

class ScreenConfig {
  final Range<double> roundness;
  final RangedDimension? defaultPanelWidth;

  const ScreenConfig({
    this.roundness = const Range(4, 32),
    this.defaultPanelWidth = const RangedDimension.dynamic(
      minimum: 300,
      maximum: 800,
    ),
  });
}

class ScreenRegistryConfig {
  final List<Screen> screens;

  const ScreenRegistryConfig({
    required this.screens,
  });
}

class Config {
  final AppDetails details;
  final ScaffoldConfig scaffold;
  final ScreenConfig screens;
  final ColorConfig colors;
  final Locales locales;
  final TypographyConfig typography;
  final ResponsiveConfig responsive;
  final ScreenRegistryConfig registry;
  final AuthProviderBuilder? auth;

  const Config({
    required this.details,
    required this.registry,
    this.colors = const ColorConfig(),
    this.scaffold = const ScaffoldConfig(),
    this.screens = const ScreenConfig(),
    this.typography = const TypographyConfig(),
    this.responsive = const ResponsiveConfig(),
    this.locales = const [
      Locale.en,
    ],
    this.auth,
  });

  @override
  int get hashCode => Object.hash(
        details,
        scaffold,
        screens,
        colors,
        locales,
        typography,
        responsive,
        registry,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Config &&
            other.details == details &&
            other.scaffold == scaffold &&
            other.screens == screens &&
            other.colors == colors &&
            other.locales == locales &&
            other.typography == typography &&
            other.responsive == responsive &&
            other.registry == registry);
  }
}
