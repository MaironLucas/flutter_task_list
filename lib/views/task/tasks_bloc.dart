import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/views/task/tasks_models.dart';
import 'package:rxdart/rxdart.dart';

class TasksBloc with SubscriptionHolder {
  TasksBloc({required this.taskRepository}) {
    Rx.merge<void>([
      Stream.value(null),
      _onTryAgainSubject,
    ])
        .flatMap(
          (_) => _fetchTaskList(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);
  }

  final TaskRepository taskRepository;

  final _onNewStateSubject = BehaviorSubject<TasksState>();
  Stream<TasksState> get onNewState => _onNewStateSubject.stream;

  final _onTryAgainSubject = PublishSubject<void>();
  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Stream<TasksState> _fetchTaskList() async* {
    yield Loading();
    try {
      var taskList = await taskRepository.getTasks(
        FirebaseAuth.instance.currentUser!,
      );
      yield Success(taskList: taskList);
    } catch (error) {
      yield Error();
    }
  }

  void dispose() {
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
    disposeAll();
  }
}
