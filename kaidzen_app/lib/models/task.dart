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
  DateTime? doneTs;

  Task(this.name, this.category, this.difficulty,
      {this.status = Status.TODO,
      this.priority = 0,
      this.id,
      this.parent,
      this.doneTs});

  void addSubTask(Task subTask) {
    subtasks.add(subTask);
  }

  bool hasSubtasks() {
    return subtasks.isNotEmpty;
  }

  int uncompletedSubtaskCount() {
    return subtasks.where((st) => st.status != Status.DONE).length;
  }

  bool isSubtask() {
    return parent != null;
  }

  String shortenedName(int maxLength) {
    if (name.isNotEmpty && name.length > maxLength) {
      return name.substring(0, maxLength) + "...";
    }
    return name;
  }

  @override
  String toString() {
    return "id: $id, name: $name, category: $category, status: $status, difficulty: $difficulty, parent=$parent, doneTs=$doneTs";
  }

  @override
  List<Object?> get props =>
      [id, name, status, category, difficulty, subtasks, parent, doneTs];
}
