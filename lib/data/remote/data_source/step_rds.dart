import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/data/mappers/remote_to_domain.dart';
import 'package:flutter_task_list/data/model/step.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';

class StepRds {
  StepRds({
    required this.database,
  });

  final DatabaseReference database;

  static const String _stepTitle = 'title';
  static const String _stepState = 'isConcluded';

  Future<List<Step>> getStepList(
      String userId, String taskId, OrderBy orderBy) async {
    final newRef = database.child('$userId/tasks/$taskId/steps');
    final snapshot = await newRef.get();
    if (snapshot.exists) {
      return snapshot.toStepList(orderBy);
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

  Future<void> removeStep(String userId, String taskId, String stepId) async {
    final newRef = database.child('$userId/tasks/$taskId/steps');
    newRef.child(stepId).remove();
  }

  Future<void> updateStepState(
      String userId, String taskId, String stepId, bool state) async {
    final newRef = database.child('$userId/tasks/$taskId/steps');
    await newRef.child(stepId).update({
      _stepState: state,
    });
  }

  Future<void> updateStepName(
      String userId, String taskId, String stepId, String name) async {
    final newRef = database.child('$userId/tasks/$taskId/steps');
    await newRef.child(stepId).update({
      _stepTitle: name,
    });
  }
}
