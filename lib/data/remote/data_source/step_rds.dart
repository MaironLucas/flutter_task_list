import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/data/mappers/remote_to_domain.dart';
import 'package:flutter_task_list/data/model/step.dart';

class StepRds {
  StepRds({
    required this.database,
  });

  final DatabaseReference database;

  static const String _stepTitle = 'title';
  static const String _stepState = 'isConcluded';

  Future<List<Step>> getStepList(String userId, String taskId) async {
    final newRef = database.child('$userId/tasks/$taskId');
    final snapshot = await newRef.get();
    if (snapshot.exists) {
      return snapshot.toStepList();
    } else {
      throw TaskDoesntHaveStepsException();
    }
  }

  Future<void> addStep(String userId, String taskId, String stepTitle) async {
    final newRef = database.child('$userId/tasks/$taskId/steps');
    await newRef.push().update({
      _stepTitle: stepTitle,
      _stepState: false,
    });
  }

  Future<void> removeStep(String userId, String taskId, String stepId) async {}

  Future<void> updateStepState(
      String userId, String taskId, String stepId, bool state) async {
    final newRef = database.child('$userId/tasks/$taskId/steps');
    await newRef.update({
      stepId: {
        _stepState: state,
      }
    });
  }
}
