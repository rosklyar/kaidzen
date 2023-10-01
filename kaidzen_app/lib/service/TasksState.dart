import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/models/task.dart';
import "package:collection/collection.dart";
import 'package:kaidzen_app/service/AnalyticsService.dart';
import 'package:kaidzen_app/service/TaskRepository.dart';
import 'package:kaidzen_app/settings/ReviewUtils.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';
import 'package:kaidzen_app/tutorial/tutorialProgress.dart';

import '../achievements/event.dart';
import 'ProgressState.dart';

class TasksState extends ChangeNotifier {
  final TaskRepository repository;
  final ProgressState progressState;
  final AchievementsState achievementsState;
  final EmotionsState emotionsState;
  final TutorialState tutorialState;
  Map<String, List<Task>> _tasks;
  Map<int, Task> _tasksMap;

  TasksState({
    required this.repository,
    required this.progressState,
    required this.achievementsState,
    required this.emotionsState,
    required this.tutorialState,
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

    _tasks[Status.TODO]!.sort((a, b) => a.priority - b.priority);
    _tasks[Status.DOING]!.sort((a, b) => a.priority - b.priority);
    _tasks[Status.DONE]!.sort((a, b) => a.priority - b.priority);
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

  int getCountByStatus(String status) {
    List<Task> tasks = _tasks[status] ?? [];
    return tasks.length;
  }

  Task? getById(int id) {
    return _tasksMap[id];
  }

  int count() {
    return _tasks.values.map((value) => value.length).sum;
  }

  addTask(Task newTask) async {
    newTask.priority = calculateNewPriority(newTask, newTask.status);
    Task task = await repository.insert(newTask);
    await progressState.updateProgress(task);

    if (!tutorialState.tutorialCompleted()) {
      tutorialState.updateTutorialState(TutorialStep(
          tutorialState.tutorialProgress.completedStepsCount() + 1,
          DateTime.now()));
    }

    await loadAll();
    await updatePropertyAfterTaskAdded();
    await FirebaseAnalytics.instance
        .logEvent(name: AnalyticsEventType.goal_action.name, parameters: {
      "goal_id": task.id,
      "goal_name": task.name,
      "goal_sphere": task.category.id,
      "goal_impact": task.difficulty.id,
      "goal_status": Status.TODO,
      "is_created": "true",
      "is_simple": task.subtasks.isEmpty.toString()
    });
    var event = Event(EventType.taskCreated, DateTime.now(), task.category);
    await achievementsState.addEvent(event);
    notifyListeners();
  }

  updateTask(Task task) async {
    for (var subtask in task.subtasks) {
      subtask.category = task.category;
      await repository.update(subtask);
    }
    await repository.update(task);
    await loadAll();
    notifyListeners();
  }

  updateTasks(List<Task> tasks) async {
    for (var task in tasks) {
      await repository.update(task);
    }
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
      Task parentTask = getById(task.parent!)!;
      if (parentTask.subtasks.where((st) => st.status != Status.DONE).isEmpty) {
        await moveTask(parentTask, Status.DONE);
      }
      if (parentTask.status == Status.DONE && task.status != Status.DONE) {
        await moveTask(parentTask, Status.TODO);
      }
    }
    await loadAll();
    await updatePropertiesAfterTaskMoved();
    notifyListeners();
  }

  moveSubtaskOnlyAndNotify(Task task, String newStatus) async {
    await moveTask(task, newStatus);
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
    task.priority = calculateNewPriority(task, newStatus);

    String oldStatus = task.status;
    task.status = newStatus;
    if (task.status != Status.TODO) {
      await progressState.updateProgress(task);
      updateTaskTimestamps(task);
    }

    if (newStatus == Status.DONE && task.difficulty == Difficulty.HARD) {
      int doneCount = getCountByStatus(Status.DONE);
      if (doneCount > 3 && doneCount % 4 == 0) {
        await ReviewUtils.requestReview();
      }
    }

    await repository.update(task);

    var type = newStatus == Status.DOING
        ? EventType.taskInProgress
        : EventType.taskCompleted;
    var event = Event(type, DateTime.now(), task.category);
    await achievementsState.addEvent(event);
    await emotionsState.loadAll();

    await FirebaseAnalytics.instance
        .logEvent(name: AnalyticsEventType.goal_action.name, parameters: {
      "goal_id": task.id,
      "goal_name": task.name,
      "goal_sphere": task.category.id,
      "goal_impact": task.difficulty.id,
      "goal_status": newStatus,
      "is_created": "false",
      "goal_previous_status": oldStatus,
      "is_simple": task.subtasks.isEmpty.toString()
    });
  }

  void updateTaskTimestamps(Task task) {
    if (task.status == Status.DOING && task.inProgressTs == null) {
      task.inProgressTs = DateTime.now();
    } else if (task.status == Status.DONE && task.doneTs == null) {
      task.doneTs = DateTime.now();
    }
  }

  int calculateNewPriority(Task task, String newStatus) {
    var tasksCount = _tasks[newStatus]!.length;
    if (task.parent != null && newStatus == Status.TODO) {
      return 0;
    }
    return tasksCount == 0
        ? tasksCount
        : _tasks[newStatus]![tasksCount - 1].priority + 1;
  }
}
