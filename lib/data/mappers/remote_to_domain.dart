import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_task_list/data/model/step.dart';
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

extension TaskSummaryRMtoDM on DataSnapshot {
  /// falta implementar ainda
  TaskSummary toTaskSummaryDM() {
    return TaskSummary(
      id: '',
      name: '',
      description: '',
    );
  }
}

extension StepListRMtoDM on DataSnapshot {
  List<Step> toStepList() {
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
    return stepList;
  }
}
