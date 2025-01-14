import 'package:flutter/widgets.dart' show IconData, Key;
import 'package:oui/src/core/background.dart';
import 'package:oui/src/core/border.dart';
import 'package:oui/src/core/geometry.dart';

import '../components/box.dart';
import 'component.dart';
import 'localization.dart';
import 'metadata.dart';
import 'routing.dart';

///
/// This enum is used to specify how a screen should be displayed within the
/// application's user interface. The different screen types provide flexibility
/// in presenting content based on the available space and user interaction requirements.
///
/// - `panel`: Displays the screen within the scaffold if there is enough space.
///   If the screen does not fit within the scaffold, it will be shown as a sheet.
///   This type is useful for adaptive layouts where the screen can dynamically
///   adjust its presentation based on the available space.
///
/// - `sheet`: Always shows the screen as a sheet overlaying the scaffold.
///   This type is ideal for presenting supplementary content that does not
///   require full-screen attention, such as forms or additional options.
///
/// - `modal`: Displays the screen as a modal dialog, which requires user interaction
///   before returning to the underlying content. This type is suitable for
///   critical actions or information that needs to be acknowledged by the user.
enum ScreenType {
  panel,
  sheet,
  modal;

  ScreenType demote() {
    switch (this) {
      case ScreenType.panel:
        return ScreenType.sheet;
      case ScreenType.sheet:
        return ScreenType.sheet;
      case ScreenType.modal:
        return ScreenType.modal;
    }
  }
}

/// Provider class for resolving metadata about OUI screens.
///
/// This class extends [Metadata] to include additional metadata information
/// specific to OUI screens, such as the path segments.
///
/// The [path] parameter is required and represents the path segments of the screen.
/// The [name] parameter is required and represents the localized name of the screen.
/// The [icon] parameter is optional and represents the localized icon data of the screen.
/// The [attributes] parameter is optional and represents a map of additional localized
/// attributes for the screen.
class ScreenMetadata extends Metadata {
  final Localized<Path> path;

  ScreenMetadata({
    required this.path,
    required super.name,
    super.icon,
    super.attributes,
    super.tags,
  });

  ScreenMetadata.always({
    required Path path,
    required super.name,
    super.icon,
    super.attributes,
  })  : path = Localized.always(path),
        super.always();

  @override
  ScreenMetadata copyWith({
    Localized<Path>? path,
    Localized<String>? name,
    Localized<IconData?>? icon,
    Localized<List<String>>? tags,
    LocalizedMap<String, dynamic>? attributes,
  }) {
    return ScreenMetadata(
      path: path ?? this.path,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      tags: tags ?? this.tags,
      attributes: attributes ?? this.attributes,
    );
  }
}

/// Represents a screen in the OUI framework.
class Screen extends BoxLike<Screen> {
  /// The unique identifier of the screen.
  final String id;

  /// The type of the screen.
  final ScreenType type;

  /// The localized metadata for the screen.
  final ScreenMetadata metadata;

  /// The child screens of the screen.
  final List<Screen> _children;

  const Screen._({
    super.key,
    super.modifiers = const [
      BackgroundModifier(null, auto: true),
      BorderModifier(Border.all(BorderSide(thickness: 1))),
      AlignmentModifier(Alignment.center),
      SizeModifier(null),
    ],
    required this.id,
    required this.metadata,
    required this.type,
    List<Screen> children = const [],
  })  : _children = children,
        super();

  Screen(
    String id, {
    Key? key,
  }) : this._(
          key: key,
          id: id,
          type: ScreenType.panel,
          metadata: ScreenMetadata.always(
            name: id,
            path: Path.fromString(id),
          ),
          children: const [],
        );

  // : metadata = ScreenMetadata.always(
  //       name: id,
  //       path: [PathSegment.static(id)],
  //     ),
  //     type = ScreenType.panel,
  //     children = const [];

  @override
  Screen copyWith({
    ComponentModifiers? modifiers,
    ScreenType? type,
    ScreenMetadata? metadata,
    List<Screen>? children,
  }) {
    return Screen._(
      key: key,
      id: id,
      metadata: metadata ?? this.metadata,
      type: type ?? this.type,
      modifiers: modifiers ?? this.modifiers,
      children: children ?? _children,
    );
  }

  Screen withType(ScreenType type) {
    return copyWith(type: type);
  }

  Screen tags(
    List<String> tags, [
    Map<Locale, List<String>> localized = const {},
  ]) {
    return copyWith(
      metadata: metadata.copyWith(tags: Localized(tags, localized)),
    );
  }

  Screen name(
    String name, [
    Map<Locale, String> localized = const {},
  ]) {
    return copyWith(
      metadata: metadata.copyWith(name: Localized(name, localized)),
    );
  }

  Screen icon(
    IconData icon, [
    Map<Locale, IconData?> localized = const {},
  ]) {
    return copyWith(
      metadata: metadata.copyWith(icon: Localized(icon, localized)),
    );
  }

  Screen pathSegments(
    List<PathSegment> segments, [
    Map<Locale, Path> localized = const {},
  ]) {
    return copyWith(
      metadata: metadata.copyWith(path: Localized(Path(segments), localized)),
    );
  }

  Screen path(
    String path, [
    Map<Locale, String> localized = const {},
  ]) {
    return copyWith(
      metadata: metadata.copyWith(
        path: Localized(
          Path.fromString(path),
          localized.map(
            (key, value) {
              return MapEntry(key, Path.fromString(value));
            },
          ),
        ),
      ),
    );
  }

  Screen child(Screen child) {
    return copyWith(children: [..._children, child]);
  }

  Screen children(List<Screen> children) {
    return copyWith(children: [..._children, ...children]);
  }
}

/// A list of [Screen] instances.
typedef Screens = List<Screen>;

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
      final segments = screen.metadata.path.forLocale(locale).segments;
      final path = parentPath?.add(segments) ?? Path(segments);
      entries.add(ScreenRegistryEntry(screen, path, parents ?? []));
      for (final child in screen._children) {
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
