import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/home/home_model.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc with SubscriptionHolder {
  HomeBloc({
    required this.taskRepository,
    required this.userRepository,
    required this.taskListUpdateSink,
  }) {
    _onCreateTaskTapSubject
        .flatMap(_createTask)
        .listen(_onHomeActionSubject.add)
        .addTo(subscriptions);
  }

  final TaskRepository taskRepository;
  final UserRepository userRepository;
  final Sink<void> taskListUpdateSink;

  final _onCreateTaskTapSubject = PublishSubject<TaskInput>();
  Sink<TaskInput> get onCreateTaskTap => _onCreateTaskTapSubject.sink;

  final _onEditTaskTapSubject = PublishSubject<TaskInput>();
  Sink<TaskInput> get onEditTaskTap => _onEditTaskTapSubject.sink;

  final _onHomeActionSubject = PublishSubject<HomeAction>();
  Stream<HomeAction> get onHomeAction => _onHomeActionSubject.stream;

  Stream<HomeAction> _createTask(TaskInput input) async* {
    try {
      final user = userRepository.getUser();
      await taskRepository.createTask(user, input.name, input.description);
      taskListUpdateSink.add(null);
      yield SuccessOnCreateTask();
    } catch (error) {
      yield FailOnCreateTask();
    }
  }

  void dispose() {
    _onHomeActionSubject.close();
    _onCreateTaskTapSubject.close();
    _onEditTaskTapSubject.close();
    disposeAll();
  }
}
