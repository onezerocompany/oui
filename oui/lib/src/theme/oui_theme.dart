import 'package:flutter/widgets.dart';
import 'package:oui/src/components/buttons/oui_pressable.dart';

class OuiThemeProvider extends InheritedWidget {
  final OuiTheme theme;

  const OuiThemeProvider({
    required this.theme,
    required super.child,
    super.key,
  });

  static OuiTheme of(BuildContext context) {
    final OuiThemeProvider? provider =
        context.dependOnInheritedWidgetOfExactType<OuiThemeProvider>();
    return provider?.theme ?? const OuiTheme();
  }

  static OuiTheme? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<OuiThemeProvider>()
        ?.theme;
  }

  @override
  bool updateShouldNotify(covariant OuiThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}

class OuiTheme {
  final Color backdropColor;
  final OuiPressableTheme pressableTheme;

  const OuiTheme({
    this.backdropColor = const Color.fromARGB(255, 0, 0, 0),
    this.pressableTheme = const OuiPressableTheme(),
  });
}

extension OuiThemeExtension on BuildContext {
  OuiTheme get ouiTheme => OuiThemeProvider.of(this);
}
