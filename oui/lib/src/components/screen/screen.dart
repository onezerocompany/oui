import 'package:oui/src/components/box/box_like.dart';

import '../../core/metadata/screen_metadata.dart';
import '../modifiable/modifier.dart';

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

/// Represents a screen in the OUI framework.
class Screen extends BoxLike<Screen> {
  /// The unique identifier of the screen.
  final String id;

  /// The type of the screen.
  final ScreenType type;

  /// The localized metadata for the screen.
  final ScreenMetadata metadata;

  /// The child screens of the screen.
  final List<Screen> children;

  const Screen({
    super.key,
    super.modifiers,
    super.content,
    required this.id,
    required this.metadata,
    this.type = ScreenType.panel,
    this.children = const [],
  });

  @override
  Screen copyWith({
    Modifiers? modifiers,
  }) {
    return Screen(
      key: key,
      id: id,
      metadata: metadata,
      content: content,
      type: type,
      modifiers: modifiers ?? this.modifiers,
      children: children,
    );
  }
}

/// A list of [Screen] instances.
typedef Screens = List<Screen>;
