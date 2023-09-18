import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../../achievement.dart';
import '../../style.dart';
import '../DetailsRowWidget.dart';

class TaskCompletedInAllSpheresAchievement extends Achievement {
  final int numberOfTasks;
  final int achievementId;
  TaskCompletedInAllSpheresAchievement(this.achievementId, this.numberOfTasks,
      {required super.eventsRepository});

  @override
  Future<double> get progress async {
    final eventsCounts = await Future.wait(activeCategories.map((e) =>
        eventsRepository.getEventsCountByCategory(
            EventType.taskCompleted, e.id)));
    final value = eventsCounts
            .map((e) => e.clamp(0, numberOfTasks))
            .reduce((a, b) => a + b) /
        (numberOfTasks * activeCategories.length);
    return value.clamp(0.0, 1.0);
  }

  @override
  int get id => achievementId;

  @override
  Future<Widget> get detailsWidget async {
    final completedTasks = await Future.wait(activeCategories.map((e) async {
      return eventsRepository.getEventsCountByCategory(
          EventType.taskCompleted, e.id);
    }).toList());

    return Column(
        children: activeCategories.map((e) {
      return Expanded(
          child: DetailsRowWidget(
              progress: completedTasks[e.id] / numberOfTasks,
              progressColor:
                  AchievementsStyle.achievementDetailsActiveProgressColor,
              leadingText: e.name,
              centerText: completedTasks[e.id] > 0
                  ? completedTasks[e.id] >= numberOfTasks
                      ? "Completed"
                      : "${numberOfTasks - completedTasks[e.id]} goals ahead"
                  : "No goals so far"),
          flex: 1);
    }).toList());
  }
}
