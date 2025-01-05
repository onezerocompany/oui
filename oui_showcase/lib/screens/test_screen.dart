import 'package:flutter/widgets.dart' show Center, Text;
import 'package:oui/oui.dart';

import 'sub_screen.dart';

final testScreen = Screen(
  id: "test",
  metadata: Localized(
    ScreenMetadata(
      path: [PathSegment.static('test')],
      name: LocalizedString.always("Test Screen"),
    ),
  ),
  content: Center(
    child: Text("Test Screen"),
  ),
  children: [
    subScreen,
  ],
).fixedSize(width: 500).backgroundColor(Color.black).allCorners(18);
