import 'package:oui/oui.dart';

/// Represents a matched segment in a path, containing the original segment,
/// its potential value, and the segment pattern that matched it.
class OuiPathMatchSegment {
  /// The pattern segment that was matched
  final OuiPathSegment segment;

  /// The parsed value of the segment, if any
  final String? _value;

  /// The original segment string from the path
  final String original;

  /// The identifier of the segment pattern
  String get id => segment.id;

  /// The content of the segment, either the parsed value or original string
  String get content => _value ?? original;

  const OuiPathMatchSegment({
    required this.segment,
    required this.original,
    String? value,
  }) : _value = value;
}

/// Represents the result of matching a path against a route pattern.
/// Contains information about whether the path matches, how many segments matched,
/// the matched screens, and any path arguments that were extracted.
class OuiPathMatch {
  /// List of segments that matched the pattern
  final List<OuiPathMatchSegment> segments;

  /// Segments from the path that didn't match any pattern
  final List<String> leftovers;

  /// The screens associated with the matched path segments
  final List<OuiScreen> screens;

  /// The original segments from the path, before any value parsing
  List<String> get rawSegments =>
      segments.map((segment) => segment.original).toList();

  /// Whether the path matched any segments
  bool get isMatch => segments.isNotEmpty;

  /// Constructs a Uri from the matched raw segments
  Uri get uri => Uri(pathSegments: rawSegments);

  /// Number of segments that matched
  int get count => segments.length;

  const OuiPathMatch._({
    required this.segments,
    required this.leftovers,
    required this.screens,
  });

  /// Creates a match with a single screen
  factory OuiPathMatch.forScreen(
    OuiScreen screen,
    List<String> segments,
    Locale locale,
  ) {
    final path = screen.path.forLocale(locale);
    final matches = path.matches(segments);
    if (matches.length == path.length) {
      return OuiPathMatch._(
        segments: matches,
        screens: [screen],
        leftovers: segments.skip(matches.length).toList(),
      );
    }
    return noMatch;
  }

  /// Represents no match found
  static const noMatch = OuiPathMatch._(
    segments: [],
    leftovers: [],
    screens: [],
  );

  /// Combines this match with another match, concatenating their segments,
  /// leftovers, and screens
  OuiPathMatch add(
    OuiPathMatch child, {
    List<String> leftovers = const [],
  }) {
    return OuiPathMatch._(
      segments: [...segments, ...child.segments],
      screens: [...screens, ...child.screens],
      leftovers: leftovers,
    );
  }

  @override
  String toString() {
    return 'OuiPathMatch(segments: $segments, leftovers: $leftovers, screens: $screens)';
  }
}
