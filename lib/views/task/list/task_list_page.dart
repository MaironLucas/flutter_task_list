import 'package:flutter/material.dart';
import 'package:flutter_task_list/config.dart';
import 'package:flutter_task_list/data/data_observables.dart';
import 'package:flutter_task_list/data/model/task_summary.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/views/common/async_snapshot_response_view.dart';
import 'package:flutter_task_list/views/common/empty_state.dart';
import 'package:flutter_task_list/views/task/task_details/task_details_page.dart';
import 'package:flutter_task_list/views/task/list/task_list_bloc.dart';
import 'package:flutter_task_list/views/task/list/task_list_models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage(
      {super.key,
      required this.bloc,
      required this.navigatorKey,
      required this.openModalTask});

  final TaskListBloc bloc;
  final Function openModalTask;
  final GlobalKey navigatorKey;

  static Widget create(GlobalKey navigatorKey, Function openModalTask) =>
      ProxyProvider2<TaskRepository, TaskListUpdateStreamWrapper, TaskListBloc>(
        update: (_, taskRepository, taskListUpdateStreamWrapper, __) =>
            TaskListBloc(
          taskListUpdateStream: taskListUpdateStreamWrapper.value,
          taskRepository: taskRepository,
        ),
        child: Consumer<TaskListBloc>(
          builder: (_, bloc, __) => TaskListPage(
            bloc: bloc,
            navigatorKey: navigatorKey,
            openModalTask: openModalTask,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Navigator(
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
                      body: success.taskList.isEmpty
                          ? EmptyState(
                              message: 'Your task list is empty, add one now!',
                              onTryAgainTap: () => bloc.onTryAgain.add(null),
                              buttonText: 'Atualizar',
                              asset: 'assets/add_task.png',
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              reverse: currentTheme.getOrderByStatus(),
                              itemCount: success.taskList.length,
                              itemBuilder: (context, index) {
                                final item = success.taskList[index];
                                return Slidable(
                                  key: ValueKey<TaskSummary>(item),
                                  endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    // dismissible:
                                    //     DismissiblePane(onDismissed: () {}),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) => openModalTask(
                                            1, item.name, item.description),
                                        backgroundColor: Colors.indigo,
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Edit',
                                      ),
                                      SlidableAction(
                                        onPressed: null,
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: () => Navigator.of(context)
                                        .push(_createRoute(item.name)),
                                    // onTap: () => Navigator.of(context)
                                    //     .push(MaterialPageRoute(
                                    //         builder: (context) => TaskPage(
                                    //               title: item.name,
                                    //             ))),
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
    );
  }

  void doNothing(BuildContext context) {}

  Route _createRoute(title) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TaskPage(
        title: title,
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
