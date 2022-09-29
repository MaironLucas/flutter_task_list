import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/sign_in/sign_in_models.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc with SubscriptionHolder {
  SignInBloc() {
    _onEmailValueChangedSubject
        .flatMap(_validateEmail)
        .listen(_onEmailInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onPasswordValueChangedSubject
        .flatMap(_validatePassword)
        .listen(_onPasswordInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onSubmitButtonClickSubject
        .flatMap((_) => _submitSignIn())
        .listen(_onSignInActionSubject.add)
        .addTo(subscriptions);
  }

  final _userRepository = UserRepository();

  final _onEmailValueChangedSubject = BehaviorSubject<String>();
  Sink<String?> get onEmailValueChanged => _onEmailValueChangedSubject.sink;
  String? get _emailValue => _onEmailValueChangedSubject.valueOrNull;

  final _onEmailInputStatusChangedSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get onEmailInputStatusChangedStream =>
      _onEmailInputStatusChangedSubject.stream;

  final _onPasswordValueChangedSubject = BehaviorSubject<String>();
  Sink<String?> get onPasswordValueChanged =>
      _onPasswordValueChangedSubject.sink;
  String? get _passwordValue => _onPasswordValueChangedSubject.valueOrNull;

  final _onPasswordInputStatusChangedSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get onPasswordInputStatusChanged =>
      _onPasswordInputStatusChangedSubject.stream;

  final _onSubmitButtonClickSubject = BehaviorSubject<void>();
  Sink<void> get onSubmitButtonClick => _onSubmitButtonClickSubject.sink;

  final _onEmailFocusLostSubject = BehaviorSubject<void>();
  Sink<void> get onEmailFocusLost => _onEmailFocusLostSubject.sink;

  final _onPasswordFocusLostSubject = BehaviorSubject<void>();
  Sink<void> get onPasswordFocusLost => _onPasswordFocusLostSubject.sink;

  final _onSignInActionSubject = PublishSubject<SignInAction>();
  Stream<SignInAction> get onSignInAction => _onSignInActionSubject.stream;

  Stream<InputStatus> _validateEmail(String? email) async* {
    yield _userRepository.validateEmail(email);
  }

  Stream<InputStatus> _validatePassword(String? password) async* {
    yield _userRepository.validatePassword(password);
  }

  Stream<SignInAction> _submitSignIn() async* {
    try {
      _userRepository.signInUser(_emailValue!, _passwordValue!);
      yield SignInSuccessAction();
    } catch (e) {
      yield SignInErrorAction();
    }
  }

  void dispose() {
    _onEmailInputStatusChangedSubject.close();
    _onPasswordInputStatusChangedSubject.close();
    _onPasswordValueChangedSubject.close();
    _onEmailValueChangedSubject.close();
    _onSubmitButtonClickSubject.close();
    _onEmailFocusLostSubject.close();
    _onPasswordFocusLostSubject.close();
  }
}
