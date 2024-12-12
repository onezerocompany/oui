import 'package:flutter/material.dart';
import 'package:oui/oui.dart';

import 'test_screen.dart';

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
      root: const TestScreen(),
      appDetailProvider: OuiMetadataProvider(
        icon: (_) {
          return const Icon(Icons.ac_unit);
        },
        name: (_) {
          return 'OUI Showcase';
        },
      ),
    );
  }
}
