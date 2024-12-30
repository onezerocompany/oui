import 'package:oui/src/core/config/color_config.dart';

import '../localization/locale.dart';
import '../metadata/metadata.dart';
import 'scaffold_config.dart';

class Config {
  final LocalizedMetadata appDetails;
  final ScaffoldConfig scaffold;
  final ColorConfig colors;
  final String version;
  final Locales supportedLocales;

  const Config({
    required this.appDetails,
    required this.version,
    this.supportedLocales = const [Locale.english],
    this.scaffold = const ScaffoldConfig(),
    this.colors = const ColorConfig(),
  });
}
