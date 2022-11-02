import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/views/common/async_snapshot_response_view.dart';
import 'package:flutter_task_list/views/task/tasks_bloc.dart';
import 'package:flutter_task_list/views/task/tasks_models.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key, required this.bloc});

  final TasksBloc bloc;

  static Widget create() => ProxyProvider<TaskRepository, TasksBloc>(
        update: (_, taskRepository, __) => TasksBloc(
          taskRepository: taskRepository,
        ),
        child: Consumer<TasksBloc>(
          builder: (_, bloc, __) => TasksPage(
            bloc: bloc,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.onNewState,
      builder: (context, snapshot) =>
          AsyncSnapshotResponseView<Loading, Error, Success>(
        snapshot: snapshot,
        successWidgetBuilder: (constext, success) => ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: success.taskList.length,
          itemBuilder: (context, index) {
            final item = success.taskList[index];

            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.description),
            );
          },
        ),
      ),
    );
  }
}
