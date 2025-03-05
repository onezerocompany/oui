import 'package:flutter/foundation.dart' show ChangeNotifier, SynchronousFuture;
import 'package:flutter/widgets.dart'
    show
        BackButtonDispatcher,
        BuildContext,
        ChangeNotifier,
        RouteInformation,
        RouteInformationParser,
        RouteInformationProvider,
        RouteInformationReportingType,
        RouterConfig,
        RouterDelegate,
        Widget;
import 'package:oui/oui.dart';

class PathSegment {
  const PathSegment._(this.id, this.pattern);

  factory PathSegment.static(String value) {
    assert(
      value.isNotEmpty,
      'The value of a static segment cannot be empty.',
    );
    return PathSegment._(value, null);
  }

  factory PathSegment.argument(
    String id, {
    RegExp? pattern,
  }) {
    final resolvedPattern = pattern ?? RegExp(r'.*');
    assert(
      !resolvedPattern.isMultiLine,
      'The pattern of an argument segment cannot be multi-line.',
    );
    assert(
      id.isNotEmpty,
      'The id of an argument segment cannot be empty.',
    );
    return PathSegment._(
      id,
      resolvedPattern,
    );
  }

  final String id;
  final RegExp? pattern;

  PathSegmentMatch? match(String value) {
    if (pattern != null) {
      final match = pattern!.firstMatch(value);
      if (match != null) {
        final resolved = match.groupCount > 0 ? match.group(1) : match.group(0);
        return PathSegmentMatch(
          id: id,
          original: value,
          isArgument: true,
          value: resolved,
        );
      }
    } else if (id.toLowerCase() == value.toLowerCase()) {
      return PathSegmentMatch(
        id: id,
        original: value,
        isArgument: false,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PathSegment &&
        other.id == id &&
        (other.pattern?.pattern == pattern?.pattern);
  }

  @override
  int get hashCode => Object.hash(id, pattern?.pattern);

  @override
  String toString() {
    return 'PathSegment(id: $id, pattern: $pattern)';
  }
}

class PathSegmentMatch {
  const PathSegmentMatch({
    required this.id,
    required this.original,
    required this.isArgument,
    String? value,
  }) : _value = value;

  final String id;
  final String original;
  final bool isArgument;
  final String? _value;

  String get content => _value ?? original;

  @override
  String toString() {
    return 'PathSegmentMatch(id: $id, original: $original, value: $content)';
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

  // Finds all the segments that match the given path segments
  // When a segment is not found, the search stops
  // Returns a list of PathMatch objects
  List<PathSegmentMatch> _matchingSegments(List<String> path) {
    final List<PathSegmentMatch> matches = [];

    for (var i = 0; i < segments.length; i++) {
      final pathSegment = path.elementAtOrNull(i);

      // Stop searching if there are no more segments
      if (pathSegment == null) return matches;

      final segment = segments[i];
      final match = segment.match(pathSegment);
      if (match != null) {
        matches.add(match);
      } else {
        return matches;
      }
    }

    return matches;
  }

  PathMatch match(Uri uri, List<Screen> screens) {
    final matches = _matchingSegments(uri.pathSegments);
    return PathMatch(
      segments: matches,
      leftovers: uri.pathSegments.skip(matches.length).toList(),
      matchRate: segments.isEmpty ? 0.0 : matches.length / segments.length,
      screens: screens,
    );
  }
}

class PathMatch {
  const PathMatch({
    required this.segments,
    required this.leftovers,
    required this.matchRate,
    required this.screens,
  });

  // Segments that matched the pattern
  final List<PathSegmentMatch> segments;

  // Segments from the path that didn't match any pattern
  final List<String> leftovers;

  // Amount of segments that matched relative to the expected amount
  // e.g. if 2 segments were expected and 1 matched, this would be 0.5
  final double matchRate;

  // The screens associated with the matched path segments
  final List<Screen> screens;

  // Whether the path can be popped
  bool get canPop => screens.isNotEmpty;

  // Uri constructed from the matched segments
  Uri get uri => Uri(path: '/${segments.map((s) => s.original).join('/')}');

  // Parameters from the matched argument segments
  Map<String, String> get parameters {
    final params = <String, String>{};
    for (final segment in segments) {
      if (segment.isArgument) {
        params[segment.id] = segment.content;
      }
    }
    return params;
  }

  // Returns the value of a parameter by its key
  String? operator [](String key) => parameters[key];

  @override
  String toString() {
    return 'PathMatch(segments: $segments, leftovers: $leftovers, matchRate: $matchRate, screens: $screens)';
  }
}

class _BackButtonDispatcher extends BackButtonDispatcher {
  _BackButtonDispatcher(this.delegate);

  final RouterDelegate<PathMatch> delegate;

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) async {
    return await delegate.popRoute();
  }
}

class _RouteInformationParser extends RouteInformationParser<PathMatch> {
  _RouteInformationParser(this.registry, this.config);

  final ScreenRegistry registry;
  final Config config;

  @override
  Future<PathMatch> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext buildContext,
  ) {
    final context = DynamicContext.of(buildContext);
    final match = registry.resolve(context, uri: routeInformation.uri);
    return SynchronousFuture(match);
  }
}

class _RouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  _RouteInformationProvider(this.registry)
      : _value = RouteInformation(
          uri: Uri(path: '/'),
        );

