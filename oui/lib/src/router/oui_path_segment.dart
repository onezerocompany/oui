/// Represents a segment of a path, which can be either static, an argument, or a wildcard.
class OuiPathSegment {
  /// The identifier of the path segment.
  final String id;

  /// The pattern to match the path segment, if it is an argument.
  final RegExp? pattern;

  /// Indicates if the path segment is an argument.
  final bool isDynamic;

  const OuiPathSegment._({
    required this.id,
    required this.isDynamic,
    this.pattern,
  });

  /// Creates a static path segment with a given value.
  factory OuiPathSegment.static(String value) {
    return OuiPathSegment._(
      id: value,
      pattern: RegExp('^${RegExp.escape(value)}\$'),
      isDynamic: false,
    );
  }

  /// Creates an argument path segment with a given id and optional pattern.
  factory OuiPathSegment.argument(String id, {RegExp? pattern}) {
    return OuiPathSegment._(
      id: id,
      pattern: pattern,
      isDynamic: true,
    );
  }

  /// Creates a wildcard path segment.
  factory OuiPathSegment.wildcard(String id) {
    return OuiPathSegment._(
      id: id,
      isDynamic: true,
      pattern: RegExp('.*'),
    );
  }
}
