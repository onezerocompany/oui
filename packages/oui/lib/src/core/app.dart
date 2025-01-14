import 'dart:ui' as ui;

import 'package:flutter/widgets.dart'
    show
        BuildContext,
        FlutterError,
        InheritedWidget,
        StatefulWidget,
        StatelessWidget,
        Widget,
        WidgetsApp;
import 'package:flutter/widgets.dart' as widgets show State;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oui/src/components/box.dart';

import 'colors.dart';
import 'config.dart';
import 'routing.dart';
import 'screen.dart';
import 'state.dart';
import 'typography.dart';

class StaticAppContext extends InheritedWidget {
  final Config config;
  final Router router;
  final ColorPalette colorPalette;
  final Typography typography;

  const StaticAppContext({
    super.key,
    required this.config,
    required this.router,
    required this.colorPalette,
    required this.typography,
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

  ColorPalette get palette {
    return _getFromContext((context) => context.colorPalette);
  }

  BoxColors get colors {
    return palette.levels.get(theme).get(boxLevel).get(state);
  }
}

class DynamicAppContext extends InheritedWidget {
  final DynamicTheme theme;

  const DynamicAppContext({
    super.key,
    required this.theme,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return theme != (oldWidget as DynamicAppContext).theme;
  }

  static DynamicAppContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DynamicAppContext>();
  }
}

class DynamicAppContextProvider extends StatefulWidget {
  final Widget child;

  const DynamicAppContextProvider({
    super.key,
    required this.child,
  });

  @override
  widgets.State<DynamicAppContextProvider> createState() =>
      _DynamicAppContextProviderState();
}

class _DynamicAppContextProviderState
    extends widgets.State<DynamicAppContextProvider> {
  DynamicTheme get theme => DynamicTheme.light;

  @override
  Widget build(BuildContext context) {
    return DynamicAppContext(
      theme: DynamicTheme.forContext(context),
      child: widget.child,
    );
  }
}

extension DynamicAppContextExtension on BuildContext {
  DynamicTheme get theme {
    return DynamicAppContext.of(this)?.theme ?? DynamicTheme.light;
  }
}

/// A widget that serves as the root of the OUI application.
///
/// [OuiApp] configures the top-level [WidgetsApp.router] with OUI-specific
/// routing and theming functionality. It should be used as the root widget
/// of your application.
class OuiApp extends StatelessWidget {
  /// The theme configuration for the application.
  final Config config;

  /// Registry that contains all screens in the application.
  final ScreenRegistry _registry;

  /// Parser responsible for converting URLs into state objects.
  late final RouteInformationParser _routerInformationParser;

  /// Delegate that handles routing decisions.
  late final Router _router;

  /// Creates an [OuiApp].
  ///
  /// The [root] parameter defines the initial screen of the application.
  /// The [notFound] parameter specifies the screen to show when a route is not found.
  /// The optional [authScreen] parameter specifies an authentication screen.
  /// The [config] parameter allows customization of the application's visual properties.
  OuiApp({
    super.key,
    required Screen root,
    required this.config,
  }) : _registry = ScreenRegistry(root, config.locales) {
    _routerInformationParser = RouteInformationParser(_registry);
    _router = Router();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: StaticAppContext(
        router: _router,
        config: config,
        colorPalette: ColorPalette.fromConfig(config.colors),
        typography: Typography.fromConfig(config.typography),
        child: DynamicAppContextProvider(
          child: WidgetsApp.router(
            color: const ui.Color.fromARGB(255, 0, 0, 0),
            routerDelegate: _router,
            routeInformationParser: _routerInformationParser,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
