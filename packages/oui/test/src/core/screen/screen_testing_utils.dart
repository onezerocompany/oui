import 'package:oui/src/components/screen.dart';
import 'package:oui/src/core/locales.dart' show Locale;
import 'package:oui/src/core/routing.dart';

Screen testScreen(
  String id, {
  List<PathSegment> segments = const [],
  List<Screen> children = const [],
}) {
  return Screen(id).pathSegments({
    Locale.any: segments.isEmpty ? [PathSegment.static(id)] : segments,
  }).children(children);
}
