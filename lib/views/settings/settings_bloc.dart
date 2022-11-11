import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/settings/settings_models.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc with SubscriptionHolder {
  SettingsBloc({
    required this.userRepository,
  }) {
    Rx.merge<void>([
      Stream.value(null),
      _onTryAgainSubject,
    ])
        .flatMap(
          (_) => _fetchUserInfo(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);

    _onNameValueChangedSubject
        .flatMap(_validateName)
        .listen(_onNameInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onEmailValueChangedSubject
        .flatMap(_validateEmail)
        .listen(_onEmailInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onPasswordValueChangedSubject
        .flatMap(_validatePassword)
        .listen(_onPasswordInputStatusChangedSubject.add)
        .addTo(subscriptions);

    _onSubmitButtonClickSubject
        .flatMap((_) => _changeUserInfo())
        .listen(_onSignInActionSubject.add)
        .addTo(subscriptions);
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

  final _onSubmitStatusSubject = BehaviorSubject<SubmitStatus>();
  Stream<SubmitStatus> get onSubmitStatus => _onSubmitStatusSubject.stream;

  final _onSubmitButtonClickSubject = BehaviorSubject<void>();
  Sink<void> get onSubmitButtonClick => _onSubmitButtonClickSubject.sink;

  final _onNewStateSubject = BehaviorSubject<SettingsState>();
  Stream<SettingsState> get onNewState => _onNewStateSubject.stream;

  final _onSignInActionSubject = PublishSubject<SettingsAction>();
  Stream<SettingsAction> get onSignUpAction => _onSignInActionSubject.stream;

  final _onTryAgainSubject = PublishSubject<void>();
  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Stream<SettingsState> _fetchUserInfo() async* {
    yield Loading();
    try {
      final user = userRepository.getUser();
      yield Success(
        user: user.toUserData(),
      );
    } catch (e) {
      yield Error();
    }
  }

  Stream<SettingsAction> _changeUserInfo() async* {
    try {
      userRepository.changeUserInfo(_nameValue, _emailValue, _passwordValue);
      yield UserInfoChangeSuccessAction();
    } catch (e) {
      yield UserInfoChangeFailAction();
    }
  }

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

  void dispose() {
    _onEmailInputStatusChangedSubject.close();
    _onPasswordInputStatusChangedSubject.close();
    _onPasswordValueChangedSubject.close();
    _onEmailValueChangedSubject.close();
    _onSubmitButtonClickSubject.close();
    disposeAll();
  }
}
