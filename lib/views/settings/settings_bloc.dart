import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/user_preference_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/settings/settings_models.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc with SubscriptionHolder {
  SettingsBloc({
    required this.userRepository,
    required this.userPreferenceRepository,
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

    _onOrderByChangedSubject
        .flatMap(_changeOrderBy)
        .listen(_onSettingsActionSubject.add)
        .addTo(subscriptions);

    _onThemePreferenceChangedSubject
        .flatMap(_changeThemePreference)
        .listen(_onSettingsActionSubject.add)
        .addTo(subscriptions);
  }

  final UserRepository userRepository;
  final UserPreferenceRepository userPreferenceRepository;

  final _onNewStateSubject = BehaviorSubject<SettingsState>();
  Stream<SettingsState> get onNewState => _onNewStateSubject.stream;

  final _onSettingsActionSubject = PublishSubject<SettingsAction>();
  Stream<SettingsAction> get onSettingsAction =>
      _onSettingsActionSubject.stream;

  final _onOrderByChangedSubject = PublishSubject<String>();
  Sink<String> get onOrderByChanged => _onOrderByChangedSubject.sink;

  final _onThemePreferenceChangedSubject = PublishSubject<String>();
  Sink<String> get onThemePreferenceChanged =>
      _onThemePreferenceChangedSubject.sink;

  final _onTryAgainSubject = PublishSubject<void>();
  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Stream<SettingsState> _fetchUserInfo() async* {
    yield Loading();
    try {
      final user = userRepository.getUser();
      final orderBy = await userPreferenceRepository.getOrderBy();
      yield Success(
        user: user.toUserData(),
        orderBy: orderBy ?? 'Descending',
      );
    } catch (e) {
      yield Error();
    }
  }

  Stream<SettingsAction> _changeOrderBy(String orderBy) async* {
    try {
      await userPreferenceRepository.upsertOrderByPreference(orderBy);
      yield OrderByChangeSuccessAction();
      onTryAgain.add(null);
    } catch (e) {
      yield OrderByChangeFailAction();
    }
  }

  Stream<SettingsAction> _changeThemePreference(String themePreference) async* {
    try {
      await userPreferenceRepository.upsertThemePreference(themePreference);
      yield ThemePreferenceChangeSuccessAction();
    } catch (e) {
      yield ThemePreferenceChangeFailAction();
    }
  }

  void dispose() {
    _onSettingsActionSubject.close();
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
    _onThemePreferenceChangedSubject.close();
    _onOrderByChangedSubject.close();
    disposeAll();
  }
}
