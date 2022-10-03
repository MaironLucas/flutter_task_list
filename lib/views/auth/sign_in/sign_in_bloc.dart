import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/dummy_state_handler.dart';
import 'package:flutter_task_list/data/model/user.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/auth/sign_in/sign_in_models.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc with SubscriptionHolder {
  SignInBloc({
    required this.userRepository,
    required this.dummyStateHandler,
  }) {
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

    Rx.combineLatest2(
      _onEmailInputStatusChangedSubject,
      _onPasswordInputStatusChangedSubject,
      (emailStatus, passwordStatus) {
        if (emailStatus == InputStatus.valid &&
            passwordStatus == InputStatus.valid) {
          return ButtonActive();
        }
        return ButtonInactive();
      },
    ).listen(_onButtonStatusChangedSubject.add).addTo(subscriptions);
  }

  final UserRepository userRepository;
  final DummyStateHandler dummyStateHandler;

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

  final _onSignInActionSubject = PublishSubject<SignInAction>();
  Stream<SignInAction> get onSignInAction => _onSignInActionSubject.stream;

  final _onSubmitStatusSubject = PublishSubject<SubmitStatus>();
  Stream<SubmitStatus> get onSubmitStatus => _onSubmitStatusSubject.stream;

  final _onButtonStatusChangedSubject = PublishSubject<ButtonState>();
  Stream<ButtonState> get onButtonStatusChanged =>
      _onButtonStatusChangedSubject.stream;

  Stream<InputStatus> _validateEmail(String? email) async* {
    yield userRepository.validateEmail(email);
  }

  Stream<InputStatus> _validatePassword(String? password) async* {
    yield userRepository.validatePassword(password);
  }

  Stream<SignInAction> _submitSignIn() async* {
    try {
      _onButtonStatusChangedSubject.add(ButtonLoading());
      userRepository.signInUser(_emailValue!, _passwordValue!);
      _onSubmitStatusSubject.add(SubmitStatus.valid);
      dummyStateHandler.logInUser(
        User(name: 'Teste', email: 'email.com'),
      );
      yield SignInSuccessAction();
    } catch (e) {
      _onButtonStatusChangedSubject.add(ButtonInactive());
      _onSubmitStatusSubject.add(SubmitStatus.wrongCredentials);
    }
  }

  void dispose() {
    _onEmailInputStatusChangedSubject.close();
    _onPasswordInputStatusChangedSubject.close();
    _onPasswordValueChangedSubject.close();
    _onEmailValueChangedSubject.close();
    _onSubmitButtonClickSubject.close();
  }
}
