import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_task_list/data/model/user.dart' as user_model;
import 'package:flutter_task_list/data/model/user_log_in_data.dart';

class LoginStateHandler with ChangeNotifier {
  LoginStateHandler() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
}

extension LoginToUser on UserLoginData {
  user_model.User toUser() => user_model.User(
        email: email,
        name: name,
      );
}
