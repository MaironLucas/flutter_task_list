import 'package:flutter_task_list/data/model/task.dart';

abstract class TaskDetailsState {}

class Loading implements TaskDetailsState {}

class Success implements TaskDetailsState {
  Success({
    required this.task,
  });

  final Task task;
}

class Error implements TaskDetailsState {}
