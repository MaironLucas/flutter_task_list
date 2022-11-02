import 'package:flutter_task_list/data/model/task.dart';

abstract class TasksState {}

class Loading implements TasksState {}

class Success implements TasksState {
  Success({
    required this.taskList,
  });

  final List<Task> taskList;
}

class Error implements TasksState {}
