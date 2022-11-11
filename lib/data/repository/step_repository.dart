import 'package:flutter_task_list/data/model/step.dart';
import 'package:flutter_task_list/data/remote/data_source/step_rds.dart';

class StepRepository {
  StepRepository({
    required this.stepRds,
  });

  final StepRds stepRds;

  Future<List<Step>> getStepList(String userId, String taskId) =>
      stepRds.getStepList(
        userId,
        taskId,
      );

  Future<void> addStep(String userId, String taskId, String stepTitle) =>
      stepRds.addStep(
        userId,
        taskId,
        stepTitle,
      );

  Future<void> updateStepState(
          String userId, String taskId, String stepId, bool state) =>
      stepRds.updateStepState(
        userId,
        taskId,
        stepId,
        state,
      );

  Future<void> updateStepName(
          String userId, String taskId, String stepId, String name) =>
      stepRds.updateStepName(
        userId,
        taskId,
        stepId,
        name,
      );

  Future<void> removeStep(String userId, String taskId, String stepId) =>
      stepRds.removeStep(userId, taskId, stepId);
}
