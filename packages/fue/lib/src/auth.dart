import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:oui/oui.dart' show AuthProvider;

class FirebaseAuthProvider extends AuthProvider {
  const FirebaseAuthProvider();

  @override
  bool get authenticated {
    return false;
  }

  @override
  String? get userId {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> anonymousSignIn() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
