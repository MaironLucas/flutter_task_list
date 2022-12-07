import 'package:flutter_task_list/data/model/task.dart';

abstract class TaskDetailsState {}

class Loading implements TaskDetailsState {}

class Success implements TaskDetailsState {
  Success({
    required this.task,
    required this.ownerId,
  });

  final Task task;
  final String ownerId;
}

class Error implements TaskDetailsState {}

abstract class TaskDetailAction {}

class SuccessOnCreateStep implements TaskDetailAction {}

class FailOnCreateStep implements TaskDetailAction {}

class SuccessOnEditStep implements TaskDetailAction {}

class FailOnEditStep implements TaskDetailAction {}

class SuccessOnDeleteStep implements TaskDetailAction {}

class FailOnDeleteStep implements TaskDetailAction {}

class SuccessOnCompleteStep implements TaskDetailAction {}

class FailOnCompleteStep implements TaskDetailAction {}

class CreateStepInput {
  CreateStepInput({
    required this.name,
  });

  final String name;
}

class CompleteStepInput {
  CompleteStepInput({
    required this.id,
    required this.state,
    required this.ownerId,
  });

  final String id;
  final bool state;
  final String ownerId;
}

class EditStepInput {
  EditStepInput({
    required this.id,
    required this.name,
    required this.ownerId,
  });

  final String id;
  final String name;
  final String ownerId;
}

class DeleteStepInput {
  DeleteStepInput({
    required this.id,
    required this.ownerId,
  });

  final String id;
  final String ownerId;
}
