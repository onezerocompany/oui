import 'package:flutter/material.dart';
import 'package:oui/oui.dart';

import 'screens/test_screen.dart';

void main() {
  // usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OuiApp(
      root: testScreen,
      config: Config(
        app: AppDetails(
          name: 'OUI Showcase',
          version: '1.0.0',
        ),
      ),
    );
  }
}
