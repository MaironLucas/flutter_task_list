import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_task_list/data/model/step.dart';
import 'package:flutter_task_list/data/model/task_summary.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';

extension TaskSummaryListRMtoDM on DataSnapshot {
  List<TaskSummary> toTaskList(OrderBy orderBy) {
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
    taskList.sort(orderBy == OrderBy.ascending
        ? (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())
        : (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    return taskList;
  }
}

extension TaskSummaryRMtoDM on DataSnapshot {
  TaskSummary toTaskSummaryDM() {
    return TaskSummary(
      id: '',
      name: '',
      description: '',
    );
  }
}

extension StepListRMtoDM on DataSnapshot {
  List<Step> toStepList(OrderBy orderBy) {
    var stepList = <Step>[];
    final map = value as Map<dynamic, dynamic>;
    map.forEach(
      (id, value) => stepList.add(
        Step(
          id: id,
          title: value['title'],
          isConcluded: value['isConcluded'],
        ),
      ),
    );
    stepList.sort(orderBy == OrderBy.ascending
        ? (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase())
        : (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    return stepList;
  }
}
