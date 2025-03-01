import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        ChangeNotifier,
        RouteInformation,
        RouteInformationParser,
        RouteInformationProvider,
        RouterConfig,
        RouterDelegate,
        Widget,
        WidgetsBindingObserver;
import 'package:oui/src/core/_index.dart';

class PathSegment {
  const PathSegment.static(String value)
      : id = value,
        pattern = null,
        isArgument = false,
        assert(
          value.length > 0,
          'The value of a static segment cannot be empty.',
        );

  const PathSegment.argument(
    this.id, {
    this.pattern,
  })  : isArgument = true,
        assert(
          id.length > 0,
          'The id of an argument segment cannot be empty.',
        );

  final String id;
  final RegExp? pattern;
  final bool isArgument;

  bool match(String value) {
    if (isArgument && pattern != null) {
      return pattern!.hasMatch(value);
    } else if (isArgument) {
      return true;
    } else {
      return id.toLowerCase() == value.toLowerCase();
    }
  }

  @override
  String toString() {
    return 'PathSegment(id: $id, pattern: $pattern)';
  }
}

class Path {
  const Path(this.segments);

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

  final List<PathSegment> segments;

  static const empty = Path([]);

  int get length => segments.length;
  bool get isEmpty => segments.isEmpty;

  bool get valid {
    if (segments.isEmpty) return false;
    for (final segment in segments) {
      if (segment.isArgument && segment.pattern != null) {
        return !segment.pattern!.isMultiLine;
      }
    }
    return true;
  }

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
      if (segment.isArgument) {
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

  /// Removes the last [count] segments from the match
  PathMatch pop([int count = 1]) {
    if (count <= 0) {
      return this;
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

class _RouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier, WidgetsBindingObserver {
  _RouteInformationProvider(this.router);

  final Router router;

  @override
  // TODO: implement value
  RouteInformation get value => throw UnimplementedError();
}

class _RouteInformationParser extends RouteInformationParser<PathMatch> {
  const _RouteInformationParser(this.registry);

  final ScreenRegistry registry;

  @override
  RouteInformation? restoreRouteInformation(PathMatch configuration) {
    return RouteInformation(
      uri: configuration.uri,
      state: configuration.state,
    );
  }

  @override
  Future<PathMatch> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) {
    final match = registry.resolve(
      context: ComponentContext.forContext(context),
      segments: routeInformation.uri.pathSegments,
    );
    return SynchronousFuture(match);
  }
}

class _RouterDelegate extends RouterDelegate<PathMatch> with ChangeNotifier {
  _RouterDelegate(this.registry);

  final ScreenRegistry registry;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      match: 
    );
  }

  @override
  Future<void> setInitialRoutePath(PathMatch configuration) {
    // TODO: implement setInitialRoutePath
    return super.setInitialRoutePath(configuration);
  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    throw UnimplementedError();
  }

  @override
  Future<void> setNewRoutePath(PathMatch configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}

class Router implements RouterConfig<PathMatch> {
  Router({
    required ScreenRegistry registry,
  })  : routeInformationProvider = _RouteInformationProvider(),
        routeInformationParser = const _RouteInformationParser(),
        routerDelegate = _RouterDelegate();

  @override
  final RouteInformationProvider routeInformationProvider;

  @override
  final RouteInformationParser<PathMatch> routeInformationParser;

  @override
  final RouterDelegate<PathMatch> routerDelegate;
}
