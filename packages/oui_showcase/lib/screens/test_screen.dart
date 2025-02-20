import 'package:oui/oui.dart';

import 'sub_screen.dart';

const hello = {
  Locale.en: "Hello",
  Locale.fr: "Bonjour",
};

final testScreen = Screen("test")
    .content(
      Box()
          .backgroundColor(
            Color.fromRGB(1, 0, 0),
            condition: (context) => context.width.isGreaterThan(ScreenSize.md),
          )
          .allCorners(12)
          .content(
            Label.localized(hello).size(30).weight(TextWeight.light),
          )
          .inset(Insets.all(20))
          .fixedSize(width: 300, height: 600)
          .state(State.errored),
    )
    .child(subScreen)
    .backgroundColor(Color.fromRGB(100, 100, 100))
    .allCorners(18);
