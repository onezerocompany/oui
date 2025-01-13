import 'package:oui/src/core/routing.dart';
import 'package:oui/src/core/screen.dart';

Screen testScreen(
  String id, {
  List<PathSegment> segments = const [],
  List<Screen> children = const [],
}) {
  return Screen(id)
      .pathSegments(segments.isEmpty ? [PathSegment.static(id)] : segments)
      .children(children);
}
