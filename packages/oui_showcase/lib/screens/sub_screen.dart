import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';
import 'package:oui_showcase/screens/another_sub_screen.dart';

final subScreen = Screen(
  "sub",
)
    .content(
      Center(
        child: Text("Sub Screen"),
      ),
    )
    .child(anotherSubScreen)
    .allCorners(40, smoothing: 0);
