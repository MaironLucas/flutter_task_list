import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_task_list/data/model/step.dart';

class StepRds {
  StepRds({
    required this.database,
  });

  final DatabaseReference database;

  static const String _stepTitle = 'title';
  static const String _stepState = 'isConcluded';

  Future<void> getStepList(String userId, String taskId) async {}

  Future<void> addStep(String userId, String taskId, String stepTitle) async {
    final newRef = database.child('$userId/tasks/$taskId/steps');
    await newRef.push().update({
      _stepTitle: stepTitle,
      _stepState: false,
    });
  }

  Future<void> removeStep(String userId, String taskId, String stepId) async {}

  Future<void> updateStep(String userId, String taskId, Step newStep) async {}
}
