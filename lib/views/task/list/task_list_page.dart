import 'package:flutter/material.dart';
import 'package:flutter_task_list/data/data_observables.dart';
import 'package:flutter_task_list/data/model/task_summary.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_preference_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/action_handler.dart';
import 'package:flutter_task_list/views/common/async_snapshot_response_view.dart';
import 'package:flutter_task_list/views/common/empty_state.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/task/list/modal/share_task_modal.dart';
import 'package:flutter_task_list/views/task/share/share_task.dart';
import 'package:flutter_task_list/views/task/task_details/task_details_page.dart';
import 'package:flutter_task_list/views/task/list/task_list_bloc.dart';
import 'package:flutter_task_list/views/task/list/task_list_models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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

  void openModalTask(TaskListOperation op, BuildContext context,
      {TaskSummary? task, String? userId}) {
    late Widget modalOperation;
    switch (op) {
      case TaskListOperation.create:
        modalOperation = CreateTaskModal(
          onCreateTaskTap: (TaskInput input) {
            bloc.onCreateTaskTap.add(input);
          },
        );
        break;
      case TaskListOperation.edit:
        modalOperation = EditTaskModal(
          onEditTaskTap: (TaskSummary task) {
            bloc.onEditTaskTap.add(task);
          },
          task: task!,
        );
        break;
      case TaskListOperation.share:
        modalOperation = ShareTaskModal(
          taskId: task!.id,
          userId: userId!,
        );
        break;
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: modalOperation,
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
        } else if (action is UserIsTaskOwnerAction) {
          displaySnackBar(context, 'This Task is yours, cant accept invite!');
        } else if (action is TaskAcceptInviteSuccess) {
          displaySnackBar(context, 'Task has been added to your list!');
        } else if (action is TaskAcceptInviteSuccess) {
          displaySnackBar(context, 'Fail on accept task invite!');
        } else if (action is CanotDeleteTaskThatIsntYours) {
          displaySnackBar(context, 'You cant delete task that isnt yours!');
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
                          actions: [
                            IconButton(
                              onPressed: () => ShareTask.show(
                                context: context,
                                format: BarcodeFormat.qrcode,
                              ).then((qrCodeResult) {
                                if (qrCodeResult != null) {
                                  bloc.onNewTaskInvite.add(qrCodeResult);
                                }
                              }),
                              icon: const Icon(
                                Icons.camera_alt,
                              ),
                            ),
                          ],
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () => openModalTask(
                            TaskListOperation.create,
                            context,
                          ),
                          backgroundColor: Colors.blue,
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
                                            TaskListOperation.share,
                                            context,
                                            task: item,
                                            userId: success.userId,
                                          ),
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          icon: Icons.share,
                                          label: 'Share',
                                        ),
                                        SlidableAction(
                                          onPressed: (context) => openModalTask(
                                            TaskListOperation.edit,
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
