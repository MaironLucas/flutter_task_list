import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_list/common/exceptions.dart';

class UserRds {
  UserRds();

  Future<void> signInUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'wrong-password' || error.code == 'user-not-found') {
          throw WrongCredentialsException();
        }
      }
      throw InternalException();
    }
  }

  Future<void> signUpUser(String name, String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (userCredential) {
          final user = userCredential.user;
          if (user != null) {
            user.updateDisplayName(name);
          }
        },
      );
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'email-already-in-use') {
          throw EmailAlreadyUsedException();
        } else if (error.code == 'weak-password') {
          throw WeakPasswordException();
        }
      }
      throw InternalException();
    }
  }
}
