import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../assets/constants.dart';

class Task extends Equatable {
  int? id;
  String name;
  DevelopmentCategory category;
  String status;
  List<Task> subtasks;
  Difficulty difficulty;

  Task(this.name, this.category, this.difficulty,
      {this.status = Status.TODO, this.id, this.subtasks = const []});

  void addSubTask(Task subTask) {
    subtasks.add(subTask);
  }

  bool hasSubtasks() {
    return subtasks.isNotEmpty;
  }

  @override
  String toString() {
    return "id: $id, name: $name, category: $category, status: $status, difficulty: $difficulty";
  }

  @override
  List<Object?> get props => [id, name, status, category, difficulty, subtasks];
}
