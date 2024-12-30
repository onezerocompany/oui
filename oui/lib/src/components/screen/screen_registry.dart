import 'package:oui/src/core/localization/localized.dart';

import '../../core/localization/locale.dart';
import '../../core/router/path.dart';
import '../../core/router/path_match.dart';
import 'screen.dart';

/// Represents an entry in the Oui screen registry.
///
/// This class holds a reference to a screen and its associated path,
/// and provides a method to match a list of path segments against the path.
class ScreenRegistryEntry {
  final Screen screen;
  final Path path;
  final List<Screen> parents;

  /// Creates a new registry entry with the given screen and path.
  ///
  /// The [screen] parameter is the screen associated with this entry.
  /// The [path] parameter is the path associated with this entry.
  ///
  /// Example:
  /// ```dart
  /// final screen = Screen(...);
  /// final path = Path(...);
  /// final entry = ScreenRegistryEntry(screen, path);
  /// ```
  const ScreenRegistryEntry(
    this.screen,
    this.path, [
    this.parents = const [],
  ]);

  /// Matches the given list of path segments against the path of this entry.
  ///
  /// Returns a [PathMatch] object if the segments match the path,
  /// otherwise returns null.
  PathMatch match(List<String> segments) {
    return path.match(segments, screens);
  }

  List<Screen> get screens => [...parents, screen];
}

typedef ScreenRegistryEntries = List<ScreenRegistryEntry>;

/// Represents a registry of screens for the Oui routing system.
///
/// This class holds a list of screen registry entries and provides a method
/// to match a list of path segments against the registry.
class ScreenRegistry {
  final Localized<ScreenRegistryEntries> _entries;
  final PathMatch _rootMatch;

  static ScreenRegistryEntries _buildEntries(Screen root, [Locale? locale]) {
    final entries = <ScreenRegistryEntry>[];

    void addScreen(
      Screen screen, [
      Path? parentPath,
      List<Screen>? parents,
    ]) {
      if (entries.any((entry) => entry.screen.id == screen.id)) {
        throw Exception('Duplicate screen ID: ${screen.id}');
      }
      final segments = screen.metadata.forLocale(locale).path;
      final path = parentPath?.add(segments) ?? Path(segments);
      entries.add(ScreenRegistryEntry(screen, path, parents ?? []));
      for (final child in screen.children) {
        addScreen(child, path, [...?parents, screen]);
      }
    }

    addScreen(root);

    entries.sort((a, b) => b.path.length.compareTo(a.path.length));

    return entries;
  }

  /// Builds the registry of screens for the given [root] and [locale].
  ///
  /// This method recursively adds screens and their paths to the registry,
  /// ensuring that the longest paths are matched first.
  static Localized<ScreenRegistryEntries> _buildRegistry(
    Screen root,
    Locales supportedLocales,
  ) {
    Map<Locale, ScreenRegistryEntries> localized = {};
    for (final locale in supportedLocales) {
      localized[locale] = _buildEntries(root, locale);
    }

    return Localized(_buildEntries(root), localized);
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
  /// final screen = Screen(...);
  /// final locale = Locale(...);
  /// final registry = ScreenRegistry(screen, locale);
  /// ```
  ScreenRegistry(
    Screen screen, [
    Locales supportedLocales = const [Locale.english],
  ])  : assert(
          screen.type == ScreenType.panel,
          'Root screen must be of type Panel',
        ),
        _entries = _buildRegistry(screen, supportedLocales),
        _rootMatch = PathMatch([screen], [], [], 0);

  /// Retrieves the screen with the given [id].
  ///
  /// Returns the screen if found, otherwise returns null.
  Screen? getScreenById(String id) {
    for (final entry in _entries.base) {
      if (entry.screen.id == id) {
        return entry.screen;
      }
    }
    return null;
  }

  /// Matches the given list of [segments] against the paths in the registry.
  ///
  /// Returns the best matching [PathMatch] object, or the root match if no
  /// match is found.
  PathMatch match(List<String> segments, [Locale? locale]) {
    if (segments.isEmpty) {
      return _rootMatch;
    }

    final matches = _entries
        .forLocale(locale)
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
  int get count => _entries.base.length;
}
