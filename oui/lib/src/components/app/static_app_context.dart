import 'package:flutter/widgets.dart'
    show BuildContext, FlutterError, InheritedWidget;
import 'package:oui/oui.dart';

import 'dynamic_app_context.dart';

class StaticAppContext extends InheritedWidget {
  final Config config;
  final Router router;
  final ColorPalette colorPalette;

  const StaticAppContext({
    super.key,
    required this.config,
    required this.router,
    required this.colorPalette,
    required super.child,
  });

  static StaticAppContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StaticAppContext>();
  }

  static Config? configOf(BuildContext context) {
    return of(context)?.config;
  }

  static Router? routerOf(BuildContext context) {
    return of(context)?.router;
  }

  static ColorPalette? colorPaletteOf(BuildContext context) {
    return of(context)?.colorPalette;
  }

  @override
  bool updateShouldNotify(StaticAppContext oldWidget) {
    return router != oldWidget.router || config != oldWidget.config;
  }
}

extension AppContextExtension on BuildContext {
  T _getFromContext<T>(T Function(StaticAppContext) extractor) {
    final context = StaticAppContext.of(this);
    if (context == null) {
      throw FlutterError(
        'AppContext not found in context. Make sure to wrap your app with OuiApp.\nThe context used to retrieve the value must be a descendant of AppContext.',
      );
    }
    return extractor(context);
  }

  Config get config {
    return _getFromContext((context) => context.config);
  }

  Router get router {
    return _getFromContext((context) => context.router);
  }

  ColorPalette get colorPalette {
    return _getFromContext((context) => context.colorPalette);
  }

  StatefulBoxColors get boxColors {
    return colorPalette.levels.get(theme).get(boxLevel);
  }
}
