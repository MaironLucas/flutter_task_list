import 'package:flutter/cupertino.dart';
import 'package:flutter_task_list/data/model/user.dart';

class DummyStateHandler with ChangeNotifier {
  User? _loggedUser;
  List<User> users = [];
}
