import 'package:oui/src/core/locales.dart' show Locale, Locales;
import 'package:oui/src/core/typography.dart';

import 'colors.dart';
import 'geometry.dart';
import 'metadata.dart';
import 'utils.dart';

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

class Config {
  final AppDetails details;
  final ScaffoldConfig scaffold;
  final ScreenConfig screens;
  final ColorConfig colors;
  final Locales locales;
  final TypographyConfig typography;

  const Config({
    required this.details,
    this.colors = const ColorConfig(),
    this.scaffold = const ScaffoldConfig(),
    this.screens = const ScreenConfig(),
    this.typography = const TypographyConfig(),
    this.locales = const [
      Locale.en,
    ],
  });
}
