import 'dart:ui';

import 'package:oui/src/components/pressables/oui_pressable.dart';

class OuiConfig {
  final Color backdropColor;
  final OuiPressableTheme pressableTheme;

  const OuiConfig({
    this.backdropColor = const Color.fromARGB(255, 255, 255, 255),
    this.pressableTheme = const OuiPressableTheme(),
  });
}
