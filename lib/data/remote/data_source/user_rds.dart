import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_list/common/exceptions.dart';

class UserRds {
  UserRds({
    required this.firebaseAuth,
  });

  final FirebaseAuth firebaseAuth;

  User get user => getUser();

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

  User getUser() {
    if (firebaseAuth.currentUser != null) {
      return firebaseAuth.currentUser!;
    }
    throw UnauthenticatedUserException();
  }

  Future<void> updateUserName(String name) async {
    user.updateDisplayName(name);
  }

  Future<void> updateUserEmail(String email) async {
    user.updateEmail(email);
  }

  Future<void> updateUserPassword(String newPassword) async {
    user.updatePassword(newPassword);
  }
}
