import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:oui/src/router/oui_path_match.dart';
import 'package:oui/src/screens/oui_screen_registry.dart';

/// A route information parser that converts URIs to [OuiPathMatch] objects.
///
/// This parser is used in conjunction with the Oui routing system to handle
/// route information parsing and restoration in a Flutter application.
class OuiRouteInformationParser extends RouteInformationParser<OuiPathMatch> {
  /// The root screen of the application's routing hierarchy.
  final OuiScreenRegistry _registry;

  /// Creates an [OuiRouteInformationParser] with the specified root screen.
  ///
  /// The [_root] parameter defines the entry point of the application's
  /// routing hierarchy.
  const OuiRouteInformationParser(this._registry);

  /// Parses route information into an [OuiPathMatch] object.
  ///
  /// This method takes the current [RouteInformation] and [BuildContext],
  /// extracts the URI segments and locale, and matches them against the root screen.
  @override
  Future<OuiPathMatch> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) {
    final segments = routeInformation.uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();
    return SynchronousFuture(_registry.match(segments));
  }

  /// Converts an [OuiPathMatch] back into [RouteInformation].
  ///
  /// This method is used when restoring the application's navigation state.
  @override
  RouteInformation restoreRouteInformation(OuiPathMatch configuration) {
    return RouteInformation(uri: configuration.uri);
  }
}
