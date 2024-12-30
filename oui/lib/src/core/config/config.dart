import 'package:oui/src/core/config/color_config.dart';

import '../metadata/app_details.dart';
import 'scaffold_config.dart';

class Config {
  final AppDetails app;
  final ScaffoldConfig scaffold;
  final ColorConfig colors;

  const Config({
    required this.app,
    this.scaffold = const ScaffoldConfig(),
    this.colors = const ColorConfig(),
  });
}
