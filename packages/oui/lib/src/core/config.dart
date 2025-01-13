import 'colors.dart';
import 'geometry.dart';
import 'localization.dart';
import 'metadata.dart';

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

  ColorPalette get palette {
    return ColorPalette.generate(this);
  }
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

class Config {
  final AppDetails details;
  final ScaffoldConfig scaffold;
  final ColorConfig colors;
  final Locales locales;

  const Config({
    required this.details,
    this.colors = const ColorConfig(),
    this.scaffold = const ScaffoldConfig(),
    this.locales = const [
      Locale.english,
    ],
  });
}
