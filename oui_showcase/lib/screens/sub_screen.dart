import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';

import 'another_sub_screen.dart';

final subScreen = Screen(
  id: "sub",
  metadata: Localized(
    ScreenMetadata(
      path: [PathSegment.static('sub')],
      name: LocalizedString.always("Sub Screen"),
    ),
  ),
  content: Center(
    child: Text("Sub Screen"),
  ),
  children: [anotherSubScreen],
).backgroundColor(Color.black).allCorners(40, smoothing: 0);
