import 'package:flutter/widgets.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/task.dart';
import "package:collection/collection.dart";
import 'package:kaidzen_app/service/TaskRepository.dart';
import 'package:provider/provider.dart';

import '../achievements/event.dart';
import 'ProgressState.dart';

import 'ProgressState.dart';

class TasksState extends ChangeNotifier {
  final TaskRepository repository;
  final ProgressState progressState;
  final AchievementsState achievementsState;
  Map<String, List<Task>> _tasks;
  Map<int, Task> _tasksMap;

  TasksState({
    required this.repository,
    required this.progressState,
    required this.achievementsState,
  })  : _tasks = {},
        _tasksMap = {};

  Future loadAll() async {
    List<Task> allTasks = await repository.getAll();
    _tasksMap = {for (Task task in allTasks) task.id!: task};

    for (var t in allTasks) {
      if (t.parent != null) {
        _tasksMap[t.parent]!.addSubTask(t);
      }
    }
    _tasks = groupBy(allTasks, (Task task) => task.status);
    _tasks.putIfAbsent(Status.TODO, () => <Task>[]);
    _tasks.putIfAbsent(Status.DOING, () => <Task>[]);
    _tasks.putIfAbsent(Status.DONE, () => <Task>[]);
    notifyListeners();
  }

  List<Task> getByStatus(String status) {
    List<Task> tasks = _tasks[status] ?? [];
    if (status == Status.TODO) {
      return tasks.where((t) => t.parent == null).toList();
    } else if (status == Status.DONE) {
      return tasks
          .whereNot((t) =>
              t.parent != null && _tasksMap[t.parent]!.status == Status.DONE)
          .toList();
    }
    return tasks;
  }

  Task getById(int id) {
    return _tasksMap[id]!;
  }

  addTask(Task newTask) async {
    await repository.insert(newTask);
    await loadAll();
    notifyListeners();
  }

  deleteTask(Task task) async {
    await repository.delete(task.id);
    await loadAll();
    notifyListeners();
  }

  moveTaskAndNotify(Task task, String newStatus) async {
    await moveTask(task, newStatus);
    if (task.parent != null) {
      Task parentTask = _tasksMap[task.parent]!;
      if (parentTask.subtasks.where((st) => st.status != Status.DONE).isEmpty) {
        await moveTask(parentTask, Status.DONE);
      }
    }
    await loadAll();
    notifyListeners();
  }

  Future<void> moveTask(Task task, String newStatus) async {
    task.status = newStatus;
    await repository.update(task);
    if (newStatus == Status.DONE) {
      await progressState.updateProgress(task);
      await achievementsState.addEvent(Event(EventType.completed, DateTime.now()));
    }
  }
}
