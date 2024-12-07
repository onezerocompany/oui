import 'package:oui/oui.dart';

/// A route information parser that converts URIs to [OuiPathMatch] objects.
///
/// This parser is used in conjunction with the Oui routing system to handle
/// route information parsing and restoration in a Flutter application.
class OuiRouteInformationParser extends RouteInformationParser<OuiPathMatch> {
  /// The root screen of the application's routing hierarchy.
  final OuiScreen _root;

  /// Creates an [OuiRouteInformationParser] with the specified root screen.
  ///
  /// The [_root] parameter defines the entry point of the application's
  /// routing hierarchy.
  const OuiRouteInformationParser(this._root);

  @override

  /// Parses route information into an [OuiPathMatch] object.
  ///
  /// This method takes the current [RouteInformation] and [BuildContext],
  /// extracts the URI segments and locale, and matches them against the root screen.
  Future<OuiPathMatch> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) {
    final locale = Localizations.localeOf(context);
    final segments = routeInformation.uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();
    return SynchronousFuture(_root.match(segments, locale));
  }

  @override

  /// Converts an [OuiPathMatch] back into [RouteInformation].
  ///
  /// This method is used when restoring the application's navigation state.
  RouteInformation restoreRouteInformation(OuiPathMatch configuration) {
    return RouteInformation(uri: configuration.uri);
  }
}
