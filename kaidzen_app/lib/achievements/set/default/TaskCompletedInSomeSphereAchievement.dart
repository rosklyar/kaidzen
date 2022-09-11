import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/achievements/set/DetailsRowWidget.dart';
import 'package:kaidzen_app/achievements/style.dart';

import '../../../assets/constants.dart';
import '../../achievement.dart';

class TaskCompletedInSomeSphereAchievement extends Achievement {
  final int numberOfTasks;
  final int achievementId;
  TaskCompletedInSomeSphereAchievement(this.achievementId, this.numberOfTasks,
      {required super.eventsRepository});

  @override
  Future<double> get progress async {
    final eventsCounts = await Future.wait(activeCategories.map((e) =>
        eventsRepository.getEventsCountByCategory(
            EventType.taskCompleted, e.id)));
    final value = eventsCounts.reduce(max) / numberOfTasks;
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

    int maxValue = completedTasks.reduce(max);
    int maxIndex = completedTasks.indexOf(maxValue);

    return Column(
        children: activeCategories.map((e) {
      return Expanded(
          child: DetailsRowWidget(
              progress: completedTasks[e.id] / numberOfTasks,
              progressColor: e.id == maxIndex
                  ? achievementDetailsActiveProgressColor
                  : achievementDetailsNotActiveProgressColor,
              leadingText: e.name,
              centerText: completedTasks[e.id] > 0
                  ? "${numberOfTasks - completedTasks[e.id]} goals ahead"
                  : "No goals so far",
              trailingText: e.id == maxIndex ? "Top sphere" : null,
              trailingColor: e.id == maxIndex
                  ? const Color.fromRGBO(192, 216, 39, 1)
                  : null),
          flex: 1);
    }).toList());
  }
}
