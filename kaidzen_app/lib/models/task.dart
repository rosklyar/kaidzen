import 'package:equatable/equatable.dart';

import '../assets/constants.dart';

class Task extends Equatable {
  int? id;
  String name;
  String status;
  List<Task> subtasks;

  Task(this.name, {this.status = Status.TODO, this.id, this.subtasks = const []});

  void addSubTask(Task subTask) {
    subtasks.add(subTask);
  }

  bool hasSubtasks() {
    return subtasks.isNotEmpty;
  }

  @override
  String toString() {
    return "name=" + name;
  }
  
  @override
  List<Object?> get props => [id, name, status];
}
