import 'package:flutter/widgets.dart' show FlutterError;

import 'config.dart' show Config;
import 'context.dart' show DynamicContext;
import 'localization.dart' show LocalizedExtension;
import 'routing.dart' show PathMatch, PathSegmentMatch;
import 'screen.dart' show Screen, Screens;
import 'utils.dart' show FirstWhereOrNullExtension;

class ScreenRegistry {
  const ScreenRegistry(this.roots);

  final List<Screen> roots;

  /// Creates a ScreenRegistry from the provided configuration
  factory ScreenRegistry.fromConfig(Config config) =>
      ScreenRegistry(config.registry.screens);

  List<Screen> _findScreens(Screen screen, {List<Screen> parents = const []}) {
    if (parents.isEmpty) {
      final rootMatch = roots.firstWhereOrNull((root) => root == screen);
      if (rootMatch != null) {
        return [rootMatch];
      }

      // Check if the screen is a child of any root
      for (final root in roots) {
        final found = _findScreens(screen, parents: [root]);
        if (found.isNotEmpty) {
          return found;
        }
      }
    } else {
      final children = parents.last.children;
      for (final child in children) {
        if (child == screen) {
          return parents + [child];
        }
        final found = _findScreens(child, parents: parents + [child]);
        if (found.isNotEmpty) {
          return found;
        }
      }
    }

    return [];
  }

  // Create a match for the screen
  PathMatch _matchForScreen(
    DynamicContext context,
    Screen screen, {
    Map<String, String> arguments = const {},
  }) {
    final screens = _findScreens(screen);

    // Add this validation
    if (screens.isEmpty) {
      throw FlutterError(
        'Screen not found in the registry: $screen',
      );
    }

    final List<PathSegmentMatch> segments = [];

    for (final screen in screens) {
      final path = screen.metadata.path.resolve(context);
      for (final segment in path?.segments ?? []) {
        if (segment.pattern != null) {
          final value = arguments[segment.id];
          segments.add(
            PathSegmentMatch(
              id: segment.id,
              original: value ?? segment.id,
              isArgument: true,
            ),
          );
        } else {
          segments.add(
            PathSegmentMatch(
              id: segment.id,
              original: segment.id,
              isArgument: false,
            ),
          );
        }
      }
    }

    return PathMatch(
      segments: segments,
      leftovers: [],
      matchRate: 1.0,
      screens: screens,
    );
  }

  List<PathMatch> _resolveScreen(
    DynamicContext context,
    Screen screen,
    Uri uri, {
    Screens screens = const [],
  }) {
    final matches = <PathMatch>[];
    final match =
        screen.metadata.path.resolve(context)?.match(uri, screens + [screen]);
    if (match != null) {
      matches.add(match);
    }
    for (final child in screen.children) {
      matches.addAll(
        _resolveScreen(
          context,
          child,
          uri,
          screens: screens + [screen],
        ),
      );
    }
    return matches;
  }

  PathMatch _resolveUri(
    DynamicContext context,
    Uri uri, {
    int redirectCount = 0,
  }) {
    final matches = <PathMatch>[];

    final availableRoots = roots.where((root) => root.available(context));
    if (availableRoots.isEmpty) {
      throw FlutterError(
        'No available roots found in the screen registry.',
      );
    }

    for (final root in availableRoots) {
      matches.addAll(
        _resolveScreen(context, root, uri),
      );
    }

    // Sort the matches by matchRate and get the best match
    // if there are multiple matches with a matchRate of 1.0
    // pick the one with the most segments
    if (matches.isNotEmpty) {
      matches.sort((a, b) {
        // First compare by matchRate (higher is better)
        final rateComparison = b.matchRate.compareTo(a.matchRate);
        if (rateComparison != 0) {
          return rateComparison;
        }
        // If matchRates are equal, compare by segment count (higher is better)
        return b.segments.length.compareTo(a.segments.length);
      });
    }

    final bestMatch =
        matches.firstOrNull ?? _matchForScreen(context, availableRoots.first);
    final redirect = bestMatch.screens.last.redirect(context);
    if (redirect != null) {
      if (redirectCount > 5) {
        throw FlutterError(
          'Too many redirects while resolving URI: $uri',
        );
      }
      return _resolveUri(
        context,
        redirect,
        redirectCount: redirectCount + 1,
      );
    }

    return bestMatch;
  }

  PathMatch resolve(
    DynamicContext context, {
    Uri? uri,
    Screen? screen,
    Map<String, String> arguments = const {},
  }) {
    assert(
      uri != null || screen != null,
      'Either uri or screen must be provided.',
    );
    assert(
      uri == null || screen == null,
      'Only one of uri or screen can be provided.',
    );

    if (screen != null) {
      return _matchForScreen(context, screen, arguments: arguments);
    }

    return _resolveUri(context, uri!);
  }
}
