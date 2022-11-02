import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/data/mappers/remote_to_domain.dart';
import 'package:flutter_task_list/data/model/task.dart';

class TaskRds {
  TaskRds({
    required this.database,
  });

  final DatabaseReference database;

  Future<void> createTask(User user, String name, String description) async {
    try {
      final newRef = database.child('${user.uid}/tasks');
      await newRef.push().update({
        "name": name,
        "description": description,
      });
    } catch (error) {}
  }

  Future<List<Task>> getTasks(User user) async {
    final newRef = database.child('${user.uid}/tasks');
    final snapshot = await newRef.get();
    if (snapshot.exists) {
      return snapshot.toTaskList();
    } else {
      throw UserDoesntHaveTaskException();
    }
  }
}
