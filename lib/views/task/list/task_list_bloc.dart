import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/views/task/list/task_list_models.dart';
import 'package:rxdart/rxdart.dart';

class TaskListBloc with SubscriptionHolder {
  TaskListBloc({
    required this.taskRepository,
    required this.taskListUpdateStream,
  }) {
    Rx.merge<void>([
      Stream.value(null),
      _onTryAgainSubject,
      taskListUpdateStream,
    ])
        .flatMap(
          (_) => _fetchTaskList(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);
  }

  final TaskRepository taskRepository;
  final Stream<void> taskListUpdateStream;

  final _onNewStateSubject = BehaviorSubject<TaskListState>();
  Stream<TaskListState> get onNewState => _onNewStateSubject.stream;

  final _onTryAgainSubject = PublishSubject<void>();
  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Stream<TaskListState> _fetchTaskList() async* {
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
