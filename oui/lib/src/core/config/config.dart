import 'package:oui/src/core/config/color_config.dart';
import 'package:oui/src/core/metadata/app_details.dart';

import '../localization/locale.dart';
import 'scaffold_config.dart';

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
