import 'package:oui/src/core/localization.dart';
import 'package:oui/src/core/routing.dart';
import 'package:oui/src/core/screen.dart';

Screen testScreen(
  String id, {
  List<PathSegment> segments = const [],
  List<Screen> children = const [],
}) {
  return Screen(
    id: id,
    metadata: ScreenMetadata(
      path: Localized.always(
        segments.isEmpty ? [PathSegment.static(id)] : segments,
      ),
      name: Localized.always(id),
    ),
    children: children,
  );
}
