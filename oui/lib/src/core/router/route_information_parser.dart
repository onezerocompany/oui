import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/widgets.dart' show BuildContext, RouteInformation;
import 'package:flutter/widgets.dart' as widgets show RouteInformationParser;

import '../../components/screen/screen_registry.dart';
import 'path_match.dart';

/// A route information parser that converts URIs to [PathMatch] objects.
///
/// This parser is used in conjunction with the Oui routing system to handle
/// route information parsing and restoration in a Flutter application.
class RouteInformationParser extends widgets.RouteInformationParser<PathMatch> {
  /// The root screen of the application's routing hierarchy.
  final ScreenRegistry _registry;

  /// Creates an [RouteInformationParser] with the specified root screen.
  ///
  /// The [_root] parameter defines the entry point of the application's
  /// routing hierarchy.
  const RouteInformationParser(this._registry);

  /// Parses route information into an [PathMatch] object.
  ///
  /// This method takes the current [RouteInformation] and [BuildContext],
  /// extracts the URI segments and locale, and matches them against the root screen.
  @override
  Future<PathMatch> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) {
    final segments = routeInformation.uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();
    return SynchronousFuture(_registry.match(segments));
  }

  /// Converts an [PathMatch] back into [RouteInformation].
  ///
  /// This method is used when restoring the application's navigation state.
  @override
  RouteInformation restoreRouteInformation(PathMatch configuration) {
    return RouteInformation(uri: configuration.uri);
  }
}
