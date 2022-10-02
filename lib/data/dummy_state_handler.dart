import 'package:flutter/cupertino.dart';
import 'package:flutter_task_list/data/model/user.dart';

class DummyStateHandler with ChangeNotifier {
  User? _loggedUser;
  final List<User> _users = [];

  void signUpUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void logInUser(User user) {
    _loggedUser = user;
    notifyListeners();
  }

  bool get isLoggedIn => _loggedUser != null;
}
