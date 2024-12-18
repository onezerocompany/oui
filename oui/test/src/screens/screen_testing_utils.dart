import 'package:flutter/widgets.dart';
import 'package:oui/src/router/oui_path.dart';
import 'package:oui/src/screens/oui_screen.dart';
import 'package:oui/src/screens/oui_screen_metadata.dart';
import 'package:oui/src/utils/oui_localized.dart';

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
