import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oui/src/app/oui_app_context.dart';
import 'package:oui/src/auth/oui_auth_provider.dart';
import 'package:oui/src/config/oui_config.dart';
import 'package:oui/src/router/oui_route_information_parser.dart';
import 'package:oui/src/router/oui_router.dart';
import 'package:oui/src/screens/oui_screen.dart';
import 'package:oui/src/screens/oui_screen_registry.dart';
import 'package:oui/src/utils/oui_metadata.dart';

/// A widget that serves as the root of the OUI application.
///
/// [OuiApp] configures the top-level [WidgetsApp.router] with OUI-specific
/// routing and theming functionality. It should be used as the root widget
/// of your application.
class OuiApp extends StatelessWidget {
  /// The theme configuration for the application.
  final OuiConfig config;

  /// Authentication provider for the application.
  final OuiAuthProvider? authProvider;

  /// App detail provider for the application.
  final OuiMetadata appDetailProvider;

  /// Registry that contains all screens in the application.
  final OuiScreenRegistry _registry;

  /// Parser responsible for converting URLs into state objects.
  late final OuiRouteInformationParser _routerInformationParser;

  /// Delegate that handles routing decisions.
  late final OuiRouter _router;

  /// Creates an [OuiApp].
  ///
  /// The [root] parameter defines the initial screen of the application.
  /// The [notFound] parameter specifies the screen to show when a route is not found.
  /// The optional [authScreen] parameter specifies an authentication screen.
  /// The [config] parameter allows customization of the application's visual properties.
  OuiApp({
    super.key,
    required OuiScreen root,
    required this.appDetailProvider,
    this.authProvider,
    this.config = const OuiConfig(),
  }) : _registry = OuiScreenRegistry(root, null) {
    _routerInformationParser = OuiRouteInformationParser(_registry);
    _router = OuiRouter(_registry);
  }

  @override
  Widget build(BuildContext context) {
    return OuiAppContext(
      router: _router,
      config: config,
      child: ProviderScope(
        child: WidgetsApp.router(
          color: const Color.fromARGB(255, 0, 0, 0),
          routerDelegate: _router,
          routeInformationParser: _routerInformationParser,
          debugShowCheckedModeBanner: false, // hide debug banners
        ),
      ),
    );
  }
}
