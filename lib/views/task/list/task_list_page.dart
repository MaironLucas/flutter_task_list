import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/data_observables.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/views/common/async_snapshot_response_view.dart';
import 'package:flutter_task_list/views/common/empty_state.dart';
import 'package:flutter_task_list/views/task/task_details/task_details_page.dart';
import 'package:flutter_task_list/views/task/list/task_list_bloc.dart';
import 'package:flutter_task_list/views/task/list/task_list_models.dart';
import 'package:provider/provider.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key, required this.bloc});

  final TaskListBloc bloc;

  static Widget create() =>
      ProxyProvider2<TaskRepository, TaskListUpdateStreamWrapper, TaskListBloc>(
        update: (_, taskRepository, taskListUpdateStreamWrapper, __) =>
            TaskListBloc(
          taskListUpdateStream: taskListUpdateStreamWrapper.value,
          taskRepository: taskRepository,
        ),
        child: Consumer<TaskListBloc>(
          builder: (_, bloc, __) => TaskListPage(
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
        successWidgetBuilder: (constext, success) => success.taskList.isEmpty
            ? EmptyState(
                message: 'Your task list is empty, add one now!',
                onTryAgainTap: () => bloc.onTryAgain.add(null),
                buttonText: 'Atualizar',
                asset: 'assets/add_task.png',
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: success.taskList.length,
                itemBuilder: (context, index) {
                  final item = success.taskList[index];
                  return ListTile(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TaskPage())),
                    title: Text(item.name),
                    subtitle: Text(item.description),
                  );
                },
              ),
        errorWidgetBuilder: (context, error) => EmptyState(
          message: 'Fail to get tasks',
          onTryAgainTap: () => bloc.onTryAgain.add(null),
        ),
      ),
    );
  }
}
