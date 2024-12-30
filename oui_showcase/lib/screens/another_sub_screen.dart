import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';

final anotherSubScreen = Screen(
  id: "anotherSub",
  metadata: Localized(
    ScreenMetadata(
      path: [PathSegment.static('another')],
      name: 'Another Sub Screen',
    ),
  ),
  content: Center(
    child: Text("Another Sub Screen"),
  ),
);
