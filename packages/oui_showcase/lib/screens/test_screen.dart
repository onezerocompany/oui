import 'package:oui/oui.dart';

import 'sub_screen.dart';

const hello = {
  Locale.en: "Hello",
  Locale.fr: "Bonjour",
};

final testScreen = Screen("test")
    .child(subScreen)
    .content(
      Box()
          .border()
          .alignment(Alignment.center)
          .allCorners(12)
          .content(
            Label.localized(hello).size(30).weight(TextWeight.light),
          )
          .inset(Insets.all(20))
          .fixedSize(width: 300, height: 600)
          .state(State.errored),
    )
    .backgroundColor(Color.white)
    .allCorners(18);
