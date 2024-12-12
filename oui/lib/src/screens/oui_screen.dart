import 'package:oui/oui.dart';

/// Defines the possible types of screens in the OUI framework.
///
/// - [fullscreen]: Occupies the entire screen space
/// - [screen]: Standard screen with normal layout
/// - [modal]: Displays as a modal dialog
/// - [sheet]: Displays as a bottom sheet
enum OuiScreenType {
  fullscreen,
  screen,
  modal,
  sheet,
}

/// Type alias for a list of OuiScreen instances
typedef OuiScreens = List<OuiScreen>;

/// An abstract widget that represents a screen in the OUI framework.
///
/// This class serves as the base for all screen implementations and provides
/// routing capabilities through path matching and child screen management.
abstract class OuiScreen extends HookConsumerWidget {
  /// Creates an OuiScreen with optional child screens.
  const OuiScreen({
    super.key,
    this.children = const [],
  });

  /// List of child screens that can be nested under this screen.
  final List<OuiScreen> children;

  /// Unique identifier for the screen.
  String get id;

  /// The type of screen this instance represents.
  /// Defaults to [OuiScreenType.screen].
  OuiScreenType get type => OuiScreenType.screen;

  /// Icon data for the screen, with localization support.
  Localized<IconData?> get icon => const Localized(null);

  /// The path pattern for this screen, with localization support.
  Localized<OuiPath> get path => Localized(
        OuiPath(
          [OuiPathSegment.static(id)],
        ),
      );

  /// Find the best matching child screen for the given URL segments.
  /// Match the one that has the most segments in common with the URL.
  OuiPathMatch _bestChild(
    List<String> segments,
    Locale locale,
  ) {
    final childMatches = children
        .map((child) => child.match(segments, locale))
        .where((childMatch) => childMatch.isMatch)
        .toList();
    if (childMatches.isNotEmpty) {
      childMatches.sort((a, b) => a.count.compareTo(b.count));
      return childMatches.first;
    }
    return OuiPathMatch.noMatch;
  }

  /// Matches the given URL segments against this screen's path pattern.
  ///
  /// [segments] - URL segments to match against
  /// [locale] - Current locale for path localization
  ///
  /// Returns a [OuiPathMatch] indicating whether the path matches and contains
  /// any remaining segments for child routing.
  OuiPathMatch match(
    List<String> segments,
    Locale locale,
  ) {
    final match = OuiPathMatch.forScreen(this, segments, locale);
    if (match.isMatch) {
      final remaining = segments.skip(match.count).toList();
      final childMatch = _bestChild(remaining, locale);
      if (childMatch.isMatch) {
        return match.add(
          childMatch,
          leftovers: remaining,
        );
      }
    }
    return match;
  }
}
