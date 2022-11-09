import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/step_repository.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';

class TaskDetailsBloc with SubscriptionHolder {
  TaskDetailsBloc({
    required this.stepRepository,
    required this.taskRepository,
  }) {}

  final StepRepository stepRepository;
  final TaskRepository taskRepository;

  void dispose() {
    disposeAll();
  }
}
