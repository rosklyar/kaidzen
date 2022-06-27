class Task {
  final String name;
  final List<Task> subtasks;

  Task(this.name, {this.subtasks = const []});

  void addSubTask(Task subTask) {
    subtasks.add(subTask);
  }

  bool hasSubtasks() {
    return subtasks.isNotEmpty;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "name=" + name;
  }
}
