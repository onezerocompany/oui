import 'package:oui/oui.dart';

class OuiConfig {
  final Color backdropColor;
  final OuiPressableTheme pressableTheme;
  final OuiScaffoldConfig scaffold;

  const OuiConfig({
    this.backdropColor = const Color.fromARGB(255, 255, 255, 255),
    this.pressableTheme = const OuiPressableTheme(),
    this.scaffold = const OuiScaffoldConfig(),
  });
}
