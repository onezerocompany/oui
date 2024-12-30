import 'package:flutter/widgets.dart' show Center, Text;
import 'package:oui/oui.dart';

import 'sub_screen.dart';

final testScreen = Screen(
  id: "test",
  metadata: Localized(
    ScreenMetadata(
      path: [PathSegment.static('test')],
      name: 'Test Screen',
    ),
  ),
  content: Center(
    child: Text("Test Screen"),
  ),
  children: [
    subScreen,
  ],
).background(
  Background.gradient(
    Gradient.linear(
      stops: [
        GradientStop(0, Color.fromRGB(1, 0, 0)),
        GradientStop(1, Color.fromRGB(0, 0, 1)),
      ],
    ),
  ),
);
