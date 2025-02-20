import 'package:flutter/widgets.dart' show IconData, Key;
import 'package:oui/src/core/background.dart';
import 'package:oui/src/core/border.dart';
import 'package:oui/src/core/geometry.dart';
import 'package:oui/src/core/locales.dart' show Locale;

import '../core/component.dart';
import '../core/localization.dart';
import '../core/metadata.dart';
import '../core/routing.dart';
import 'box.dart';

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
enum ScreenDisplayType {
  panel,
  sheet,
  modal;

  ScreenDisplayType demote() {
    switch (this) {
      case ScreenDisplayType.panel:
        return ScreenDisplayType.sheet;
      case ScreenDisplayType.sheet:
        return ScreenDisplayType.sheet;
      case ScreenDisplayType.modal:
        return ScreenDisplayType.modal;
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

  @override
  ScreenMetadata copyWith({
    Localized<Path>? path,
    Localized<String>? name,
    Localized<IconData?>? icon,
    Localized<List<String>>? tags,
    Localized<Map<String, dynamic>>? attributes,
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
  final ScreenDisplayType type;

  /// The localized metadata for the screen.
  final ScreenMetadata metadata;

  /// The child screens of the screen.
  final List<Screen> childScreens;

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
    this.childScreens = const [],
  });

  Screen(
    String id, {
    Key? key,
  }) : this._(
          key: key,
          id: id,
          type: ScreenDisplayType.panel,
          metadata: ScreenMetadata(
            name: {Locale.any: id},
            path: {Locale.any: Path.fromString(id)},
          ),
          childScreens: const [],
        );

  @override
  Screen copyWith({
    ComponentModifiers? modifiers,
    ScreenDisplayType? type,
    ScreenMetadata? metadata,
    List<Screen>? children,
  }) {
    return Screen._(
      key: key,
      id: id,
      metadata: metadata ?? this.metadata,
      type: type ?? this.type,
      modifiers: modifiers ?? this.modifiers,
      childScreens: children ?? childScreens,
    );
  }

  Screen display(ScreenDisplayType type) {
    return copyWith(type: type);
  }

  Screen tags(Localized<List<String>> tags) {
    return copyWith(metadata: metadata.copyWith(tags: tags));
  }

  Screen name(Localized<String> name) {
    return copyWith(metadata: metadata.copyWith(name: name));
  }

  Screen icon(Localized<IconData> icon) {
    return copyWith(metadata: metadata.copyWith(icon: icon));
  }

  Screen pathSegments(Localized<PathSegments> segments) {
    return copyWith(
      metadata: metadata.copyWith(
        path: segments.mapped<Path>((value) => Path(value)),
      ),
      // metadata: metadata.copyWith(path: Localized(Path(segments), localized)),
    );
  }

  Screen path(Map<Locale, String> path) {
    return copyWith(
      metadata: metadata.copyWith(
        path: path.mapped((value) => Path.fromString(value)),
      ),
    );
  }

  Screen child(Screen child) {
    return copyWith(children: [...childScreens, child]);
  }

  Screen children(List<Screen> children) {
    return copyWith(children: [...childScreens, ...children]);
  }
}

/// A list of [Screen] instances.
typedef Screens = List<Screen>;
