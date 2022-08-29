import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../../achievement.dart';
import '../../style.dart';

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
    final value = eventsCounts.reduce(min) / numberOfTasks;
    return value.clamp(0.0, 1.0);
  }

  @override
  int get id => achievementId;

  @override
  Future<Widget> get detailsWidget async {
    return Center(
        child: Column(children: [
      getDetailsRow(
          await eventsRepository.getEventsCountByCategory(
              EventType.taskCompleted, DevelopmentCategory.MIND.id),
          numberOfTasks,
          DevelopmentCategory.MIND),
      getDetailsRow(
          await eventsRepository.getEventsCountByCategory(
              EventType.taskCompleted, DevelopmentCategory.HEALTH.id),
          numberOfTasks,
          DevelopmentCategory.HEALTH),
      getDetailsRow(
          await eventsRepository.getEventsCountByCategory(
              EventType.taskCompleted, DevelopmentCategory.RELATIONS.id),
          numberOfTasks,
          DevelopmentCategory.RELATIONS),
      getDetailsRow(
          await eventsRepository.getEventsCountByCategory(
              EventType.taskCompleted, DevelopmentCategory.ENERGY.id),
          numberOfTasks,
          DevelopmentCategory.ENERGY),
      getDetailsRow(
          await eventsRepository.getEventsCountByCategory(
              EventType.taskCompleted, DevelopmentCategory.WEALTH.id),
          numberOfTasks,
          DevelopmentCategory.WEALTH)
    ]));
  }

  Text getDetailsRow(int completed, int needed, DevelopmentCategory category) {
    return Text("$completed / $needed for ${category.name}",
        style: completed >= needed
            ? achievementsDetailsAchievedTextStyle
            : achievementsDetailsTextStyle);
  }
}
