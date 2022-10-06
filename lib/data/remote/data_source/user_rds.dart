import 'package:flutter_task_list/data/dummy_state_handler.dart';

class UserRds {
  UserRds({required this.dummyStateHandler});

  final DummyStateHandler dummyStateHandler;

  void loginUser(String email, String password) =>
      dummyStateHandler.logInUser(email, password);

  void signUpUser(String name, String email, String password) =>
      dummyStateHandler.signUpUser(email, password, name);
}
