import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/auth/sign_up/sign_up_models.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc with SubscriptionHolder {
  SignUpBloc({required this.userRepository}) {
    _onNameValueChangedSubject
        .flatMap((name) {
          _putValidOnStreams();
          return _validateName(name);
        })
        .listen(_onNameInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onEmailValueChangedSubject
        .flatMap((email) {
          _putValidOnStreams();
          return _validateEmail(email);
        })
        .listen(_onEmailInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onPasswordValueChangedSubject
        .flatMap((password) {
          _putValidOnStreams();
          return _validatePassword(password);
        })
        .listen(_onPasswordInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onPasswordConfirmationValueChangedSubject
        .flatMap((passwordConfirmation) {
          _putValidOnStreams();
          return _validateConfirmationPassword(passwordConfirmation);
        })
        .listen(_onPasswordConfirmationInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onSubmitButtonClickSubject
        .flatMap((_) => _submitSignUp())
        .listen(_onSignInActionSubject.add)
        .addTo(subscriptions);

    Rx.combineLatest4(
      _onNameInputStatusChangedSubject,
      _onEmailInputStatusChangedSubject,
      _onPasswordInputStatusChangedSubject,
      _onPasswordConfirmationInputStatusChangedSubject,
      (nameStatus, emailStatus, passwordStatus, passwordConfirmationStatus) {
        if (nameStatus == InputStatus.valid &&
            emailStatus == InputStatus.valid &&
            passwordStatus == InputStatus.valid &&
            passwordConfirmationStatus == InputStatus.valid) {
          return ButtonActive();
        }
        return ButtonInactive();
      },
    ).listen(_onButtonStatusChangedSubject.add).addTo(subscriptions);
  }

  final UserRepository userRepository;

  final _onEmailValueChangedSubject = BehaviorSubject<String>();
  Sink<String?> get onEmailValueChanged => _onEmailValueChangedSubject.sink;
  String? get _emailValue => _onEmailValueChangedSubject.valueOrNull;

  final _onEmailInputStatusChangedSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get onEmailInputStatusChangedStream =>
      _onEmailInputStatusChangedSubject.stream;

  final _onNameValueChangedSubject = BehaviorSubject<String>();
  Sink<String?> get onNameValueChanged => _onNameValueChangedSubject.sink;
  String? get _nameValue => _onNameValueChangedSubject.valueOrNull;

  final _onNameInputStatusChangedSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get onNameInputStatusChangedStream =>
      _onNameInputStatusChangedSubject.stream;

  final _onPasswordValueChangedSubject = BehaviorSubject<String>();
  Sink<String?> get onPasswordValueChanged =>
      _onPasswordValueChangedSubject.sink;
  String? get _passwordValue => _onPasswordValueChangedSubject.valueOrNull;

  final _onPasswordInputStatusChangedSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get onPasswordInputStatusChanged =>
      _onPasswordInputStatusChangedSubject.stream;

  final _onPasswordConfirmationValueChangedSubject = BehaviorSubject<String>();
  Sink<String?> get onPasswordConfirmationValueChanged =>
      _onPasswordConfirmationValueChangedSubject.sink;

  final _onPasswordConfirmationInputStatusChangedSubject =
      BehaviorSubject<InputStatus>();
  Stream<InputStatus> get onPasswordConfirmationInputStatusChanged =>
      _onPasswordConfirmationInputStatusChangedSubject.stream;

  final _onSubmitButtonClickSubject = BehaviorSubject<void>();
  Sink<void> get onSubmitButtonClick => _onSubmitButtonClickSubject.sink;

  final _onSignInActionSubject = PublishSubject<SignUpAction>();
  Stream<SignUpAction> get onSignUpAction => _onSignInActionSubject.stream;

  final _onSubmitStatusSubject = BehaviorSubject<SubmitStatus>();
  Stream<SubmitStatus> get onSubmitStatus => _onSubmitStatusSubject.stream;

  final _onButtonStatusChangedSubject = PublishSubject<ButtonState>();
  Stream<ButtonState> get onButtonStatusChanged =>
      _onButtonStatusChangedSubject.stream;

  Stream<InputStatus> _validateName(String? name) async* {
    _onSubmitStatusSubject.add(SubmitStatus.valid);
    yield userRepository.validateName(name);
  }

  Stream<InputStatus> _validateEmail(String? email) async* {
    _onSubmitStatusSubject.add(SubmitStatus.valid);
    yield userRepository.validateEmail(email);
  }

  Stream<InputStatus> _validatePassword(String? password) async* {
    _onSubmitStatusSubject.add(SubmitStatus.valid);
    yield userRepository.validatePassword(password);
  }

  Stream<InputStatus> _validateConfirmationPassword(
      String? confirmationPassword) async* {
    if (confirmationPassword == _passwordValue) {
      yield InputStatus.valid;
    } else {
      yield InputStatus.invalid;
    }
  }

  void _putValidOnStreams() {
    if (/*_onEmailInputStatusChangedSubject.valueOrNull == InputStatus.error ||
        _onNameInputStatusChangedSubject.valueOrNull == InputStatus.error ||
        _onPasswordInputStatusChangedSubject.valueOrNull == InputStatus.error ||
        _onPasswordConfirmationInputStatusChangedSubject.valueOrNull ==
            InputStatus.error*/
        _onSubmitStatusSubject.valueOrNull == SubmitStatus.emailAlreadyUsed) {
      _onEmailInputStatusChangedSubject.add(InputStatus.valid);
      _onNameInputStatusChangedSubject.add(InputStatus.valid);
      _onPasswordInputStatusChangedSubject.add(InputStatus.valid);
      _onPasswordConfirmationInputStatusChangedSubject.add(InputStatus.valid);
    }
  }

  Stream<SignUpAction> _submitSignUp() async* {
    try {
      _onButtonStatusChangedSubject.add(ButtonLoading());
      userRepository.signUpUser(_nameValue!, _emailValue!, _passwordValue!);
      _onSubmitStatusSubject.add(SubmitStatus.valid);
      yield SignUpSuccessAction();
    } catch (e) {
      _onButtonStatusChangedSubject.add(ButtonInactive());
      _onEmailInputStatusChangedSubject.add(InputStatus.error);
      _onNameInputStatusChangedSubject.add(InputStatus.error);
      _onPasswordInputStatusChangedSubject.add(InputStatus.error);
      _onPasswordConfirmationInputStatusChangedSubject.add(InputStatus.error);
      _onSubmitStatusSubject.add(SubmitStatus.emailAlreadyUsed);
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
