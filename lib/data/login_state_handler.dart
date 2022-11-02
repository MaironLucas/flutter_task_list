import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
