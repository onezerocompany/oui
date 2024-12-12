import 'package:oui/oui.dart';

/// A widget that serves as the root of the OUI application.
///
/// [OuiApp] configures the top-level [WidgetsApp.router] with OUI-specific
/// routing and theming functionality. It should be used as the root widget
/// of your application.
class OuiApp extends StatelessWidget {
  /// The theme configuration for the application.
  final OuiConfig theme;

  /// Authentication provider for the application.
  final OuiAuthProvider? authProvider;

  /// App detail provider for the application.
  final OuiMetadataProvider appDetailProvider;

  /// Parser responsible for converting URLs into state objects.
  final OuiRouteInformationParser _routerInformationParser;

  /// Delegate that handles routing decisions.
  final OuiRouterDelegate _routerDelegate;

  /// Creates an [OuiApp].
  ///
  /// The [root] parameter defines the initial screen of the application.
  /// The optional [authScreen] parameter specifies an authentication screen.
  /// The [theme] parameter allows customization of the application's visual properties.
  OuiApp({
    super.key,
    required OuiScreen root,
    required this.appDetailProvider,
    OuiScreen? authScreen,
    this.authProvider,
    this.theme = const OuiConfig(),
  })  : _routerInformationParser = OuiRouteInformationParser(root),
        _routerDelegate = OuiRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: WidgetsApp.router(
        color: const Color.fromARGB(255, 0, 0, 0),
        routerDelegate: _routerDelegate,
        routeInformationParser: _routerInformationParser,
        debugShowCheckedModeBanner: false, // hide debug banners
      ),
    );
  }
}
