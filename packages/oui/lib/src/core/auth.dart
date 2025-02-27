import 'package:contour/contour.dart' show Listenable;

import 'screen.dart' show Screen;

abstract class AuthProvider extends Listenable {
  final Screen? unauthenticatedScreen;

  const AuthProvider({
    this.unauthenticatedScreen,
  });

  String? get userId;
  bool get authenticated;
}
