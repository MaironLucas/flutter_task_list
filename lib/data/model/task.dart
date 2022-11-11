import 'package:flutter_task_list/data/model/step.dart';

class Task {
  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
  });

  final String id;
  final String name;
  final String description;
  final List<Step> steps;
}
