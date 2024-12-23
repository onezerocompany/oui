import 'package:flutter/widgets.dart';
import 'package:oui/src/core/router/oui_path.dart';
import 'package:oui/src/components/screen/oui_screen.dart';
import 'package:oui/src/components/screen/oui_screen_metadata.dart';
import 'package:oui/src/core/localization/oui_localized.dart';

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
    content: const SizedBox.shrink(),
    children: children,
  );
}
