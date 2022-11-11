import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/data/mappers/remote_to_domain.dart';
import 'package:flutter_task_list/data/model/task_summary.dart';

class TaskRds {
  TaskRds({
    required this.database,
  });

  final DatabaseReference database;

  static const String _taskName = "name";
  static const String _taskDescription = "description";

  Future<void> createTask(
      String userId, String name, String description) async {
    try {
      final newRef = database.child('$userId/tasks');
      await newRef.push().update({
        _taskName: name,
        _taskDescription: description,
      });
    } catch (error) {}
  }

  Future<void> updateTask(String userId, TaskSummary task) async {
    final newRef = database.child('$userId/tasks');
    await newRef.update({
      task.id: {
        _taskName: task.name,
        _taskDescription: task.description,
      }
    });
  }

  Future<void> deleteTask(String userId, String taskId) async {
    final newRef = database.child('$userId/tasks');
    newRef.child(taskId).remove();
  }

  Future<List<TaskSummary>> getTasks(String userId) async {
    final newRef = database.child('$userId/tasks');
    final snapshot = await newRef.get();
    if (snapshot.exists) {
      return snapshot.toTaskList();
    } else {
      throw UserDoesntHaveTaskException();
    }
  }

  Future<TaskSummary> getTaskSummary(String userId, String taskId) async {
    final newRef = database.child('$userId/tasks/$taskId');
    final snapshot = await newRef.get();
    if (snapshot.exists) {
      return snapshot.toTaskSummaryDM();
    } else {
      throw Exception();
    }
  }
}
