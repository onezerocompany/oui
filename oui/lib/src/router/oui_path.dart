import 'package:oui/oui.dart';

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

  List<OuiPathMatchSegment> matches(List<String> path) {
    final List<OuiPathMatchSegment> matches = [];
    for (var i = 0; i < segments.length; i++) {
      final pathSegment = path.elementAtOrNull(i);
      if (pathSegment == null) {
        break;
      }

      if (segments[i].isDynamic) {
        if (segments[i].pattern != null) {
          final match = segments[i].pattern?.firstMatch(pathSegment);
          if (match != null) {
            final value =
                match.groupCount > 0 ? match.group(1) : match.group(0);
            matches.add(
              OuiPathMatchSegment(
                segment: segments[i],
                original: pathSegment,
                value: value,
              ),
            );
          } else {
            break;
          }
        } else {
          matches.add(
            OuiPathMatchSegment(
              segment: segments[i],
              original: pathSegment,
              value: pathSegment,
            ),
          );
        }
      } else {
        if (segments[i].id == pathSegment.toLowerCase()) {
          matches.add(
            OuiPathMatchSegment(
              segment: segments[i],
              original: pathSegment,
            ),
          );
        } else {
          break;
        }
      }
    }
    return matches;
  }

  /// Adds new segments to the end of the path.
  OuiPath push(List<OuiPathSegment> newSegments) {
    return OuiPath([...segments, ...newSegments]);
  }

  /// Removes the last [count] segments from the path.
  OuiPath pop([int count = 1]) {
    if (segments.isEmpty || count >= segments.length) {
      return OuiPath.empty;
    }
    return OuiPath(segments.sublist(0, segments.length - count));
  }
}
