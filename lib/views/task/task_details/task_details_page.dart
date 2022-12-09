import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_task_list/data/repository/step_repository.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_preference_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/action_handler.dart';
import 'package:flutter_task_list/views/common/async_snapshot_response_view.dart';
import 'package:flutter_task_list/views/common/empty_state.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/task/task_details/task_details_bloc.dart';
import 'package:flutter_task_list/views/task/task_details/task_details_models.dart';
import 'package:provider/provider.dart';

import 'modalItem/create_item_modal.dart';
import 'modalItem/edit_item_modal.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({
    super.key,
    required this.bloc,
    required this.taskName,
  });

  final TaskDetailsBloc bloc;
  final String taskName;

  static Widget create(String taskId, String taskName) => ProxyProvider4<
          StepRepository,
          TaskRepository,
          UserRepository,
          UserPreferenceRepository,
          TaskDetailsBloc>(
        update: (_, stepRepository, taskRepository, userRepository,
                userPreferenceRepository, __) =>
            TaskDetailsBloc(
          stepRepository: stepRepository,
          taskRepository: taskRepository,
          userRepository: userRepository,
          userPreferenceRepository: userPreferenceRepository,
          taskId: taskId,
        ),
        dispose: (_, bloc) => bloc.dispose(),
        child: Consumer<TaskDetailsBloc>(
          builder: (_, bloc, __) => TaskPage(
            bloc: bloc,
            taskName: taskName,
          ),
        ),
      );

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<String> lista = ["Item 1", "Item 2", "Item 3"];
  List<bool> isSelected = [false, false, false];

  TaskDetailsBloc get bloc => widget.bloc;

  void openModalItem(
    int op,
    String? title,
    BuildContext context, {
    String? stepId,
    String? ownerId,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: op == 0
              ? CreateItemModal(
                  onCreateItemTap: (CreateStepInput input) {
                    bloc.onCreateStep.add(input);
                  },
                )
              : EditItemModal(
                  onEditItemTap: (String name) {
                    bloc.onEditStepTap.add(
                      EditStepInput(
                        id: stepId!,
                        name: name,
                        ownerId: ownerId!,
                      ),
                    );
                  },
                  title: title!,
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ActionHandler<TaskDetailAction>(
      actionStream: bloc.onNewAction,
      onReceived: (action) {
        if (action is SuccessOnCreateStep) {
          displaySnackBar(context, 'Step created successfully!');
        } else if (action is FailOnCreateStep) {
          displaySnackBar(context, 'Fail on create Step!');
        } else if (action is SuccessOnCompleteStep) {
          displaySnackBar(context, 'Step state changed!');
        } else if (action is FailOnCompleteStep) {
          displaySnackBar(context, 'Fail on change step state!');
        } else if (action is SuccessOnDeleteStep) {
          displaySnackBar(context, 'Step is deleted!');
        } else if (action is FailOnDeleteStep) {
          displaySnackBar(context, 'Fail on delete Step!');
        } else if (action is SuccessOnEditStep) {
          displaySnackBar(context, 'Step name idited successfully!');
        } else if (action is FailOnCompleteStep) {
          displaySnackBar(context, 'Fail on edit Step name!');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.taskName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => openModalItem(
            0,
            '',
            context,
          ),
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Color.fromRGBO(217, 217, 217, 1),
          ),
        ),
        body: StreamBuilder(
          stream: bloc.onNewState,
          builder: (_, snapshot) =>
              AsyncSnapshotResponseView<Loading, Error, Success>(
            snapshot: snapshot,
            successWidgetBuilder: (_, success) => success.task.steps.isEmpty
                ? EmptyState(
                    message: 'This task doesnt have steps yet, add one now!',
                    onTryAgainTap: () => bloc.onTryAgain.add(null),
                    buttonText: 'Update',
                    asset: 'assets/add_task.png',
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: success.task.steps.length,
                    itemBuilder: (context, index) {
                      final item = success.task.steps[index];
                      return TextButton(
                        onPressed: () => bloc.onCompleteStep.add(
                          CompleteStepInput(
                            id: item.id,
                            state: !item.isConcluded,
                            ownerId: success.ownerId,
                          ),
                        ),
                        child: Slidable(
                          key: ValueKey<String>(item.id),
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) => bloc.onCompleteStep.add(
                                  CompleteStepInput(
                                    id: item.id,
                                    state: !item.isConcluded,
                                    ownerId: success.ownerId,
                                  ),
                                ),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                icon: Icons.check,
                              ),
                              SlidableAction(
                                onPressed: (context) => openModalItem(
                                  1,
                                  item.title,
                                  context,
                                  ownerId: success.ownerId,
                                  stepId: item.id,
                                ),
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                              ),
                              SlidableAction(
                                onPressed: (_) => bloc.onDeleteStep.add(
                                  DeleteStepInput(
                                    id: item.id,
                                    ownerId: success.ownerId,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: ListTile(
                            tileColor: item.isConcluded
                                ? Colors.blue
                                : Colors.transparent,
                            title: Text(item.title),
                          ),
                        ),
                      );
                    },
                  ),
            errorWidgetBuilder: (context, error) => EmptyState(
              message: 'Fail to get steps',
              onTryAgainTap: () => bloc.onTryAgain.add(null),
            ),
          ),
        ),
      ),
    );
  }
}
