import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_task_list/data/model/task.dart';
import 'package:flutter_task_list/data/model/task_summary.dart';

extension TaskSummaryListRMtoDM on DataSnapshot {
  List<TaskSummary> toTaskList() {
    var taskList = <TaskSummary>[];
    final map = value as Map<dynamic, dynamic>;
    map.forEach((id, value) {
      taskList.add(
        TaskSummary(
          id: id,
          name: value['name'],
          description: value['description'],
        ),
      );
    });
    return taskList;
  }
}

extension TaskRMtoDM on DataSnapshot {
  /// falta implementar ainda
  Task toDM() {
    return Task(name: '', description: '', id: '');
  }
}
