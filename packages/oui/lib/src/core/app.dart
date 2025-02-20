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
import 'package:oui/src/core/responsive.dart';
import 'package:oui/src/core/screen_registry.dart';

import 'colors.dart';
import 'config.dart';
import 'routing.dart';
import 'typography.dart';

class StaticAppContext extends InheritedWidget {
  final Config config;
  final RouteInformationParser routerInformationParser;
  final Router router;
  final ColorPalette colorPalette;
  final Typography typography;
  final ScreenRegistry screenRegistry;

  const StaticAppContext({
    super.key,
    required this.config,
    required this.routerInformationParser,
    required this.router,
    required this.colorPalette,
    required this.typography,
    required super.child,
    required this.screenRegistry,
  });

  static StaticAppContext of(BuildContext context) {
    final staticContext =
        context.dependOnInheritedWidgetOfExactType<StaticAppContext>();
    if (staticContext == null) {
      throw FlutterError(
        'AppContext not found in context. Make sure to wrap your app with OuiApp.',
      );
    }
    return staticContext;
  }

  @override
  bool updateShouldNotify(StaticAppContext oldWidget) {
    return config != oldWidget.config ||
        router != oldWidget.router ||
        colorPalette != oldWidget.colorPalette ||
        typography != oldWidget.typography;
  }
}

class StaticAppContextProvider extends StatelessWidget {
  final Config config;
  final Widget child;

  const StaticAppContextProvider({
    super.key,
    required this.config,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenRegistry = ScreenRegistry.fromConfig(config);
    return StaticAppContext(
      config: config,
      router: Router(),
      routerInformationParser: RouteInformationParser(screenRegistry),
      screenRegistry: screenRegistry,
      colorPalette: ColorPalette.fromConfig(config.colors),
      typography: Typography.fromConfig(config.typography),
      child: child,
    );
  }
}

// extension AppContextExtension on BuildContext {
//   T _getFromContext<T>(T Function(StaticAppContextProvider) extractor) {
//     final context = StaticAppContextProvider.of(this);
//     if (context == null) {
//       throw FlutterError(
//         'AppContext not found in context. Make sure to wrap your app with OuiApp.\nThe context used to retrieve the value must be a descendant of AppContext.',
//       );
//     }
//     return extractor(context);
//   }

//   Config get config {
//     return _getFromContext((context) => context.config);
//   }

//   Router get router {
//     return _getFromContext((context) => context.router);
//   }

//   ColorPalette get palette {
//     return _getFromContext((context) => context.colorPalette);
//   }

//   BoxColors get colors {
//     return palette.levels.get(theme).get(boxLevel).get(state).accented(accent);
//   }
// }

class DynamicAppContext extends InheritedWidget {
  final ResponsiveContext responsive;

  const DynamicAppContext({
    super.key,
    required this.responsive,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant DynamicAppContext oldWidget) {
    return responsive != oldWidget.responsive;
  }

  static DynamicAppContext of(BuildContext context) {
    final dynamicContext =
        context.dependOnInheritedWidgetOfExactType<DynamicAppContext>();
    if (dynamicContext == null) {
      throw FlutterError(
        'DynamicAppContext not found in context. Make sure to wrap your app with OuiApp.',
      );
    }
    return dynamicContext;
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
    final config = StaticAppContext.of(context).config;
    return DynamicAppContext(
      responsive: ResponsiveContext.from(config, context),
      child: widget.child,
    );
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

  /// Creates an [OuiApp].
  ///
  /// The [root] parameter defines the initial screen of the application.
  /// The [notFound] parameter specifies the screen to show when a route is not found.
  /// The optional [authScreen] parameter specifies an authentication screen.
  /// The [config] parameter allows customization of the application's visual properties.
  const OuiApp({
    super.key,
    required this.config,
  });

  Widget _buildApp(BuildContext context) {
    final staticContext = StaticAppContext.of(context);
    return WidgetsApp.router(
      color: const ui.Color.fromARGB(205, 0, 0, 0),
      routerDelegate: staticContext.router,
      routeInformationParser: staticContext.routerInformationParser,
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StaticAppContextProvider(
      config: config,
      child: DynamicAppContextProvider(
        child: _buildApp(context),
      ),
    );
  }
}
