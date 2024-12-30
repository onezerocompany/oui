import 'dart:ui' as ui;

import 'package:flutter/widgets.dart'
    show BuildContext, StatelessWidget, Widget, WidgetsApp;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oui/oui.dart';
import 'package:oui/src/core/colors/generator/color_palette_generator.dart';

import 'static_app_context.dart';

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

  /// Color palette generator.
  late final ColorPalette _colorPalette;

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
  }) : _registry = ScreenRegistry(root, config.supportedLocales) {
    _colorPalette = ColorPaletteGenerator(config.colors).generate();
    _routerInformationParser = RouteInformationParser(_registry);
    _router = Router();
  }

  @override
  Widget build(BuildContext context) {
    return StaticAppContext(
      router: _router,
      config: config,
      colorPalette: _colorPalette,
      child: ProviderScope(
        child: BoxLevel(
          level: 0,
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
