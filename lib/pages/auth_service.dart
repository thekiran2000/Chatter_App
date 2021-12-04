import 'package:firebase_auth/firebase_auth.dart';

class Auth_serve{
  final FirebaseAuth _firebaseAuth;

  Auth_serve(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

}