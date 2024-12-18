import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';

final subScreen = OuiScreen(
  id: "sub",
  metadata: OuiLocalized(
    OuiScreenMetadata(
      path: [OuiPathSegment.static('sub')],
      name: 'Sub Screen',
    ),
  ),
  builder: (context) {
    return const Center(
      child: Text('Sub Screen'),
    );
  },
);
