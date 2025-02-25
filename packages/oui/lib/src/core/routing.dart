import 'package:flutter/foundation.dart' show ChangeNotifier, SynchronousFuture;
import 'package:flutter/widgets.dart'
    show BuildContext, GlobalKey, RouteInformation, RouterDelegate, Widget;
import 'package:flutter/widgets.dart' as widgets show RouteInformationParser;

import '../components/screen.dart';
import 'locales.dart';
import 'localization.dart';
import 'scaffold.dart';
import 'screen_registry.dart';

/// Represents a segment of a path in the Oui routing system.
class PathSegment {
  /// Unique identifier for the path segment.
  final String id;

  /// Optional pattern to match the segment.
  final String? pattern;

  /// Indicates if the segment is parametric.
  final bool isParametric;

  /// Private constructor for creating a path segment.
  const PathSegment._({
    required this.id,
    this.isParametric = false,
    this.pattern,
  }) : assert(id.length != 0, 'The id of a path segment cannot be empty.');

  /// Creates a static path segment.
  ///
  /// Example:
  /// ```dart
  /// var segment = PathSegment.static('home');
  /// ```
  factory PathSegment.static(String value) {
    assert(value.isNotEmpty, 'The value of a static segment cannot be empty.');
    return PathSegment._(
      id: value,
      pattern: '^${RegExp.escape(value)}\$',
    );
  }

  /// Creates a parametric path segment with an optional pattern.
  ///
  /// This factory constructor allows you to create a path segment that can
  /// match a specific pattern, making it useful for defining dynamic routes.
  ///
  /// Example:
  /// ```dart
  /// // Create a segment that matches any digits
  /// var segment = PathSegment.argument('id', pattern: r'\d+');
  ///
  /// // Create a segment without a specific pattern
  /// var segmentWithoutPattern = PathSegment.argument('name');
  ///
  /// // Create a segment that matches any word characters
  /// var segmentWithWordPattern = PathSegment.argument('username', pattern: r'\w+');
  /// ```
  ///
  /// [id] is the identifier for the path segment.
  /// [pattern] is an optional regular expression pattern that the segment should match.
  factory PathSegment.argument(String id, {String? pattern}) {
    assert(id.isNotEmpty, 'The id of an argument segment cannot be empty.');
    if (pattern != null) {
      // check the pattern is valid
      try {
        RegExp(pattern);
      } catch (e) {
        throw FormatException(
          'The pattern for an argument segment is not a valid regular expression: $pattern',
        );
      }

      assert(
        RegExp(pattern).isMultiLine == false,
        'The pattern for an argument segment cannot be multiline.',
      );
    }
    return PathSegment._(
      id: id,
      pattern: pattern,
      isParametric: true,
    );
  }

  /// Returns a string representation of the path segment.
  @override
  String toString() {
    return 'PathSegment(id: $id, pattern: $pattern, isParametric: $isParametric)';
  }
}

/// A list of [PathSegment]s.
typedef PathSegments = List<PathSegment>;

/// Represents a path in the OUI routing system composed of multiple segments.
///
/// A path is used to match and parse URL segments for routing purposes.
class Path {
  /// The ordered list of segments that make up this path.
  final PathSegments segments;

  int get length => segments.length;

  /// Creates a new [Path] with the given [segments].
  const Path(this.segments);

  /// Creates a new [Path] from a string representation.
  ///
  /// This constructor splits the given [path] by '/' and creates static
  /// segments for each non-empty part.
  ///
  /// Example:
  /// ```dart
  /// var path = Path.from('/home/user/profile');
  /// ```
  Path.fromString(String path)
      : segments = path.split('/').where((segment) => segment.isNotEmpty).map(
          (segment) {
            if (segment.startsWith(':')) {
              return PathSegment.argument(segment.substring(1));
            } else {
              return PathSegment.static(segment);
            }
          },
        ).toList();

  /// Returns true if this path contains no segments.
  bool get isEmpty => segments.isEmpty;

  static const empty = Path([]);

  PathMatch match(List<String> segments, List<Screen> screens) {
    final matches = _segmentMatches(segments);
    final leftovers = segments.skip(matches.length).toList();
    return PathMatch(
      screens,
      matches,
      leftovers,
      segments.length,
    );
  }

  /// Matches the given path segments against the defined segments.
  /// Returns a list of [PathSegmentMatch] if all segments match, otherwise an empty list.
  List<PathSegmentMatch> _segmentMatches(List<String> path) {
    final List<PathSegmentMatch> matches = [];

    for (var i = 0; i < segments.length; i++) {
      final pathSegment = path.elementAtOrNull(i);
      if (pathSegment == null) {
        return matches;
      }

      final segment = segments[i];
      if (segment.isParametric) {
        if (!_matchParametricSegment(segment, pathSegment, matches)) {
          return matches;
        }
      } else {
        if (!_matchStaticSegment(segment, pathSegment, matches)) {
          return matches;
        }
      }
    }

    return matches;
  }

  /// Matches a parametric segment and adds it to the matches list if successful.
  bool _matchParametricSegment(
    PathSegment segment,
    String pathSegment,
    List<PathSegmentMatch> matches,
  ) {
    if (segment.pattern != null) {
      final match = RegExp(segment.pattern!).firstMatch(pathSegment);
      if (match != null) {
        final value = match.groupCount > 0 ? match.group(1) : match.group(0);
        matches.add(
          PathSegmentMatch(
            segment: segment,
            original: pathSegment,
            value: value,
          ),
        );
        return true;
      }
      return false;
    } else {
      matches.add(
        PathSegmentMatch(
          segment: segment,
          original: pathSegment,
          value: pathSegment,
        ),
      );
      return true;
    }
  }

