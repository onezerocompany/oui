import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart' show FirebaseFunctions;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_storage/firebase_storage.dart';
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
    // TODO: Make the ports and host configurable
    FirebaseAuth.instance.useAuthEmulator("localhost", 8001);
    FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8002);
    FirebaseStorage.instance.useStorageEmulator("localhost", 8004);
    FirebaseFunctions.instance.useFunctionsEmulator("localhost", 9000);
  }

  runApp(FueApp(config: config));
}
