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
import '../models/habit.dart';
import 'HabitRepository.dart';
import 'ProgressState.dart';

class HabitState extends ChangeNotifier {
  final HabitRepository repository;
  final ProgressState progressState;
  final AchievementsState achievementsState;
  final EmotionsState emotionsState;
  final TutorialState tutorialState;
  Map<String, List<Habit>> _habits;
  Map<int, Habit> _habitsMap;

  HabitState({
    required this.repository,
    required this.progressState,
    required this.achievementsState,
    required this.emotionsState,
    required this.tutorialState,
  })  : _habits = {},
        _habitsMap = {};

  Future loadAll() async {
    List<Habit> allHabits = await repository.getAll();
    _habitsMap = {for (Habit habit in allHabits) habit.id!: habit};

    _habits = groupBy(allHabits, (Habit habit) => habit.task.status);
    _habits.putIfAbsent(Status.TODO, () => <Habit>[]);
    _habits.putIfAbsent(Status.DOING, () => <Habit>[]);
    _habits.putIfAbsent(Status.DONE, () => <Habit>[]);

    _habits[Status.TODO]!.sort((a, b) => a.task.priority - b.task.priority);
    _habits[Status.DOING]!.sort((a, b) => a.task.priority - b.task.priority);
    _habits[Status.DONE]!.sort((a, b) => a.task.priority - b.task.priority);
    notifyListeners();
  }

  List<Habit> getByStatus(String status) {
    return _habits[status] ?? [];
  }

  int getCountByStatus(String status) {
    List<Habit> habits = _habits[status] ?? [];
    return habits.length;
  }

  Habit? getById(int id) {
    return _habitsMap[id];
  }

  int count() {
    return _habits.values.map((value) => value.length).sum;
  }

  addHabit(Habit newHabit) async {
    newHabit.task.priority =
        calculateNewPriority(newHabit.task, newHabit.task.status);
    Habit habit = await repository.insert(newHabit);
    await progressState.updateHabitProgress(habit);

    if (!tutorialState.tutorialCompleted()) {
      tutorialState.updateTutorialState(TutorialStep(
          tutorialState.tutorialProgress.completedStepsCount() + 1,
          DateTime.now()));
    }

    await loadAll();
    await FirebaseAnalytics.instance
        .logEvent(name: AnalyticsEventType.habit_action.name, parameters: {
      "habit_id": habit.id,
      "habit_name": habit.task.name,
      "habit_sphere": habit.task.category.id,
      "habit_impact": habit.task.difficulty.id,
      "habit_status": Status.TODO,
      "is_created": "true",
      "is_simple": habit.task.subtasks.isEmpty.toString()
    });
    var event =
        Event(EventType.taskCreated, DateTime.now(), habit.task.category);
    await achievementsState.addEvent(event);
    notifyListeners();
  }

  trackHabit(Habit habit) async {
    var type = habit.getType();
    var stageTotal = type == HabitType.FIXED
        ? habit.totalCount
        : type.stageCount[habit.stage];
    habit.stageCount += 1;
    if (habit.stageCount == stageTotal) {
      if (habit.stage == type.stageCount.length) {
        await moveHabitAndNotify(habit, Status.DONE);
      } else {
        habit.stage += 1;
        habit.stageCount = 0;
        await updateHabit(habit);
      }
    } else {
      await updateHabit(habit);
    }

    await progressState.updateHabitProgress(habit);
    updateHabitTimestamps(habit);
    var event =
        Event(EventType.habitTracked, DateTime.now(), habit.task.category);
    await achievementsState.addEvent(event);
    notifyListeners();
  }

  updateHabit(Habit habit) async {
    await repository.update(habit);
    await loadAll();
    notifyListeners();
  }

  updateHabits(List<Habit> habits) async {
    for (var habit in habits) {
      await repository.update(habit);
    }
    await loadAll();
    notifyListeners();
  }

  deleteHabit(Habit habit) async {
    await repository.delete(habit.id);
    await loadAll();
    notifyListeners();
  }

  Future<void> updatePropertyAfterHabitAdded() async {
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.HABITS_CREATED.name.toLowerCase(),
        value: count().toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_HABITS_DO.name.toLowerCase(),
        value: getByStatus(Status.TODO).length.toString());
  }

  int calculateNewPriority(Task task, String newStatus) {
    var tasksCount = _habits[newStatus]!.length;
    if (task.parent != null && newStatus == Status.TODO) {
      return 0;
    }
    return tasksCount == 0
        ? tasksCount
        : _habits[newStatus]![tasksCount - 1].task.priority + 1;
  }

  Future<void> moveHabitAndNotify(Habit habit, String newStatus) async {
    await moveHabit(habit, newStatus);
    await loadAll();
    await updatePropertiesAfterHabitMoved();
    notifyListeners();
  }

  Future<void> updatePropertiesAfterHabitMoved() async {
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_HABITS_DO.name.toLowerCase(),
        value: getByStatus(Status.TODO).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_HABITS_DOING.name.toLowerCase(),
        value: getByStatus(Status.DOING).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_HABITS_DONE.name.toLowerCase(),
        value: getByStatus(Status.DONE).length.toString());
  }

  Future<void> moveHabit(Habit habit, String newStatus) async {
    habit.task.priority = calculateNewPriority(habit.task, newStatus);

    String oldStatus = habit.task.status;
    habit.task.status = newStatus;
    if (habit.task.status != Status.TODO) {
      await progressState.updateHabitProgress(habit);
      updateHabitTimestamps(habit);
    }
    if (oldStatus == Status.DONE) {
      var stageTotal = habit.getType() == HabitType.FIXED
          ? habit.totalCount
          : habit.getType().stageCount[habit.stage];
      if (habit.stageCount == stageTotal) {
        habit.stageCount--;
      }
    }

    await repository.update(habit);

    var type = newStatus == Status.DOING
        ? EventType.habitInProgress
        : EventType.habitCompleted;
    var event = Event(type, DateTime.now(), habit.task.category);
    await achievementsState.addEvent(event);
    await emotionsState.loadAll();

    await FirebaseAnalytics.instance
        .logEvent(name: AnalyticsEventType.habit_action.name, parameters: {
      "habit_id": habit.id,
      "habit_name": habit.task.name,
      "habit_sphere": habit.task.category.id,
      "habit_impact": habit.task.difficulty.id,
      "habit_status": newStatus,
      "is_created": "false",
      "habit_previous_status": oldStatus,
      "is_simple": true.toString() // Assuming habits are always simple for now
    });
    notifyListeners();
  }

  void updateHabitTimestamps(Habit habit) {
    if (habit.task.status == Status.DOING && habit.task.inProgressTs == null) {
      habit.task.inProgressTs = DateTime.now();
    } else if (habit.task.status == Status.DONE && habit.task.doneTs == null) {
      habit.task.doneTs = DateTime.now();
    }
  }
}
