import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_task_list/data/model/task.dart';

extension TaskListRMtoDM on DataSnapshot {
  List<Task> toTaskList() {
    var taskList = <Task>[];
    final map = value as Map<dynamic, dynamic>;
    map.forEach((id, value) {
      taskList.add(
        Task(
          id: id,
          name: value['name'],
          description: value['description'],
        ),
      );
    });
    return taskList;
  }
}
