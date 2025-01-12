import 'package:oui/oui.dart';

import 'sub_screen.dart';

final testScreen = Screen("test")
    .path("testing")
    .child(subScreen)
    .content(
      Box()
          .backgrounded
          .bordered
          .centered
          .shadow(spread: -5, blur: 15)
          .allCorners(12)
          .content(Label("Testing"))
          .inset(Insets.all(18))
          .fixedSize(width: 300, height: 600),
    )
    .shadow(blur: 10)
    .dynamicSize(maxWidth: 800)
    .allCorners(18);
