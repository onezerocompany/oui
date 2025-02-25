import 'package:oui/oui.dart';

import 'sub_screen.dart';

const hello = {
  Locale.en: "Hello",
  Locale.fr: "Bonjour",
};

final testScreen = Screen("test")
    .content(
      Box()
          .backgroundColor(Color.fromRGB(0, 1, 0))
          .backgroundColor(
            Color.fromRGB(1, 0, 0),
            condition: (context) => context.width.isGreaterThan(ScreenSize.md),
          )
          .content(
            Box()
                .content(
                  Label.localized(hello)
                      .typography(TypographyGroup.body, SizeLevel.medium),
                )
                .backgroundColor(Color.fromRGB(0, 0, 1)),
          )
          .allCorners(12)
          .fixedSize(
            width: 300,
            height: 600,
            condition: (context) => context.width.isGreaterThan(ScreenSize.md),
          ),
    )
    .child(subScreen)
    .backgroundColor(Color.fromRGB(100, 100, 100))
    .inset(Insets.all(20))
    .allCorners(18);
