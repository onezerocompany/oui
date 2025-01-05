import 'package:flutter/src/widgets/framework.dart';
import 'package:oui/oui.dart';

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
class Screen extends Modifiable<Screen>
    with
        ModifiableSize<Screen>,
        ModifiableAlignment<Screen>,
        ModifiableCorner<Screen>,
        ModifiableBackground<Screen>,
        ModifiableInset<Screen>,
        ModifiableBorder<Screen>,
        ModifiableShadow<Screen> {
  /// The unique identifier of the screen.
  final String id;

  /// The type of the screen.
  final ScreenType type;

  /// The localized metadata for the screen.
  final Localized<ScreenMetadata> metadata;

  /// The child screens of the screen.
  final List<Screen> children;

  /// The content of the screen.
  final Widget content;

  /// A screen widget for the Oui framework.
  ///
  /// The `Screen` widget is used to display a screen with specific properties
  /// such as an identifier, metadata, a builder function, size, type, and children.
  ///
  /// Parameters:
  /// - `id`: A unique identifier for the screen.
  /// - `metadata`: Metadata associated with the screen.
  /// - `builder`: A function that builds the content of the screen.
  /// - `size`: The size of the screen. Defaults to an instance of `Size`.
  /// - `type`: The type of the screen. Defaults to `ScreenType.panel`.
  /// - `children`: A list of child widgets to be displayed within the screen. Defaults to an empty list.
  /// - `background`: An optional background for the screen.
  ///
  /// Example usage:
  /// ```dart
  /// Screen(
  ///   id: 'screen1',
  ///   metadata: someMetadata,
  ///   builder: (context) => SomeWidget(),
  ///   size: ScreenSize(width: 100, height: 200),
  ///   type: ScreenType.panel,
  ///   children: [ChildWidget1(), ChildWidget2()],
  ///   background: someBackground,
  /// );
  /// ```
  const Screen({
    super.key,
    super.modifiers,
    required this.id,
    required this.metadata,
    required this.content,
    this.type = ScreenType.panel,
    this.children = const [],
  });

  @override
  Screen copyWith({Modifiers? modifiers}) {
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

  @override
  Widget build(BuildContext context) {
    return buildWithModifiers(content, context);
  }
}

/// A list of [Screen] instances.
typedef Screens = List<Screen>;
