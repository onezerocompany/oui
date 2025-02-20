import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart'
    show usePathUrlStrategy;
import 'package:oui/oui.dart';

import 'screens/test_screen.dart';

final config = Config(
  details: AppDetails(
    name: {Locale.any: "Oui Showcase"},
    version: Version(0, 1, 0),
  ),
  registry: ScreenRegistryConfig(
    root: testScreen,
  ),
  colors: ColorConfig(
    seed: Color.fromHSL(
      HslColor.fromHSL(204, 0.92, 0.67),
    ),
  ),
);

void main() {
  usePathUrlStrategy();
  runApp(OuiApp(config));
}
