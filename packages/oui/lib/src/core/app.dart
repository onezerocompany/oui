import 'dart:ui' as ui;

import 'package:flutter/widgets.dart'
    show
        BuildContext,
        FlutterError,
        InheritedWidget,
        State,
        StatefulWidget,
        Widget,
        WidgetsApp,
        WidgetsFlutterBinding;
import 'package:flutter/widgets.dart' as widgets show runApp;

import 'colors.dart';
import 'config.dart';
import 'responsive.dart';
import 'routing.dart';
import 'screen_registry.dart';
import 'typography.dart';

/// Encapsulates all static configuration data for your app.
class StaticAppContext {
  final Config config;
  final Router router;
  final ColorPalette colorPalette;
  final Typography typography;
  final ScreenRegistry screenRegistry;

  const StaticAppContext({
    required this.config,
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
      routerInformationParser: RouteInformationParser(screenRegistry),
      colorPalette: ColorPalette.fromConfig(config.colors),
      typography: Typography.fromConfig(config.typography),
      screenRegistry: screenRegistry,
    );
  }

  @override
  int get hashCode => Object.hash(
        config,
        routerInformationParser,
        router,
        colorPalette,
        typography,
        screenRegistry,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is StaticAppContext &&
            other.config == config &&
            other.routerInformationParser == routerInformationParser &&
            other.router == router &&
            other.colorPalette == colorPalette &&
            other.typography == typography &&
            other.screenRegistry == screenRegistry);
  }

  /// Retrieve the nearest StaticAppContext in the widget tree.
  static StaticAppContext of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<InheritedStaticAppContext>();
    if (inherited == null) {
      throw FlutterError(
        'StaticAppContext not found in context. Make sure to wrap your app with OuiApp.',
      );
    }
    return inherited.context;
  }
}

/// Provides static configuration to the widget subtree.
/// This widget only notifies dependents if the static context changes.
class InheritedStaticAppContext extends InheritedWidget {
  final StaticAppContext context;

  const InheritedStaticAppContext({
    super.key,
    required this.context,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedStaticAppContext oldWidget) {
    return context != oldWidget.context;
  }
}

/// Provides responsive configuration to the widget subtree.
/// Only widgets that actually depend on the [ResponsiveContext] will rebuild.
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

  /// Retrieve the nearest DynamicAppContext in the widget tree.
  static DynamicAppContext of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<DynamicAppContext>();
    if (inherited == null) {
      throw FlutterError(
        'DynamicAppContext not found in context. Make sure to wrap your app with OuiApp.',
      );
    }
    return inherited;
  }
}

/// The root widget of your application that wires up static and dynamic contexts.
class OuiApp extends StatefulWidget {
  final Config config;

  const OuiApp({
    super.key,
    required this.config,
  });

  @override
  State<OuiApp> createState() => _OuiAppState();
}

class _OuiAppState extends State<OuiApp> {
  late StaticAppContext staticAppContext;

  @override
  void initState() {
    super.initState();
    staticAppContext = StaticAppContext.forConfig(widget.config);
  }

  @override
  void didUpdateWidget(covariant OuiApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != oldWidget.config) {
      setState(() {
        // Rebuild the app with the new static context.
        staticAppContext = StaticAppContext.forConfig(widget.config);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedStaticAppContext(
      context: staticAppContext,
      child: _DynamicAppContextProvider(
        config: widget.config,
        child: WidgetsApp.router(
          // routerDelegate: staticAppContext.router,
          // routeInformationParser: staticAppContext.routerInformationParser,
          routerConfig: staticAppContext.routerConfig,
          color: const ui.Color.fromARGB(205, 0, 0, 0),
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'oui_app',
          supportedLocales: staticAppContext.config.locales
              .map((e) => e.flutterLocale)
              .toList(),
        ),
      ),
    );
  }
}

/// A stateful widget that computes the responsive context once and only rebuilds if needed.
class _DynamicAppContextProvider extends StatefulWidget {
  final Config config;
  final Widget child;

  const _DynamicAppContextProvider({
    required this.config,
    required this.child,
  });

  @override
  _DynamicAppContextProviderState createState() =>
      _DynamicAppContextProviderState();
}

class _DynamicAppContextProviderState
    extends State<_DynamicAppContextProvider> {
  late ResponsiveContext responsive;

  void _updateResponsive() {
    responsive = ResponsiveContext.from(widget.config, context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateResponsive();
  }

  @override
  void didUpdateWidget(covariant _DynamicAppContextProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != oldWidget.config) {
      _updateResponsive();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicAppContext(
      responsive: responsive,
      child: widget.child,
    );
  }
}

void runOuiApp(Config config) {
  WidgetsFlutterBinding.ensureInitialized();
  widgets.runApp(OuiApp(config: config));
}
