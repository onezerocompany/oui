import 'package:flutter/material.dart';
import 'package:oui/oui.dart';
import 'package:oui_showcase/screens/test_screen.dart';

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
      appDetailProvider: OuiMetadata(
        icon: Icons.ac_unit,
        name: 'OUI Showcase',
      ),
    );
  }
}
