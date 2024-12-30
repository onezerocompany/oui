import 'package:flutter/widgets.dart';
import 'package:oui/src/components/screen/screen.dart';
import 'package:oui/src/core/localization/localized.dart';
import 'package:oui/src/core/metadata/screen_metadata.dart';
import 'package:oui/src/core/router/path.dart';

Screen testScreen(
  String id, {
  List<PathSegment> segments = const [],
  List<Screen> children = const [],
}) {
  return Screen(
    id: id,
    metadata: Localized(
      ScreenMetadata(
        path: segments.isEmpty ? [PathSegment.static(id)] : segments,
        name: id,
      ),
    ),
    content: const SizedBox.shrink(),
    children: children,
  );
}
