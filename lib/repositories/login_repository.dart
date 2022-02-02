import 'package:firebase_auth/firebase_auth.dart';

class LoginRepository {
  final FirebaseAuth _firebaseAuth;

  LoginRepository() : _firebaseAuth = FirebaseAuth.instance;

  Future<AuthResult> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<void> forgotPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
