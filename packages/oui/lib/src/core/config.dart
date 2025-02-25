import 'package:flutter/widgets.dart' show BuildContext;
import 'package:oui/src/core/app.dart' show StaticAppContext;

import '../components/screen.dart' show Screen;
import 'colors.dart' show Color;
import 'geometry.dart' show RangedDimension, Size;
import 'locales.dart' show Locale, Locales;
import 'metadata.dart' show Metadata;
import 'responsive.dart' show ResponsiveBreakpoints;
import 'typography.dart' show TypographyConfig;
import 'utils.dart' show Range;

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
    required super.name,
    super.icon,
    super.attributes,
    required this.version,
  });
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
  final Screen root;

  const ScreenRegistryConfig({
    required this.root,
  });

  @override
  int get hashCode => root.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ScreenRegistryConfig && other.root == root);
  }
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
  });

  static Config of(BuildContext context) {
    return StaticAppContext.of(context).config;
  }

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
