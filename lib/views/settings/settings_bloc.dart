import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';

class SettingsBloc with SubscriptionHolder {
  SettingsBloc({
    required this.userRepository,
  });

  final UserRepository userRepository;
}
