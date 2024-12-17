import 'package:oui/oui.dart';
import 'package:oui_showcase/screens/sub_screen.dart';

final testScreen = OuiScreen(
  id: "test",
  metadata: OuiLocalized(
    OuiScreenMetadata(
      path: [OuiPathSegment.static('test')],
      name: 'Test Screen',
    ),
  ),
  children: [subScreen],
  builder: (context) {
    return const Center(
      child: Text('Test Screen'),
    );
  },
);
