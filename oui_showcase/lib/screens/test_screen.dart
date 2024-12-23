import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';

import 'sub_screen.dart';

final testScreen = OuiScreen(
  id: "test",
  metadata: OuiLocalized(
    OuiScreenMetadata(
      path: [OuiPathSegment.static('test')],
      name: 'Test Screen',
    ),
  ),
  background: OuiBackground.gradient(OuiGradient.linear(stops: [
    OuiGradientStop(0, OuiColor.fromRGB(1, 0, 0)),
    OuiGradientStop(1, OuiColor.fromRGB(0, 1, 0)),
  ])),
  content: Center(
    child: Text("Test Screen"),
  ),
  children: [
    subScreen,
  ],
);
