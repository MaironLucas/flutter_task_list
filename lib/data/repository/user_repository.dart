import 'package:flutter_task_list/data/remote/data_source/user_rds.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';

class UserRepository{

  final userRds = UserRds();

  static const regexEmail =
      r'^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$';

  InputStatus validateEmail(String? email){
    if (email == null){
      return InputStatus.empty;
    }
    else if (!RegExp(regexEmail, caseSensitive: false).hasMatch(email)){
      return InputStatus.invalid;
    }
    return InputStatus.valid;
  }

  InputStatus validatePassword(String? password){
    if (password == null){
      return InputStatus.empty;
    }
    else if (password.length < 3){
      return InputStatus.invalid;
    }
    return InputStatus.valid;
  }

  void loginUser(String email, String password){
    userRds.loginUser(email, password);
  }
}