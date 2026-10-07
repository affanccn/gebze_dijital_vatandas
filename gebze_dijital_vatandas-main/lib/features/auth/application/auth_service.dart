import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState { initial, guest, authenticated }

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState.authenticated;

  void loginAsGuest() {
    state = AuthState.guest;
  }

  void login(String email, String password) {
    state = AuthState.authenticated;
  }

  void logout() {
    state = AuthState.guest;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
