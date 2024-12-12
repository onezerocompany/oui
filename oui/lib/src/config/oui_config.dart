import 'package:oui/oui.dart';

class OuiConfigProvider extends InheritedWidget {
  final OuiConfig theme;

  const OuiConfigProvider({
    required this.theme,
    required super.child,
    super.key,
  });

  static OuiConfig of(BuildContext context) {
    final OuiConfigProvider? provider =
        context.dependOnInheritedWidgetOfExactType<OuiConfigProvider>();
    return provider?.theme ?? const OuiConfig();
  }

  static OuiConfig? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<OuiConfigProvider>()
        ?.theme;
  }

  @override
  bool updateShouldNotify(covariant OuiConfigProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}

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

extension OuiThemeExtension on BuildContext {
  OuiConfig get theme => OuiConfigProvider.of(this);
}
