import 'package:flutter_task_list/common/exceptions.dart';
import 'package:flutter_task_list/data/model/shared_task.dart';
import 'package:flutter_task_list/data/model/task_summary.dart';
import 'package:flutter_task_list/data/remote/data_source/task_rds.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';

class TaskRepository {
  TaskRepository({
    required this.taskRds,
  });

  final TaskRds taskRds;

  Future<SharedTask?> isSharedTask(String taskId, String userId) async {
    final sharedTaskList = await taskRds.getSharedTaskList(userId);
    try {
      return sharedTaskList.firstWhere(
        (sharedTask) => sharedTask.taskId == taskId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> createTask(String userId, String name, String description) =>
      taskRds.createTask(userId, name, description);

  Future<List<TaskSummary>> getTasks(String userId, OrderBy orderBy) =>
      taskRds.getTasks(userId, orderBy);

  Future<TaskSummary> getTaskSummary(String userId, String taskId) =>
      taskRds.getTaskSummary(userId, taskId);

  Future<void> updateTask(String userId, TaskSummary task) async {
    final sharedTask = await isSharedTask(task.id, userId);
    if (sharedTask != null) {
      await taskRds.updateTask(sharedTask.userId, task);
    } else {
      await taskRds.updateTask(userId, task);
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    final sharedTask = await isSharedTask(taskId, userId);
    if (sharedTask == null) {
      await taskRds.deleteTask(userId, taskId);
    } else {
      throw CantDeleteTaskThatIsntYoursException();
    }
  }

  Future<void> acceptTaskInvite(String userId, String ownerId, String taskId) =>
      taskRds.acceptTaskInvite(userId, ownerId, taskId);
}
