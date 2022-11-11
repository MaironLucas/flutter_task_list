import 'package:flutter_task_list/data/model/task_summary.dart';
import 'package:flutter_task_list/data/remote/data_source/task_rds.dart';

class TaskRepository {
  TaskRepository({
    required this.taskRds,
  });

  final TaskRds taskRds;

  Future<void> createTask(String userId, String name, String description) =>
      taskRds.createTask(userId, name, description);

  Future<List<TaskSummary>> getTasks(String userId) => taskRds.getTasks(userId);

  Future<TaskSummary> getTaskSummary(String userId, String taskId) =>
      taskRds.getTaskSummary(userId, taskId);

  Future<void> updateTask(String userId, TaskSummary task) =>
      taskRds.updateTask(userId, task);

  Future<void> deleteTask(String userId, String taskId) =>
      taskRds.deleteTask(userId, taskId);
}
