import 'package:oui/oui.dart';

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