  /// Matches a static segment and adds it to the matches list if successful.
  bool _matchStaticSegment(
    PathSegment segment,
    String pathSegment,
    List<PathSegmentMatch> matches,
  ) {
    if (segment.id == pathSegment.toLowerCase()) {
      matches.add(PathSegmentMatch(segment: segment, original: pathSegment));
      return true;
    }
    return false;
  }

  /// Returns a new [Path] with the given [segments] appended to the end.
  /// If [segments] is empty, returns this path.
  Path add(List<PathSegment> segments) {
    if (segments.isEmpty) {
      return this;
    }
    return Path([...this.segments, ...segments]);
  }

  @override
  String toString() {
    return segments.map((s) => s.id).join('/');
  }
}

/// Represents a match for a specific path segment.
///
/// This class holds details about a path segment, its original value,
/// and an optional transformed value.
///
/// Example usage:
/// ```dart
/// final segment = PathSegment(id: 'userId');
/// final match = PathSegmentMatch(
///   segment: segment,
///   original: '123',
///   value: 'user_123',
/// );
/// print(match.id);       // Outputs: 'userId'
/// print(match.content);  // Outputs: 'user_123'
/// ```
class PathSegmentMatch {
  /// The segment associated with this match.
  final PathSegment segment;

  /// The optional value of the segment match.
  ///
  /// If `_value` is `null`, the [original] value will be used as the content.
  final String? _value;

  /// The original value of the path segment match.
  final String original;

  /// A unique identifier derived from the associated [segment].
  String get id => segment.id;

  /// The effective content of the match.
  ///
  /// Returns the transformed `_value` if provided; otherwise, returns [original].
  String get content => _value ?? original;

  /// Creates an instance of [PathSegmentMatch].
  ///
  /// - [segment]: The path segment associated with this match.
  /// - [original]: The original value of the path segment.
  /// - [value]: An optional transformed value for the segment.
  ///
  /// Example:
  /// ```dart
  /// final segment = PathSegment(id: 'userId');
  /// final match = PathSegmentMatch(
  ///   segment: segment,
  ///   original: '123',
  ///   value: 'user_123',
  /// );
  /// ```
  const PathSegmentMatch({
    required this.segment,
    required this.original,
    String? value,
  }) : _value = value;
}

/// A list of [PathSegmentMatch] objects.
typedef PathSegmentMatches = List<PathSegmentMatch>;

/// Represents the result of matching a path against a route pattern.
/// Contains information about whether the path matches, how many segments matched,
/// the matched screens, and any path arguments that were extracted.
class PathMatch {
  /// List of segments that matched the pattern
  final List<PathSegmentMatch> segments;

  /// Segments from the path that didn't match any pattern
  final List<String> leftovers;

  /// The screens associated with the matched path segments
  final List<Screen> screens;

  /// Number of sections that were expected to match
  final int expectedSegmentCount;

  /// The original segments from the path, before any value parsing
  List<String> get rawSegments =>
      segments.map((segment) => segment.original).toList();

  /// Whether the path can be popped
  bool get canPop => screens.isNotEmpty;

  /// Constructs a Uri from the matched raw segments
  Uri get uri => Uri(pathSegments: rawSegments);

  /// Number of segments that matched
  int get count => segments.length;

  /// Percentage of segments that matched
  /// Note this can go over 1 (100%)
  double get rate =>
      expectedSegmentCount == 0 ? 0 : count / expectedSegmentCount;

  /// Creates a new [PathMatch] with the given [segments], [leftovers], and [screens].
  const PathMatch(
    this.screens,
    this.segments,
    this.leftovers,
    this.expectedSegmentCount,
  );

  /// Represents no match found
  static const noMatch = PathMatch([], [], [], 0);

  /// Removes the last [count] segments from the match
  PathMatch pop([int count = 1]) {
    if (count <= 0) {
      return this;
    }

    if (count >= screens.length) {
      return PathMatch.noMatch;
    }

    final screensToPop = screens.skip(screens.length - count);
    final segmentsToPop = screensToPop.map(
      (screen) => screen.metadata.path.forLocale(null)?.length ?? 0,
    );

    return PathMatch(
      screens.sublist(0, screens.length - count),
      segments.sublist(0, segments.length - count),
      [
        ...segments
            .skip(segmentsToPop.length - count)
            .map((segment) => segment.original),
        ...leftovers,
      ],
      0,
    );
  }

  @override
  String toString() {
    return 'PathMatch{segments: $segments, leftovers: $leftovers, screens: $screens}';
  }
}

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

    return SynchronousFuture(_registry.match(segments, context.currentLocale));
  }

  /// Converts an [PathMatch] back into [RouteInformation].
  ///
  /// This method is used when restoring the application's navigation state.
  @override
  RouteInformation restoreRouteInformation(PathMatch configuration) {
    return RouteInformation(uri: configuration.uri);
  }
}

class Router extends RouterDelegate<PathMatch> with ChangeNotifier {
  PathMatch activeMatch = PathMatch.noMatch;
  final GlobalKey<ScaffoldState> routerKey = GlobalKey<ScaffoldState>();

  Router();

  @override
  PathMatch? get currentConfiguration => activeMatch;

  @override
  Future<void> setNewRoutePath(PathMatch configuration) {
    activeMatch = configuration;
    notifyListeners();
    return SynchronousFuture(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: routerKey);
  }

  @override
  Future<bool> popRoute() {
    final willPop = routerKey.currentState?.activeMatch.canPop ?? false;
    if (willPop && routerKey.currentState != null) {
      routerKey.currentState!.activeMatch =
          routerKey.currentState!.activeMatch.pop();
      notifyListeners();
    }
    return SynchronousFuture(willPop);
  }
}
