import 'package:oui/oui.dart';

import 'sub_screen.dart';

final testScreen = Screen("test")
    .path("testing")
    .child(subScreen)
    .content(
      Box()
          .background()
          .border()
          .alignment(Alignment.center)
          .shadow(blur: 5)
          .allCorners(12)
          .content(Label("Testing").size(30).weight(TextWeight.semiBold))
          .inset(Insets.all(18))
          .fixedSize(width: 300, height: 600)
          .state(State.errored),
    )
    .shadow(blur: 10)
    .allCorners(18);
