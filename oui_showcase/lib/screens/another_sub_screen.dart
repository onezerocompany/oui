import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';

final anotherSubScreen = OuiScreen(
  id: "anotherSub",
  metadata: OuiLocalized(
    OuiScreenMetadata(
      path: [OuiPathSegment.static('another')],
      name: 'Another Sub Screen',
    ),
  ),
  content: Center(
    child: Text("Another Sub Screen"),
  ),
);
