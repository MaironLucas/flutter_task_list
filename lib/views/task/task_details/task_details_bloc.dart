import 'package:flutter_task_list/common/subscription_holder.dart';
import 'package:flutter_task_list/data/model/task.dart';
import 'package:flutter_task_list/data/repository/step_repository.dart';
import 'package:flutter_task_list/data/repository/task_repository.dart';
import 'package:flutter_task_list/data/repository/user_preference_repository.dart';
import 'package:flutter_task_list/data/repository/user_repository.dart';
import 'package:flutter_task_list/views/common/view_utils.dart';
import 'package:flutter_task_list/views/task/task_details/task_details_models.dart';
import 'package:rxdart/rxdart.dart';

class TaskDetailsBloc with SubscriptionHolder {
  TaskDetailsBloc({
    required this.stepRepository,
    required this.taskRepository,
    required this.userRepository,
    required this.userPreferenceRepository,
    required this.taskId,
  }) {
    Rx.merge<void>([
      Stream.value(null),
      _onTryAgainSubject,
    ])
        .flatMap(
          (_) => _fetchTask(),
        )
        .listen(_onNewStateSubject.add)
        .addTo(subscriptions);

    _onDeleteStepTapSubject
        .flatMap(_deleteStep)
        .listen(_onNewActionSubject.add)
        .addTo(subscriptions);

    _onEditStepTapSubject
        .flatMap(_editStep)
        .listen(_onNewActionSubject.add)
        .addTo(subscriptions);

    _onCompleteStepTapSubject
        .flatMap(_completeStep)
        .listen(_onNewActionSubject.add)
        .addTo(subscriptions);

    _onCreateStepTapSubject
        .flatMap(_createStep)
        .listen(_onNewActionSubject.add)
        .addTo(subscriptions);
  }

  final StepRepository stepRepository;
  final TaskRepository taskRepository;
  final UserRepository userRepository;
  final UserPreferenceRepository userPreferenceRepository;
  final String taskId;

  final _onNewStateSubject = BehaviorSubject<TaskDetailsState>();
  Stream<TaskDetailsState> get onNewState => _onNewStateSubject.stream;

  final _onNewActionSubject = PublishSubject<TaskDetailAction>();
  Stream<TaskDetailAction> get onNewAction => _onNewActionSubject.stream;

  final _onEditStepTapSubject = PublishSubject<EditStepInput>();
  Sink<EditStepInput> get onEditStepTap => _onEditStepTapSubject.sink;

  final _onDeleteStepTapSubject = PublishSubject<DeleteStepInput>();
  Sink<DeleteStepInput> get onDeleteStep => _onDeleteStepTapSubject.sink;

  final _onCompleteStepTapSubject = PublishSubject<CompleteStepInput>();
  Sink<CompleteStepInput> get onCompleteStep => _onCompleteStepTapSubject.sink;

  final _onCreateStepTapSubject = PublishSubject<CreateStepInput>();
  Sink<CreateStepInput> get onCreateStep => _onCreateStepTapSubject.sink;

  final _onTryAgainSubject = PublishSubject<void>();
  Sink<void> get onTryAgain => _onTryAgainSubject.sink;

  Stream<TaskDetailsState> _fetchTask() async* {
    yield Loading();
    try {
      final user = userRepository.getUser();
      final sharedTaskIds = await taskRepository.isSharedTask(taskId, user.uid);
      late String userId;
      if (sharedTaskIds != null) {
        userId = sharedTaskIds.userId;
      } else {
        userId = user.uid;
      }

      final orderBy = await userPreferenceRepository.getOrderBy() == 'Ascending'
          ? OrderBy.ascending
          : OrderBy.descending;
      final taskSummary = await taskRepository.getTaskSummary(userId, taskId);

      try {
        final stepList = await stepRepository.getStepList(
          userId,
          taskId,
          orderBy,
        );
        yield Success(
          task: Task(
            id: taskSummary.id,
            name: taskSummary.name,
            description: taskSummary.description,
            steps: stepList,
          ),
          ownerId: userId,
        );
      } catch (e) {
        yield Success(
          task: Task(
            id: taskSummary.id,
            name: taskSummary.name,
            description: taskSummary.description,
            steps: [],
          ),
          ownerId: userId,
        );
      }
    } catch (error) {
      yield Error();
    }
  }

  Stream<TaskDetailAction> _createStep(CreateStepInput stepInput) async* {
    try {
      final user = userRepository.getUser();
      final sharedTaskIds = await taskRepository.isSharedTask(taskId, user.uid);
      late String userId;
      if (sharedTaskIds != null) {
        userId = sharedTaskIds.userId;
      } else {
        userId = user.uid;
      }
      await stepRepository.addStep(
        userId,
        taskId,
        stepInput.name,
      );
      yield SuccessOnCreateStep();
      _onTryAgainSubject.add(null);
    } catch (e) {
      yield FailOnCreateStep();
    }
  }

  Stream<TaskDetailAction> _completeStep(CompleteStepInput input) async* {
    try {
      await stepRepository.updateStepState(
        input.ownerId,
        taskId,
        input.id,
        input.state,
      );
      yield SuccessOnCompleteStep();
      _onTryAgainSubject.add(null);
    } catch (e) {
      yield FailOnCompleteStep();
    }
  }

  Stream<TaskDetailAction> _editStep(EditStepInput input) async* {
    try {
      await stepRepository.updateStepName(
        input.ownerId,
        taskId,
        input.id,
        input.name,
      );
      yield SuccessOnEditStep();
      _onTryAgainSubject.add(null);
    } catch (e) {
      yield FailOnEditStep();
    }
  }

  Stream<TaskDetailAction> _deleteStep(DeleteStepInput input) async* {
    try {
      await stepRepository.removeStep(
        input.ownerId,
        taskId,
        input.id,
      );
      yield SuccessOnDeleteStep();
      _onTryAgainSubject.add(null);
    } catch (e) {
      yield FailOnDeleteStep();
    }
  }

  void dispose() {
    _onNewStateSubject.close();
    _onTryAgainSubject.close();
    _onDeleteStepTapSubject.close();
    _onEditStepTapSubject.close();
    _onCompleteStepTapSubject.close();
    disposeAll();
  }
}
