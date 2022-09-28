import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/login/login_models.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with SubscriptionHolder{
  LoginBloc(){
    _onEmailValueChangedSubject
      .flatMap(_validateEmail)
      .listen(_onEmailInputStatusChangedSubject.add)
      .addTo(subscriptions);

    _onPasswordValueChangedSubject
      .flatMap(_validatePassword)
      .listen(_onPasswordInputStatusChangedSubject.add)
      .addTo(subscriptions);

    _onSubmitButtonClickSubject
    .flatMap((_) =>_submitLogin())
      .listen(_onLoginActionSubject.add)
      .addTo(subscriptions);
  }

  final _userRepository = UserRepository();

  final _onEmailValueChangedSubject = BehaviorSubject<String>();
  Sink<String?> get onEmailValueChanged => _onEmailValueChangedSubject.sink;
  String? get _emailValue => _onEmailValueChangedSubject.valueOrNull;
  
  final _onEmailInputStatusChangedSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get onEmailInputStatusChangedStream => _onEmailInputStatusChangedSubject.stream;

  final _onPasswordValueChangedSubject = BehaviorSubject<String>();
  Sink<String?> get onPasswordValueChanged => _onPasswordValueChangedSubject.sink;
  String? get _passwordValue => _onPasswordValueChangedSubject.valueOrNull;

  final _onPasswordInputStatusChangedSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get onPasswordInputStatusChanged => _onPasswordInputStatusChangedSubject.stream;

  final _onSubmitButtonClickSubject = BehaviorSubject<void>();
  Sink<void> get onSubmitButtonClick => _onSubmitButtonClickSubject.sink;

  final _onEmailFocusLostSubject = BehaviorSubject<void>();
  Sink<void> get onEmailFocusLost => _onEmailFocusLostSubject.sink;

  final _onPasswordFocusLostSubject = BehaviorSubject<void>();
  Sink<void> get onPasswordFocusLost => _onPasswordFocusLostSubject.sink;

  final _onLoginActionSubject = PublishSubject<LoginAction>();
  Stream<LoginAction> get onLoginAction => _onLoginActionSubject.stream;

  Stream<InputStatus> _validateEmail(String? email) async*{
    yield InputStatus.valid;
  }

  Stream<InputStatus> _validatePassword(String? password) async*{
    yield InputStatus.valid;
  }

  Stream<LoginAction> _submitLogin() async*{
    try{
      _userRepository.loginUser(_emailValue!, _passwordValue!);
      yield LoginSuccessAction();
    } catch (e){
      yield LoginErrorAction();
    }
  }

  void dispose(){
    _onEmailInputStatusChangedSubject.close();
    _onPasswordInputStatusChangedSubject.close();
    _onPasswordValueChangedSubject.close();
    _onEmailValueChangedSubject.close();
    _onSubmitButtonClickSubject.close();
    _onEmailFocusLostSubject.close();
    _onPasswordFocusLostSubject.close();
  }
}