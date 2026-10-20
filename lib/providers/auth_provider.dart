import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  AuthProvider() {
    // Escuchar cambios de sesión en tiempo real[cite: 5]
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Login con email y contraseña[cite: 4]
  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Registro con email y contraseña
  Future<void> signUp(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}