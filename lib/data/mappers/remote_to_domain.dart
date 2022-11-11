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
    taskList.sort(orderBy == OrderBy.descending
        ? (a, b) => a.name.compareTo(b.name)
        : (a, b) => b.name.compareTo(a.name));
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
    stepList.sort(orderBy == OrderBy.descending
        ? (a, b) => a.title.compareTo(b.title)
        : (a, b) => b.title.compareTo(a.title));
    return stepList;
  }
}
