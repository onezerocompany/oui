import 'package:oui/oui.dart';

/// Represents an entry in the Oui screen registry.
///
/// This class holds a reference to a screen and its associated path,
/// and provides a method to match a list of path segments against the path.
class ScreenRegistryEntry {
  final Screen screen;
  final ScreenMetadata metadata;
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
    this.metadata,
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

  static ScreenRegistryEntries _buildEntries(
    Screens screens, [
    Locale? locale,
  ]) {
    final entries = <ScreenRegistryEntry>[];

    void addScreen(
      Screen screen, [
      Path? parentPath,
      List<Screen>? parents,
    ]) {
      if (entries
          .any((entry) => entry.screen.metadata.id == screen.metadata.id)) {
        throw Exception('Duplicate screen ID: ${screen.metadata.id}');
      }
      final segments = screen.metadata.path.forLocale(locale)?.segments ?? [];
      final path = parentPath?.add(segments) ?? Path(segments);
      entries.add(
        ScreenRegistryEntry(screen, screen.metadata, path, parents ?? []),
      );
      for (final child in screen.children) {
        addScreen(child, path, [...?parents, screen]);
      }
    }

    for (final screen in screens) {
      addScreen(screen);
    }

    entries.sort((a, b) => b.path.length.compareTo(a.path.length));

    return entries;
  }

  /// Builds the registry of screens for the given [root] and [locale].
  ///
  /// This method recursively adds screens and their paths to the registry,
  /// ensuring that the longest paths are matched first.
  static Localized<ScreenRegistryEntries> _buildRegistry(
    Screens screens,
    Locales supportedLocales,
  ) {
    Map<Locale, ScreenRegistryEntries> localized = {};
    for (final locale in supportedLocales) {
      localized[locale] = _buildEntries(screens, locale);
    }
    return localized;
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
    Screens screens, [
    Locales supportedLocales = const [Locale.en],
  ])  : assert(
          screens.every(
            (screen) => screen.metadata.type == ScreenDisplayType.panel,
          ),
          'Root screens must be of type Panel',
        ),
        _entries = _buildRegistry(screens, supportedLocales);

  factory ScreenRegistry.fromConfig(Config config) {
    return ScreenRegistry(
      config.registry.screens,
      config.locales,
    );
  }

  /// Retrieves the screen with the given [id].
  ///
  /// Returns the screen if found, otherwise returns null.
  Screen? getScreenById(String id) {
    for (final entry in _entries.forLocale(null) ?? []) {
      if (entry.screen.id == id) {
        return entry.screen;
      }
    }
    return null;
  }

  PathMatch get defaultRoute {
    for (final entry in _entries.forLocale(null) ?? []) {
      if (entry.path.isDefault) {
        return entry.path.match([], entry.screens);
      }
    }
  }

  /// Matches the given list of [segments] against the paths in the registry.
  ///
  /// Returns the best matching [PathMatch] object, or the root match if no
  /// match is found.
  PathMatch resolve({
    List<String> segments = const [],
    Screen? screen,
    required ComponentContext context,
  }) {
    final entries = _entries.resolve(context.build);
    List<PathMatch> matches = entries
        .map(
          (entry) => PathMatch(
            [entry.screen],
            [],
            leftovers,
            expectedSegmentCount,
          ),
        )
        .toList();

    if (screen != null) {
      for (final ScreenRegistryEntry entry in entries ?? []) {
        if (entry.screen == screen) {
          matches.add(entry.path.match([], entry.screens));
        }
      }
    } else if (segments.isNotEmpty) {
      matches = entries
              ?.map((entry) => entry.path.match(segments, entry.screens))
              .whereType<PathMatch>()
              .toList() ??
          [];
    }

    matches.sort((a, b) {
      final rateComparison = b.rate.compareTo(a.rate);
      if (rateComparison != 0) {
        return rateComparison;
      }
      return b.count.compareTo(a.count);
    });

    final bestMatch = matches.firstWhereOrNull(
      (match) => match.screens.every(
        (screen) => screen.available(context),
      ),
    );

    return bestMatch ?? matches.first;
  }

  /// Returns the number of entries in the registry.
  int get count => _entries.forLocale(null)?.length ?? 0;
}
