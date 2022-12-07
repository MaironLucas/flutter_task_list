import 'package:flutter_task_list/data/model/task_summary.dart';

abstract class TaskListState {}

class Loading implements TaskListState {}

class Success implements TaskListState {
  Success({
    required this.taskList,
    required this.userId,
  });

  final List<TaskSummary> taskList;
  final String userId;
}

class Error implements TaskListState {}

abstract class TaskListAction {}

class SuccessOnCreateTask implements TaskListAction {}

class FailOnCreateTask implements TaskListAction {}

class SuccessOnEditTask implements TaskListAction {}

class FailOnEditTask implements TaskListAction {}

class SuccessOnDeleteTask implements TaskListAction {}

class FailOnDeleteTask implements TaskListAction {}

class UserIsTaskOwnerAction implements TaskListAction {}

class TaskAcceptInviteSuccess implements TaskListAction {}

class TaskAcceptInviteFail implements TaskListAction {}

class CanotDeleteTaskThatIsntYours implements TaskListAction {}

class TaskInput {
  TaskInput({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

enum TaskListOperation { share, edit, create }

class QRCodeScanResult {
  QRCodeScanResult({
    required this.userId,
    required this.taskId,
  });

  final String userId;
  final String taskId;
}
