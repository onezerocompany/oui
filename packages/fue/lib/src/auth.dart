import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:oui/oui.dart' show AuthProvider;

class FirebaseAuthProvider extends AuthProvider {
  FirebaseAuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? _user;

  @override
  bool get authenticated {
    return _user != null;
  }

  bool get isAnonymous {
    return _user?.isAnonymous ?? false;
  }

  @override
  String? get userId {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
