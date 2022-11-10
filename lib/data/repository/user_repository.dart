import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_list/data/remote/data_source/user_rds.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';

class UserRepository {
  UserRepository({required this.userRds});

  final UserRds userRds;

  static const regexEmail =
      r'^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$';

  InputStatus validateEmail(String? email) {
    if (email == null) {
      return InputStatus.empty;
    } else if (!RegExp(regexEmail, caseSensitive: false).hasMatch(email)) {
      return InputStatus.invalid;
    }
    return InputStatus.valid;
  }

  InputStatus validatePassword(String? password) {
    if (password == null) {
      return InputStatus.empty;
    } else if (password.length < 3) {
      return InputStatus.invalid;
    }
    return InputStatus.valid;
  }

  InputStatus validateName(String? name) {
    if (name == null) {
      return InputStatus.empty;
    }
    return InputStatus.valid;
  }

  Future<void> signInUser(String email, String password) =>
      userRds.signInUser(email, password);

  Future<void> signUpUser(String name, String email, String password) =>
      userRds.signUpUser(name, email, password);

  Future<void> changeUserInfo(
    String? name,
    String? email,
    String? password,
  ) async {
    if (name != null) {
      userRds.updateUserName(name);
    }
    if (email != null) {
      userRds.updateUserEmail(email);
    }
    if (password != null) {
      userRds.updateUserPassword(password);
    }
  }

  User getUser() => userRds.getUser();
}
