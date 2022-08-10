import 'package:flutter/widgets.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/task.dart';
import "package:collection/collection.dart";
import 'package:kaidzen_app/service/TaskRepository.dart';
import 'package:provider/provider.dart';

import '../achievements/event.dart';

class TasksState extends ChangeNotifier {
  final TaskRepository repository;
  Map<String, List<Task>> _tasks;

  TasksState({
    required this.repository,
  }) : _tasks = {};

  Future loadAll() async {
    List<Task> allTasks = await repository.getAll();
    _tasks = groupBy(allTasks, (Task task) => task.status);
    _tasks.putIfAbsent(Status.TODO, () => <Task>[]);
    _tasks.putIfAbsent(Status.DOING, () => <Task>[]);
    _tasks.putIfAbsent(Status.DONE, () => <Task>[]);
    notifyListeners();
  }

  List<Task> getByStatus(String status) {
    return _tasks[status] ?? [];
  }

  addTask(Task newTask) async {
    await repository.insert(newTask);
    _tasks[newTask.status]?.add(newTask);
    notifyListeners();
  }

  deleteTask(Task task) async {
    await repository.delete(task.id);
    _tasks[task.status]?.remove(task);
    notifyListeners();
  }

  moveTask(Task task, String newStatus) async {
    _tasks[task.status]?.remove(task);
    task.status = newStatus;
    await repository.update(task);
    _tasks[task.status]?.add(task);
    notifyListeners();
  }
}
