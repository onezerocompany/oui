import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart'
    show BuildContext, StatelessWidget, Widget, WidgetsFlutterBinding, runApp;
import 'package:fue/src/config.dart';
import 'package:oui/oui.dart';

class FueApp extends StatelessWidget {
  final FueConfig config;

  const FueApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return OuiApp(config: config);
  }
}

Future<void> runFueApp(FueConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: config.firebase.options);

  if (kDebugMode) {
    // Connect to the Firebase emulators
  }

  runApp(FueApp(config: config));
}
