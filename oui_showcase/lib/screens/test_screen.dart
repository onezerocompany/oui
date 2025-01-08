import 'package:flutter/widgets.dart' show Center, Text;
import 'package:oui/oui.dart';

import 'sub_screen.dart';

final testScreen = Screen(
  id: "test",
  metadata: ScreenMetadata.always(
    path: [PathSegment.static('test')],
    name: "Test Screen",
  ),
  content: Center(
    child: Box(
      content: Text("Test Screen"),
    )
        .background()
        .inset(Insets.all(18))
        .allCorners(12)
        .fixedSize(width: 300, height: 300)
        .alignment(Alignment.center)
        .border(thickness: 2)
        .shadow(),
  ),
  children: [
    subScreen,
  ],
).dynamicSize(maxWidth: 800).background().allCorners(18);
