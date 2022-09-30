import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/models/task.dart';
import "package:collection/collection.dart";
import 'package:kaidzen_app/service/AnalyticsService.dart';
import 'package:kaidzen_app/service/TaskRepository.dart';

import '../achievements/event.dart';
import 'ProgressState.dart';

class TasksState extends ChangeNotifier {
  final TaskRepository repository;
  final ProgressState progressState;
  final AchievementsState achievementsState;
  final EmotionsState emotionsState;
  Map<String, List<Task>> _tasks;
  Map<int, Task> _tasksMap;

  TasksState({
    required this.repository,
    required this.progressState,
    required this.achievementsState,
    required this.emotionsState,
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

  Task? getById(int id) {
    return _tasksMap[id];
  }

  int count() {
    return _tasks.values.map((value) => value.length).sum;
  }

  addTask(Task newTask) async {
    await repository.insert(newTask);
    await loadAll();
    await updatePropertyAfterTaskAdded();
    notifyListeners();
  }

  updateTask(Task task) async {
    await repository.update(task);
    await loadAll();
    notifyListeners();
  }

  Future<void> updatePropertyAfterTaskAdded() async {
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.GOALS_CREATED.name.toLowerCase(),
        value: count().toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_GOALS_DO.name.toLowerCase(),
        value: getByStatus(Status.TODO).length.toString());
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
    await updatePropertiesAfterTaskMoved();
    notifyListeners();
  }

  Future<void> updatePropertiesAfterTaskMoved() async {
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_GOALS_DO.name.toLowerCase(),
        value: getByStatus(Status.TODO).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_GOALS_DOING.name.toLowerCase(),
        value: getByStatus(Status.DOING).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_GOALS_DONE.name.toLowerCase(),
        value: getByStatus(Status.DONE).length.toString());
  }

  Future<void> moveTask(Task task, String newStatus) async {
    String oldStatus = task.status;
    task.status = newStatus;
    await repository.update(task);
    if (newStatus == Status.DONE) {
      await progressState.updateProgress(task);
    }
    var type = newStatus == Status.DOING
        ? EventType.taskInProgress
        : EventType.taskCompleted;
    debugPrint('moving task $task & $type');
    var event = Event(type, DateTime.now(), task.category);
    await achievementsState.addEvent(event);
    await emotionsState.updateEmotionPoints(event);

    await FirebaseAnalytics.instance
            .logEvent(name: AnalyticsEventType.GOAL_ACTION.name, parameters: {
          "goal_id": task.id,
          "goal_name": task.name,
          "goal_sphere": task.category.id,
          "goal_impact": task.difficulty.id,
          "goal_status": newStatus,
          "goal_previous_status": oldStatus,
          "goal_type": task.subtasks.isNotEmpty ? "WITH_SUB_GOALS" : "SIMPLE"
        });
  }
}
