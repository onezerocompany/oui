enum AuthState {
  unauthenticated,
  authenticated,
}

abstract class AuthProvider {
  AuthState get state;
}
