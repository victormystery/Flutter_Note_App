
import 'package:firebase_auth/firebase_auth.dart';

import '../helperfunction.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Signup Function
  Future registerUserWithEmailAndPassword(
      String email, String username, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      await DatabaseService(uid: user.uid).saveUserData(email, username);

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  // Login Function

  Future loginUserWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Signout Function
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSf("");
      await HelperFunctions.saveUserNameSf("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
