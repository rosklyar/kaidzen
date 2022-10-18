import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../assets/constants.dart';

class Task extends Equatable {
  int? id;
  String name;
  DevelopmentCategory category;
  String status;
  int priority;
  List<Task> subtasks = List.empty(growable: true);
  Difficulty difficulty;
  int? parent;

  Task(this.name, this.category, this.difficulty,
      {this.status = Status.TODO, this.priority = 0, this.id, this.parent});

  void addSubTask(Task subTask) {
    subtasks.add(subTask);
  }

  bool hasSubtasks() {
    return subtasks.isNotEmpty;
  }

  @override
  String toString() {
    return "id: $id, name: $name, category: $category, status: $status, difficulty: $difficulty, parent=$parent";
  }

  @override
  List<Object?> get props =>
      [id, name, status, category, difficulty, subtasks, parent];
}
