import 'package:flutter/cupertino.dart';
import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/data/model/user.dart';
import 'package:flutter_task_list/data/model/user_log_in_data.dart';

class DummyStateHandler with ChangeNotifier {
  User? _loggedUser;
  final List<UserLoginData> _users = [
    UserLoginData(
      password: 'senha12',
      name: 'Teste',
      email: 'teste@email.com',
    ),
  ];

  void signUpUser(String email, String password, String name) {
    for (var user in _users) {
      if (user.email == email) {
        throw EmailAlreadyUsedException();
      }
    }
    _users.add(
      UserLoginData(
        password: password,
        name: name,
        email: email,
      ),
    );
  }

  void logInUser(String email, String password) {
    User? listUser;
    for (var userData in _users) {
      if (userData.email == email && userData.password == password) {
        listUser = userData.toUser();
      }
    }
    if (listUser == null) {
      throw WrongCredentialsException();
    }
    _loggedUser = listUser;
  }

  void signOut() => _loggedUser = null;

  bool get isLoggedIn => _loggedUser != null;
}

extension LoginToUser on UserLoginData {
  User toUser() => User(
        email: email,
        name: name,
      );
}
