import 'package:flutter/widgets.dart' show ChangeNotifier;

import 'screen.dart' show Screen;

abstract class AuthProvider with ChangeNotifier {
  final Screen? unauthenticatedScreen;

  AuthProvider({
    this.unauthenticatedScreen,
  });

  String? get userId;
  bool get authenticated;
}

typedef AuthProviderBuilder = AuthProvider Function();
