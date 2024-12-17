import 'package:oui/oui.dart';

/// Represents an entry in the Oui screen registry.
///
/// This class holds a reference to a screen and its associated path,
/// and provides a method to match a list of path segments against the path.
class OuiScreenRegistryEntry {
  final OuiScreen screen;
  final OuiPath path;
  final List<OuiScreen> parents;

  /// Creates a new registry entry with the given screen and path.
  ///
  /// The [screen] parameter is the screen associated with this entry.
  /// The [path] parameter is the path associated with this entry.
  ///
  /// Example:
  /// ```dart
  /// final screen = OuiScreen(...);
  /// final path = OuiPath(...);
  /// final entry = OuiScreenRegistryEntry(screen, path);
  /// ```
  const OuiScreenRegistryEntry(
    this.screen,
    this.path, [
    this.parents = const [],
  ]);

  /// Matches the given list of path segments against the path of this entry.
  ///
  /// Returns a [OuiPathMatch] object if the segments match the path,
  /// otherwise returns null.
  OuiPathMatch match(List<String> segments) {
    return path.match(segments, screens);
  }

  List<OuiScreen> get screens => [...parents, screen];
}

/// Represents a registry of screens for the Oui routing system.
///
/// This class holds a list of screen registry entries and provides a method
/// to match a list of path segments against the registry.
class OuiScreenRegistry {
  final List<OuiScreenRegistryEntry> _entries;
  final OuiPathMatch _rootMatch;

  /// Builds the registry of screens for the given [screen] and [locale].
  ///
  /// This method recursively adds screens and their paths to the registry,
  /// ensuring that the longest paths are matched first.
  static List<OuiScreenRegistryEntry> _buildRegistry(
    OuiScreen screen,
    OuiLocale? locale,
  ) {
    final screens = <OuiScreenRegistryEntry>[];

    void addScreen(
      OuiScreen screen, [
      OuiPath? parentPath,
      List<OuiScreen>? parents,
    ]) {
      if (screens.any((entry) => entry.screen.id == screen.id)) {
        throw Exception('Duplicate screen ID: ${screen.id}');
      }
      final segments = screen.metadata.forLocale(locale).path;
      final path = parentPath?.add(segments) ?? OuiPath(segments);
      screens.add(OuiScreenRegistryEntry(screen, path, parents ?? []));
      for (final child in screen.children) {
        addScreen(child, path, [...?parents, screen]);
      }
    }

    addScreen(screen);

    // sort the screens by path length so that the longest paths are matched
    // first, allowing for more specific paths to be matched earlier
    screens.sort((a, b) => b.path.length.compareTo(a.path.length));

    return screens;
  }

  /// Creates a new screen registry for the given [screen] and [locale].
  ///
  /// The registry is built by recursively adding screens and their paths,
  /// and sorting them by path length.
  ///
  /// The [screen] parameter is the root screen of the registry.
  /// The [locale] parameter is the locale to use for screen metadata.
  ///
  /// Example:
  /// ```dart
  /// final screen = OuiScreen(...);
  /// final locale = OuiLocale(...);
  /// final registry = OuiScreenRegistry(screen, locale);
  /// ```
  OuiScreenRegistry(
    OuiScreen screen,
    OuiLocale? locale,
  )   : _entries = _buildRegistry(
          screen,
          locale,
        ),
        _rootMatch = OuiPathMatch([screen], [], [], 0);

  /// Retrieves the screen with the given [id].
  ///
  /// Returns the screen if found, otherwise returns null.
  OuiScreen? getScreenById(String id) {
    for (final entry in _entries) {
      if (entry.screen.id == id) {
        return entry.screen;
      }
    }
    return null;
  }

  /// Matches the given list of [segments] against the paths in the registry.
  ///
  /// Returns the best matching [OuiPathMatch] object, or the root match if no
  /// match is found.
  OuiPathMatch match(List<String> segments) {
    if (segments.isEmpty) {
      return _rootMatch;
    }

    final matches = _entries
        .where((entry) => entry.path.length <= segments.length)
        .map((entry) => entry.path.match(segments, entry.screens))
        .toList();

    matches.sort((a, b) {
      final rateComparison = b.rate.compareTo(a.rate);
      if (rateComparison != 0) {
        return rateComparison;
      }
      return b.count.compareTo(a.count);
    });

    return matches.firstOrNull ?? _rootMatch;
  }

  /// Returns the number of entries in the registry.
  int get count => _entries.length;
}
