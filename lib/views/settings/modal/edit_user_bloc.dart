import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/settings/modal/edit_user_models.dart';
import 'package:rxdart/rxdart.dart';

class EditUserBloc with SubscriptionHolder {
  EditUserBloc({
    required this.userRepository,
  }) {
    _onPasswordValueChangedSubject.add('');

    _onNameValueChangedSubject
        .flatMap(_validateName)
        .listen(_onNameInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onPasswordValueChangedSubject
        .flatMap((password) {
          _onPasswordConfirmationValueChangedSubject
              .add(_passwordConfirmationValue ?? '');
          return _validatePassword(password);
        })
        .listen(_onPasswordInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onPasswordConfirmationValueChangedSubject
        .flatMap(_validateConfirmationPassword)
        .listen(_onPasswordConfirmationInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onSubmitButtonClickSubject
        .flatMap((_) => _submitChanges())
        .listen(_onEditUserActionSubject.add)
        .addTo(subscriptions);

    Rx.combineLatest3(
      _onNameInputStatusChangedSubject,
      _onPasswordInputStatusChangedSubject,
      _onPasswordConfirmationInputStatusChangedSubject,
      (nameStatus, passwordStatus, passwordConfirmationStatus) {
        if (nameStatus == InputStatus.valid &&
            ((passwordStatus == InputStatus.valid &&
                    passwordConfirmationStatus == InputStatus.valid) ||
                (passwordStatus == InputStatus.empty &&
                    passwordConfirmationStatus == InputStatus.empty))) {
          return ButtonActive();
        }
        return ButtonInactive();
      },
    ).listen(_onButtonStatusChangedSubject.add).addTo(subscriptions);
  }

  final UserRepository userRepository;

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
  String? get _passwordConfirmationValue =>
      _onPasswordConfirmationValueChangedSubject.valueOrNull;

  final _onPasswordConfirmationInputStatusChangedSubject =
      BehaviorSubject<InputStatus>();
  Stream<InputStatus> get onPasswordConfirmationInputStatusChanged =>
      _onPasswordConfirmationInputStatusChangedSubject.stream;

  final _onSubmitButtonClickSubject = BehaviorSubject<void>();
  Sink<void> get onSubmitButtonClick => _onSubmitButtonClickSubject.sink;

  final _onEditUserActionSubject = PublishSubject<EditUserAction>();
  Stream<EditUserAction> get onEditUserAction =>
      _onEditUserActionSubject.stream;

  final _onButtonStatusChangedSubject = PublishSubject<ButtonState>();
  Stream<ButtonState> get onButtonStatusChanged =>
      _onButtonStatusChangedSubject.stream;

  final _onSubmitStatusSubject = BehaviorSubject<SubmitStatus>();
  Stream<SubmitStatus> get onSubmitStatus => _onSubmitStatusSubject.stream;

  Stream<InputStatus> _validateName(String? name) async* {
    _onSubmitStatusSubject.add(SubmitStatus.valid);
    yield userRepository.validateName(name);
  }

  Stream<InputStatus> _validatePassword(String? password) async* {
    _onSubmitStatusSubject.add(SubmitStatus.valid);
    var passwordStatus = userRepository.validatePassword(password);
    if (password == '') {
      passwordStatus = InputStatus.valid;
    }
    yield passwordStatus;
  }

  Stream<InputStatus> _validateConfirmationPassword(
      String? confirmationPassword) async* {
    if (confirmationPassword == _passwordValue) {
      yield InputStatus.valid;
    } else {
      yield InputStatus.invalid;
    }
  }

  Stream<EditUserAction> _submitChanges() async* {
    try {
      _onButtonStatusChangedSubject.add(ButtonLoading());
      await userRepository.changeUserInfo(_nameValue, _passwordValue);
      _onSubmitStatusSubject.add(SubmitStatus.valid);
      yield SuccessOnEditUser();
    } catch (error) {
      _onButtonStatusChangedSubject.add(ButtonInactive());
      if (error is WeakPasswordException) {
        _onPasswordInputStatusChangedSubject.add(InputStatus.error);
        _onPasswordConfirmationInputStatusChangedSubject.add(InputStatus.error);
        _onSubmitStatusSubject.add(SubmitStatus.weakPassword);
      } else if (error is UserNeedsLoginException) {
        yield PopToLogin();
      } else {
        _onSubmitStatusSubject.add(SubmitStatus.invalid);
        _onButtonStatusChangedSubject.add(ButtonActive());
      }
    }
  }

  void dispose() {
    disposeAll();
  }
}
