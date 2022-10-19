import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/login_state_handler.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/auth/sign_in/sign_in_models.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc with SubscriptionHolder {
  SignInBloc({
    required this.userRepository,
    required this.dummyStateHandler,
  }) {
    _onEmailValueChangedSubject.flatMap(_validateEmail).listen((emailStatus) {
      final lastPasswordStatus = _onEmailInputStatusChangedSubject.valueOrNull;
      if (lastPasswordStatus == InputStatus.error) {
        _onPasswordInputStatusChangedSubject.add(InputStatus.valid);
      }
      _onEmailInputStatusChangedSubject.add(emailStatus);
    }).addTo(subscriptions);

    _onPasswordValueChangedSubject
        .flatMap(_validatePassword)
        .listen((passwordStatus) {
      final lastEmailStatus = _onPasswordInputStatusChangedSubject.valueOrNull;
      if (lastEmailStatus == InputStatus.error) {
        _onEmailInputStatusChangedSubject.add(InputStatus.valid);
      }
      _onPasswordInputStatusChangedSubject.add(passwordStatus);
    }).addTo(subscriptions);

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
  final LoginStateHandler dummyStateHandler;

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
    _onSubmitStatusSubject.add(SubmitStatus.valid);
    yield userRepository.validateEmail(email);
  }

  Stream<InputStatus> _validatePassword(String? password) async* {
    _onSubmitStatusSubject.add(SubmitStatus.valid);
    yield userRepository.validatePassword(password);
  }

  Stream<SignInAction> _submitSignIn() async* {
    try {
      _onButtonStatusChangedSubject.add(ButtonLoading());
      await userRepository.signInUser(_emailValue!, _passwordValue!);
      _onSubmitStatusSubject.add(SubmitStatus.valid);
      yield SignInSuccessAction();
    } catch (error) {
      _onButtonStatusChangedSubject.add(ButtonInactive());
      _onEmailInputStatusChangedSubject.add(InputStatus.error);
      _onPasswordInputStatusChangedSubject.add(InputStatus.error);
      if (error is WrongCredentialsException) {
        _onSubmitStatusSubject.add(SubmitStatus.wrongCredentials);
      } else {
        _onSubmitStatusSubject.add(SubmitStatus.invalid);
      }
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