  final ScreenRegistry registry;

  @override
  RouteInformation get value => _value;
  RouteInformation _value;

  Future<void> navigate(
    DynamicContext context, {
    String? path,
    Screen? screen,
    Map<String, String> arguments = const {},
  }) async {
    assert(
      path != null || screen != null,
      'Either path or screen must be provided.',
    );

    RouteInformation routeInfo;
    if (path != null) {
      final uri = Uri.parse(path);
      final match = registry.resolve(context, uri: uri);
      routeInfo = RouteInformation(uri: match.uri);
    } else {
      final match = registry.resolve(
        context,
        screen: screen!,
        arguments: arguments,
      );
      routeInfo = RouteInformation(uri: match.uri);
    }

    if (_value.uri != routeInfo.uri) {
      _value = routeInfo;
      notifyListeners();
    }
  }

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    RouteInformationReportingType type = RouteInformationReportingType.none,
  }) {
    if (_value.uri != routeInformation.uri) {
      _value = routeInformation;
      notifyListeners();
    }
  }

  void refresh() {
    notifyListeners();
  }
}

class _RouterDelegate extends RouterDelegate<PathMatch> with ChangeNotifier {
  _RouterDelegate(this.config);

  PathMatch? _currentMatch;
  final Config config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      currentMatch: _currentMatch,
      config: config,
    );
  }

  @override
  Future<bool> popRoute() async {
    if (_currentMatch == null || !_currentMatch!.canPop) {
      return false;
    }

    // Remove the last screen and create a new match with the remaining screens
    final updatedScreens =
        _currentMatch!.screens.sublist(0, _currentMatch!.screens.length - 1);
    if (updatedScreens.isEmpty) {
      return false;
    }

    // Create a new match with one less screen
    _currentMatch = PathMatch(
      segments: _currentMatch!.segments,
      leftovers: _currentMatch!.leftovers,
      matchRate: _currentMatch!.matchRate,
      screens: updatedScreens,
    );

    notifyListeners();
    return true;
  }

  @override
  PathMatch? get currentConfiguration => _currentMatch;

  @override
  Future<void> setNewRoutePath(PathMatch configuration) {
    if (configuration != _currentMatch) {
      _currentMatch = configuration;
      notifyListeners();
    }
    return SynchronousFuture(null);
  }
}

class Router implements RouterConfig<PathMatch> {
  Router(
    ScreenRegistry registry,
    Config config,
    AuthProvider? auth,
  ) {
    routerDelegate = _RouterDelegate(config);
    backButtonDispatcher = _BackButtonDispatcher(routerDelegate);
    routeInformationParser = _RouteInformationParser(registry, config);
    routeInformationProvider = _RouteInformationProvider(registry);
    auth?.addListener(() {
      refresh();
    });
  }

  @override
  late final BackButtonDispatcher backButtonDispatcher;

  @override
  late final RouteInformationParser<PathMatch> routeInformationParser;

  @override
  late final RouteInformationProvider routeInformationProvider;

  @override
  late final RouterDelegate<PathMatch> routerDelegate;

  void refresh() {
    final provider = routeInformationProvider as _RouteInformationProvider;
    return provider.refresh();
  }

  /// Navigates to the given path or screen with the provided arguments
  Future<void> navigate(
    DynamicContext context, {
    String? path,
    Screen? screen,
    Map<String, String> arguments = const {},
  }) {
    final provider = routeInformationProvider as _RouteInformationProvider;
    return provider.navigate(
      context,
      path: path,
      screen: screen,
      arguments: arguments,
    );
  }
}
