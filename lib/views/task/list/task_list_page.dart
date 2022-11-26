import 'package:flutter/material.dart';
import 'package:flutter_task_list/config.dart';
import 'package:flutter_task_list/data/data_observables.dart';
import 'package:flutter_task_list/data/model/task_summary.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_preference_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/action_handler.dart';
import 'package:flutter_task_list/views/common/async_snapshot_response_view.dart';
import 'package:flutter_task_list/views/common/empty_state.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/task/task_details/task_details_page.dart';
import 'package:flutter_task_list/views/task/list/task_list_bloc.dart';
import 'package:flutter_task_list/views/task/list/task_list_models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'modal/create_task_modal.dart';
import 'modal/edit_task_modal.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage(
      {super.key, required this.bloc, required this.navigatorKey});

  final TaskListBloc bloc;
  final GlobalKey navigatorKey;

  static Widget create(GlobalKey navigatorKey) => ProxyProvider4<
          TaskRepository,
          UserRepository,
          UserPreferenceRepository,
          TaskListUpdateStreamWrapper,
          TaskListBloc>(
        update: (_, taskRepository, userRepository, userPreferenceRepository,
                taskListUpdateStreamWrapper, __) =>
            TaskListBloc(
          userRepository: userRepository,
          userPreferenceRepository: userPreferenceRepository,
          taskRepository: taskRepository,
          taskListUpdateStream: taskListUpdateStreamWrapper.value,
        ),
        child: Consumer<TaskListBloc>(
          builder: (_, bloc, __) => TaskListPage(
            bloc: bloc,
            navigatorKey: navigatorKey,
          ),
        ),
      );

  void openModalTask(int op, BuildContext context, {TaskSummary? task}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: op == 0
              ? CreateTaskModal(
                  onCreateTaskTap: (TaskInput input) {
                    bloc.onCreateTaskTap.add(input);
                  },
                )
              : EditTaskModal(
                  onEditTaskTap: (TaskSummary task) {
                    bloc.onEditTaskTap.add(task);
                  },
                  task: task!,
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActionHandler<TaskListAction>(
      actionStream: bloc.onNewAction,
      onReceived: (action) {
        if (action is SuccessOnCreateTask) {
          displaySnackBar(context, 'Task created successfully!');
        } else if (action is FailOnCreateTask) {
          displaySnackBar(context, 'Fail on create Task!');
        } else if (action is SuccessOnDeleteTask) {
          displaySnackBar(context, 'Task deleted!');
        } else if (action is FailOnDeleteTask) {
          displaySnackBar(context, 'Fail on delete Task!');
        } else if (action is SuccessOnEditTask) {
          displaySnackBar(context, 'Task edited successfully!');
        } else if (action is FailOnEditTask) {
          displaySnackBar(context, 'Fail on edit Task!');
        }
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                return StreamBuilder(
                  stream: bloc.onNewState,
                  builder: (context, snapshot) =>
                      AsyncSnapshotResponseView<Loading, Error, Success>(
                    snapshot: snapshot,
                    successWidgetBuilder: (context, success) {
                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          centerTitle: true,
                          title: Text(
                            "Tasks",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () => openModalTask(0, context),
                          backgroundColor: Colors.indigoAccent,
                          child: const Icon(
                            Icons.add,
                            color: Color.fromRGBO(217, 217, 217, 1),
                          ),
                        ),
                        body: success.taskList.isEmpty
                            ? EmptyState(
                                message:
                                    'Your task list is empty, add one now!',
                                onTryAgainTap: () => bloc.onTryAgain.add(null),
                                buttonText: 'Update',
                                asset: 'assets/add_task.png',
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: success.taskList.length,
                                itemBuilder: (context, index) {
                                  final item = success.taskList[index];
                                  return Slidable(
                                    key: ValueKey<TaskSummary>(item),
                                    endActionPane: ActionPane(
                                      motion: const BehindMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) => openModalTask(
                                            1,
                                            context,
                                            task: item,
                                          ),
                                          backgroundColor: Colors.indigo,
                                          foregroundColor: Colors.white,
                                          icon: Icons.edit,
                                          label: 'Edit',
                                        ),
                                        SlidableAction(
                                          onPressed: (_) =>
                                              bloc.onDeleteTask.add(item.id),
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      onTap: () => Navigator.of(context).push(
                                          _createRoute(item.id, item.name)),
                                      title: Text(item.name),
                                      subtitle: Text(item.description),
                                    ),
                                  );
                                },
                              ),
                      );
                    },
                    errorWidgetBuilder: (context, error) => EmptyState(
                      message: 'Fail to get tasks',
                      onTryAgainTap: () => bloc.onTryAgain.add(null),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  void doNothing(BuildContext context) {}

  Route _createRoute(String taskId, String taskName) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TaskPage.create(
        taskId,
        taskName,
      ),
      transitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.fastLinearToSlowEaseIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
