import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
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
  }

  final UserRepository userRepository;

  final _onNewStateSubject = BehaviorSubject<SettingsState>();
  Stream<SettingsState> get onNewState => _onNewStateSubject.stream;

  final _onSettingsActionSubject = PublishSubject<SettingsAction>();
  Stream<SettingsAction> get onSettingsAction =>
      _onSettingsActionSubject.stream;

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

  void dispose() {
    _onSettingsActionSubject.close();
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
    disposeAll();
  }
}
