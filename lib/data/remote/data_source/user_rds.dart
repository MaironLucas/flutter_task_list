import 'package:flutter_task_list/common/exceptions.dart';

class UserRds{
  void loginUser(String email, String password){
    if (!(email == 'teste@email.com' && password == 'senha12')){
      throw WrongCredentialsException;
    }
  }
}