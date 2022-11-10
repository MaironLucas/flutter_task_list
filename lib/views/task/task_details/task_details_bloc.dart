import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/model/task.dart';
import 'package:flutter_task_list/data/repository/step_repository.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/task/task_details/task_details_models.dart';
import 'package:rxdart/rxdart.dart';

class TaskDetailsBloc with SubscriptionHolder {
  TaskDetailsBloc({
    required this.stepRepository,
    required this.taskRepository,
    required this.userRepository,
    required this.taskId,
  }) {
    Rx.merge<void>([
      Stream.value(null),
      _onTryAgainSubject,
    ])
        .flatMap(
          (_) => _fetchTask(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);
  }

  final StepRepository stepRepository;
  final TaskRepository taskRepository;
  final UserRepository userRepository;
  final String taskId;

  final _onNewStateSubject = BehaviorSubject<TaskDetailsState>();
  Stream<TaskDetailsState> get onNewState => _onNewStateSubject.stream;

  final _onTryAgainSubject = PublishSubject<void>();
  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Stream<TaskDetailsState> _fetchTask() async* {
    yield Loading();
    try {
      final user = userRepository.getUser();
      final taskSummary = await taskRepository.getTaskSummary(user, taskId);
      final stepList = await stepRepository.getStepList(user.uid, taskId);
      yield Success(
        task: Task(
          id: taskSummary.id,
          name: taskSummary.name,
          description: taskSummary.description,
          steps: stepList,
        ),
      );
    } catch (error) {
      yield Error();
    }
  }

  void dispose() {
    disposeAll();
  }
}
