import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState { initial, guest, authenticated }

class MockUser {
  final String uid;
  final String displayName;
  final String email;
  
  MockUser({required this.uid, required this.displayName, required this.email});
}

class AuthNotifier extends Notifier<AuthState> {
  MockUser? _mockUser;
  
  @override
  AuthState build() {
    return AuthState.initial;
  }

  void loginAsGuest() {
    state = AuthState.guest;
  }

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    if (email == 'demo' && password == 'demo') {
      _mockUser = MockUser(uid: '123', displayName: 'Ahmet Yılmaz', email: 'ahmet@demo.com');
      state = AuthState.authenticated;
    } else if (email.isNotEmpty && password.isNotEmpty) {
      _mockUser = MockUser(uid: '456', displayName: 'Test Kullanıcı', email: email);
      state = AuthState.authenticated;
    } else {
      throw Exception('E-posta ve şifre boş olamaz');
    }
  }

  Future<void> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockUser = MockUser(uid: '789', displayName: name, email: email);
    state = AuthState.authenticated;
  }

  Future<void> logout() async {
    _mockUser = null;
    state = AuthState.guest;
  }
  
  MockUser? get currentUser => _mockUser;
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

final mockUserProvider = Provider<MockUser?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState == AuthState.authenticated) {
    return ref.read(authProvider.notifier).currentUser;
  }
  return null;
});
