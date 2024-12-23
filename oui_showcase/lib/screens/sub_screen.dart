import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';
import 'package:oui_showcase/screens/another_sub_screen.dart';

final subScreen = OuiScreen(
  id: "sub",
  metadata: OuiLocalized(
    OuiScreenMetadata(
      path: [OuiPathSegment.static('sub')],
      name: 'Sub Screen',
    ),
  ),
  size: OuiScreenSize(
    width: OuiScreenSizeDimension(
      weight: 1,
    ),
  ),
  content: Center(
    child: Text("Sub Screen"),
  ),
  children: [anotherSubScreen],
);
