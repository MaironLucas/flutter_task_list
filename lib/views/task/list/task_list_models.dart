import 'package:flutter_task_list/data/model/task_summary.dart';

abstract class TaskListState {}

class Loading implements TaskListState {}

class Success implements TaskListState {
  Success({
    required this.taskList,
  });

  final List<TaskSummary> taskList;
}

class Error implements TaskListState {}

abstract class TaskListAction {}

class SuccessOnCreateTask implements TaskListAction {}

class FailOnCreateTask implements TaskListAction {}

class SuccessOnEditTask implements TaskListAction {}

class FailOnEditTask implements TaskListAction {}

class SuccessOnDeleteTask implements TaskListAction {}

class FailOnDeleteTask implements TaskListAction {}

class TaskInput {
  TaskInput({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}
