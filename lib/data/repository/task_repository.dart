import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_list/data/model/task.dart';
import 'package:flutter_task_list/data/remote/data_source/task_rds.dart';

class TaskRepository {
  TaskRepository({
    required this.taskRds,
  });

  final TaskRds taskRds;

  Future<void> createTask(User user, String name, String description) =>
      taskRds.createTask(user, name, description);

  Future<List<Task>> getTasks(User user) => taskRds.getTasks(user);
}
