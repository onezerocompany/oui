import 'package:flutter/material.dart';
import 'package:oui/oui.dart';

import 'screens/test_screen.dart';

void main() {
  // usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return OuiApp(
      root: testScreen,
      config: Config(
        details: AppDetails(
          name: LocalizedString.always("Oui Showcase"),
          version: Version(0, 0, 0),
        ),
      ),
    );
  }
}
