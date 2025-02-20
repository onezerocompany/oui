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

class StaticAppContext {
  final Config config;
  final RouteInformationParser routerInformationParser;
  final Router router;
  final ColorPalette colorPalette;
  final Typography typography;
  final ScreenRegistry screenRegistry;

  const StaticAppContext({
    required this.config,
    required this.routerInformationParser,
    required this.router,
    required this.colorPalette,
    required this.typography,
    required this.screenRegistry,
  });

  factory StaticAppContext.forConfig(Config config) {
    final screenRegistry = ScreenRegistry.fromConfig(config);
    return StaticAppContext(
      config: config,
      router: Router(),
      routerInformationParser: RouteInformationParser(
        screenRegistry,
      ),
      colorPalette: ColorPalette.fromConfig(config.colors),
      typography: Typography.fromConfig(config.typography),
      screenRegistry: screenRegistry,
    );
  }

  @override
  int get hashCode =>
      config.hashCode ^
      routerInformationParser.hashCode ^
      router.hashCode ^
      colorPalette.hashCode ^
      typography.hashCode ^
      screenRegistry.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StaticAppContext &&
        other.config == config &&
        other.routerInformationParser == routerInformationParser &&
        other.router == router &&
        other.colorPalette == colorPalette &&
        other.typography == typography &&
        other.screenRegistry == screenRegistry;
  }

  static StaticAppContext of(BuildContext context) {
    final staticContext =
        context.dependOnInheritedWidgetOfExactType<StaticAppContextProvider>();
    if (staticContext == null) {
      throw FlutterError(
        'StaticAppContext not found in context. Make sure to wrap your app with OuiApp.',
      );
    }
    return staticContext.context;
  }
}

class StaticAppContextProvider extends InheritedWidget {
  final StaticAppContext context;

  const StaticAppContextProvider({
    super.key,
    required this.context,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return context != (oldWidget as StaticAppContextProvider).context;
  }
}

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
  final Config config;

  const DynamicAppContextProvider({
    super.key,
    required this.config,
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
      responsive: ResponsiveContext.from(widget.config, context),
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
  const OuiApp(
    this.config, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final staticContext = StaticAppContext.forConfig(config);
    return StaticAppContextProvider(
      context: staticContext,
      child: DynamicAppContextProvider(
        config: config,
        child: WidgetsApp.router(
          color: const ui.Color.fromARGB(205, 0, 0, 0),
          routerDelegate: staticContext.router,
          routeInformationParser: staticContext.routerInformationParser,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
