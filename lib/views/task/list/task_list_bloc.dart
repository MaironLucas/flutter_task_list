import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/model/task_summary.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_preference_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/task/list/task_list_models.dart';
import 'package:rxdart/rxdart.dart';

class TaskListBloc with SubscriptionHolder {
  TaskListBloc({
    required this.taskRepository,
    required this.userRepository,
    required this.userPreferenceRepository,
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

    _onDeleteTaskTapSubject
        .flatMap(_deleteTask)
        .listen(_onNewActionSubject.add)
        .addTo(subscriptions);

    _onEditTaskTapSubject
        .flatMap(_editTask)
        .listen(_onNewActionSubject.add)
        .addTo(subscriptions);

    _onCreateTaskTapSubject
        .flatMap(_createTask)
        .listen(_onNewActionSubject.add)
        .addTo(subscriptions);
  }

  final TaskRepository taskRepository;
  final UserRepository userRepository;
  final UserPreferenceRepository userPreferenceRepository;
  final Stream<void> taskListUpdateStream;

  final _onNewStateSubject = BehaviorSubject<TaskListState>();
  Stream<TaskListState> get onNewState => _onNewStateSubject.stream;

  final _onNewActionSubject = PublishSubject<TaskListAction>();
  Stream<TaskListAction> get onNewAction => _onNewActionSubject.stream;

  final _onEditTaskTapSubject = PublishSubject<TaskSummary>();
  Sink<TaskSummary> get onEditTaskTap => _onEditTaskTapSubject.sink;

  final _onDeleteTaskTapSubject = PublishSubject<String>();
  Sink<String> get onDeleteTask => _onDeleteTaskTapSubject.sink;

  final _onCreateTaskTapSubject = PublishSubject<TaskInput>();
  Sink<TaskInput> get onCreateTaskTap => _onCreateTaskTapSubject.sink;

  final _onTryAgainSubject = PublishSubject<void>();
  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Stream<TaskListState> _fetchTaskList() async* {
    final orderBy = await userPreferenceRepository.getOrderBy() == 'Ascending'
        ? OrderBy.ascending
        : OrderBy.descending;
    yield Loading();
    try {
      var taskList = await taskRepository.getTasks(
        userRepository.getUser().uid,
        orderBy,
      );
      yield Success(taskList: taskList);
    } catch (error) {
      if (error is UserDoesntHaveTaskException) {
        yield Success(taskList: []);
      } else {
        yield Error();
      }
    }
  }

  Stream<TaskListAction> _editTask(TaskSummary task) async* {
    try {
      await taskRepository.updateTask(userRepository.getUser().uid, task);
      yield SuccessOnEditTask();
      _onTryAgainSubject.add(null);
    } catch (e) {
      yield FailOnEditTask();
    }
  }

  Stream<TaskListAction> _deleteTask(String taskId) async* {
    try {
      await taskRepository.deleteTask(userRepository.getUser().uid, taskId);
      yield SuccessOnDeleteTask();
      _onTryAgainSubject.add(null);
    } catch (e) {
      yield FailOnDeleteTask();
    }
  }

  Stream<TaskListAction> _createTask(TaskInput input) async* {
    try {
      final user = userRepository.getUser();
      await taskRepository.createTask(user.uid, input.name, input.description);
      _onTryAgainSubject.add(null);
      yield SuccessOnCreateTask();
    } catch (error) {
      yield FailOnCreateTask();
    }
  }

  void dispose() {
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
    _onDeleteTaskTapSubject.close();
    _onEditTaskTapSubject.close();
    disposeAll();
  }
}
