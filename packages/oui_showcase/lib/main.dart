import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';

import 'screens/test_screen.dart';

void main() {
  // usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OuiApp(
      root: testScreen,
      config: Config(
        details: AppDetails(
          name: LocalizedString.always("Oui Showcase"),
          version: Version(0, 0, 0),
        ),
        colors: ColorConfig(
          seed: Color.fromHSL(
            HslColor.fromHSL(0.0, 0.2, 0.95),
          ),
        ),
      ),
    );
  }
}
