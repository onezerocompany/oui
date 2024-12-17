import 'package:oui/oui.dart';

export 'oui_screen_registry.dart';
export 'oui_screen_metadata.dart';
export 'oui_screen_size.dart';

/// Defines the possible types of screens in the OUI framework.
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
///
/// - `fullscreen`: Covers the entire scaffold with the screen, providing an
///   immersive experience. This type is best for content that requires the user's
///   full attention, such as media playback or detailed data views.
enum OuiScreenType {
  panel,
  sheet,
  modal,
  fullscreen,
}

/// Represents a screen in the OUI framework.
class OuiScreen {
  /// The unique identifier of the screen.
  final String id;

  /// The type of the screen.
  final OuiScreenType type;

  /// The localized metadata for the screen.
  final OuiLocalized<OuiScreenMetadata> metadata;

  /// The size constraints for the screen.
  final OuiScreenSize size;

  /// The child screens of the screen.
  final List<OuiScreen> children;

  /// The builder function for the screen.
  final WidgetBuilder builder;

  /// A screen widget for the Oui application.
  ///
  /// The `OuiScreen` widget is used to display a screen with specific properties
  /// such as an identifier, metadata, a builder function, size, type, and children.
  ///
  /// Parameters:
  /// - `id`: A unique identifier for the screen.
  /// - `metadata`: Metadata associated with the screen.
  /// - `builder`: A function that builds the content of the screen.
  /// - `size`: The size of the screen. Defaults to an instance of `OuiScreenSize`.
  /// - `type`: The type of the screen. Defaults to `OuiScreenType.panel`.
  /// - `children`: A list of child widgets to be displayed within the screen. Defaults to an empty list.
  ///
  /// Example usage:
  /// ```dart
  /// OuiScreen(
  ///   id: 'screen1',
  ///   metadata: someMetadata,
  ///   builder: (context) => SomeWidget(),
  ///   size: OuiScreenSize(width: 100, height: 200),
  ///   type: OuiScreenType.panel,
  ///   children: [ChildWidget1(), ChildWidget2()],
  /// );
  /// ```
  const OuiScreen({
    required this.id,
    required this.metadata,
    required this.builder,
    this.size = const OuiScreenSize(),
    this.type = OuiScreenType.panel,
    this.children = const [],
  });

  /// Returns a string representation of the screen.
  @override
  String toString() {
    return 'OuiScreen($id, $type)';
  }
}

/// A list of [OuiScreen] instances.
typedef OuiScreens = List<OuiScreen>;
