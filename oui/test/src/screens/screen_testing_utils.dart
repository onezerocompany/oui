import 'package:oui/oui.dart';

OuiScreen testScreen(
  String id, {
  List<OuiPathSegment> segments = const [],
  List<OuiScreen> children = const [],
}) {
  return OuiScreen(
    id: id,
    metadata: OuiLocalized(
      OuiScreenMetadata(
        path: segments.isEmpty ? [OuiPathSegment.static(id)] : segments,
        name: id,
      ),
    ),
    children: children,
    builder: (BuildContext context) {
      return Container();
    },
  );
}
