import 'dart:ui';

import 'package:oui/src/components/oui_pressable.dart';
import 'package:oui/src/scaffold/oui_scaffold.dart';

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
