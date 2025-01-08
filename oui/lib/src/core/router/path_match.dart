import '../../components/screen/screen.dart';
import 'path.dart';

/// Represents a match for a specific path segment.
///
/// This class holds details about a path segment, its original value,
/// and an optional transformed value.
///
/// Example usage:
/// ```dart
/// final segment = PathSegment(id: 'userId');
/// final match = PathSegmentMatch(
///   segment: segment,
///   original: '123',
///   value: 'user_123',
/// );
/// print(match.id);       // Outputs: 'userId'
/// print(match.content);  // Outputs: 'user_123'
/// ```
class PathSegmentMatch {
  /// The segment associated with this match.
  final PathSegment segment;

  /// The optional value of the segment match.
  ///
  /// If `_value` is `null`, the [original] value will be used as the content.
  final String? _value;

  /// The original value of the path segment match.
  final String original;

  /// A unique identifier derived from the associated [segment].
  String get id => segment.id;

  /// The effective content of the match.
  ///
  /// Returns the transformed `_value` if provided; otherwise, returns [original].
  String get content => _value ?? original;

  /// Creates an instance of [PathSegmentMatch].
  ///
  /// - [segment]: The path segment associated with this match.
  /// - [original]: The original value of the path segment.
  /// - [value]: An optional transformed value for the segment.
  ///
  /// Example:
  /// ```dart
  /// final segment = PathSegment(id: 'userId');
  /// final match = PathSegmentMatch(
  ///   segment: segment,
  ///   original: '123',
  ///   value: 'user_123',
  /// );
  /// ```
  const PathSegmentMatch({
    required this.segment,
    required this.original,
    String? value,
  }) : _value = value;
}

/// A list of [PathSegmentMatch] objects.
typedef PathSegmentMatches = List<PathSegmentMatch>;

/// Represents the result of matching a path against a route pattern.
/// Contains information about whether the path matches, how many segments matched,
/// the matched screens, and any path arguments that were extracted.
class PathMatch {
  /// List of segments that matched the pattern
  final List<PathSegmentMatch> segments;

  /// Segments from the path that didn't match any pattern
  final List<String> leftovers;

  /// The screens associated with the matched path segments
  final List<Screen> screens;

  /// Number of sections that were expected to match
  final int expectedSegmentCount;

  /// The original segments from the path, before any value parsing
  List<String> get rawSegments =>
      segments.map((segment) => segment.original).toList();

  /// Whether the path can be popped
  bool get canPop => screens.isNotEmpty;

  /// Constructs a Uri from the matched raw segments
  Uri get uri => Uri(pathSegments: rawSegments);

  /// Number of segments that matched
  int get count => segments.length;

  /// Percentage of segments that matched
  /// Note this can go over 1 (100%)
  double get rate =>
      expectedSegmentCount == 0 ? 0 : count / expectedSegmentCount;

  /// Creates a new [PathMatch] with the given [segments], [leftovers], and [screens].
  const PathMatch(
    this.screens,
    this.segments,
    this.leftovers,
    this.expectedSegmentCount,
  );

  /// Represents no match found
  static const noMatch = PathMatch([], [], [], 0);

  /// Removes the last [count] segments from the match
  PathMatch pop([int count = 1]) {
    if (count <= 0) {
      return this;
    }

    if (count >= screens.length) {
      return PathMatch.noMatch;
    }

    final screensToPop = screens.skip(screens.length - count);
    final segmentsToPop = screensToPop.map(
      (screen) => screen.metadata.path.base.length,
    );

    return PathMatch(
      screens.sublist(0, screens.length - count),
      segments.sublist(0, segments.length - count),
      [
        ...segments
            .skip(segmentsToPop.length - count)
            .map((segment) => segment.original),
        ...leftovers,
      ],
      0,
    );
  }
}
