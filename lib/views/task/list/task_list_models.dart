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
