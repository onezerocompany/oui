import 'package:oui/oui.dart';

/// Represents a segment of a path in the Oui routing system.
class OuiPathSegment {
  /// Unique identifier for the path segment.
  final String id;

  /// Optional pattern to match the segment.
  final String? pattern;

  /// Indicates if the segment is parametric.
  final bool isParametric;

  /// Private constructor for creating a path segment.
  const OuiPathSegment._({
    required this.id,
    this.isParametric = false,
    this.pattern,
  }) : assert(id.length != 0, 'The id of a path segment cannot be empty.');

  /// Creates a static path segment.
  ///
  /// Example:
  /// ```dart
  /// var segment = OuiPathSegment.static('home');
  /// ```
  factory OuiPathSegment.static(String value) {
    assert(value.isNotEmpty, 'The value of a static segment cannot be empty.');
    return OuiPathSegment._(
      id: value,
      pattern: '^${RegExp.escape(value)}\$',
    );
  }

  /// Creates a parametric path segment with an optional pattern.
  ///
  /// This factory constructor allows you to create a path segment that can
  /// match a specific pattern, making it useful for defining dynamic routes.
  ///
  /// Example:
  /// ```dart
  /// // Create a segment that matches any digits
  /// var segment = OuiPathSegment.argument('id', pattern: r'\d+');
  ///
  /// // Create a segment without a specific pattern
  /// var segmentWithoutPattern = OuiPathSegment.argument('name');
  ///
  /// // Create a segment that matches any word characters
  /// var segmentWithWordPattern = OuiPathSegment.argument('username', pattern: r'\w+');
  /// ```
  ///
  /// [id] is the identifier for the path segment.
  /// [pattern] is an optional regular expression pattern that the segment should match.
  factory OuiPathSegment.argument(String id, {String? pattern}) {
    assert(id.isNotEmpty, 'The id of an argument segment cannot be empty.');
    if (pattern != null) {
      // check the pattern is valid
      try {
        RegExp(pattern);
      } catch (e) {
        throw FormatException(
          'The pattern for an argument segment is not a valid regular expression: $pattern',
        );
      }

      assert(
        RegExp(pattern).isMultiLine == false,
        'The pattern for an argument segment cannot be multiline.',
      );
    }
    return OuiPathSegment._(
      id: id,
      pattern: pattern,
      isParametric: true,
    );
  }

  /// Returns a string representation of the path segment.
  @override
  String toString() {
    return 'OuiPathSegment(id: $id, pattern: $pattern, isParametric: $isParametric)';
  }
}

/// A list of [OuiPathSegment]s.
typedef OuiPathSegments = List<OuiPathSegment>;

/// Represents a path in the OUI routing system composed of multiple segments.
///
/// A path is used to match and parse URL segments for routing purposes.
class OuiPath {
  /// The ordered list of segments that make up this path.
  final List<OuiPathSegment> segments;

  int get length => segments.length;

  /// Creates a new [OuiPath] with the given [segments].
  const OuiPath(this.segments);

  /// Returns true if this path contains no segments.
  bool get isEmpty => segments.isEmpty;

  static const empty = OuiPath([]);

  OuiPathMatch match(List<String> segments, List<OuiScreen> screens) {
    final matches = _segmentMatches(segments);
    final leftovers = segments.skip(matches.length).toList();
    return OuiPathMatch(
      screens,
      matches,
      leftovers,
      segments.length,
    );
  }

  /// Matches the given path segments against the defined segments.
  /// Returns a list of [OuiPathSegmentMatch] if all segments match, otherwise an empty list.
  List<OuiPathSegmentMatch> _segmentMatches(List<String> path) {
    final List<OuiPathSegmentMatch> matches = [];

    for (var i = 0; i < segments.length; i++) {
      final pathSegment = path.elementAtOrNull(i);
      if (pathSegment == null) {
        return matches;
      }

      final segment = segments[i];
      if (segment.isParametric) {
        if (!_matchParametricSegment(segment, pathSegment, matches)) {
          return matches;
        }
      } else {
        if (!_matchStaticSegment(segment, pathSegment, matches)) {
          return matches;
        }
      }
    }

    return matches;
  }

  /// Matches a parametric segment and adds it to the matches list if successful.
  bool _matchParametricSegment(
    OuiPathSegment segment,
    String pathSegment,
    List<OuiPathSegmentMatch> matches,
  ) {
    if (segment.pattern != null) {
      final match = RegExp(segment.pattern!).firstMatch(pathSegment);
      if (match != null) {
        final value = match.groupCount > 0 ? match.group(1) : match.group(0);
        matches.add(
          OuiPathSegmentMatch(
            segment: segment,
            original: pathSegment,
            value: value,
          ),
        );
        return true;
      }
      return false;
    } else {
      matches.add(
        OuiPathSegmentMatch(
          segment: segment,
          original: pathSegment,
          value: pathSegment,
        ),
      );
      return true;
    }
  }

  /// Matches a static segment and adds it to the matches list if successful.
  bool _matchStaticSegment(
    OuiPathSegment segment,
    String pathSegment,
    List<OuiPathSegmentMatch> matches,
  ) {
    if (segment.id == pathSegment.toLowerCase()) {
      matches.add(OuiPathSegmentMatch(segment: segment, original: pathSegment));
      return true;
    }
    return false;
  }

  /// Returns a new [OuiPath] with the given [segments] appended to the end.
  /// If [segments] is empty, returns this path.
  OuiPath add(List<OuiPathSegment> segments) {
    if (segments.isEmpty) {
      return this;
    }
    return OuiPath([...this.segments, ...segments]);
  }

  @override
  String toString() {
    return segments.map((s) => s.id).join('/');
  }
}
