class TaskInput {
  TaskInput({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

abstract class HomeAction {}

class SuccessOnCreateTask implements HomeAction {}

class FailOnCreateTask implements HomeAction {}
