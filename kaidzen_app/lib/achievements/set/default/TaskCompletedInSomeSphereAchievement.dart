import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kaidzen_app/achievements/event.dart';

import '../../../assets/constants.dart';
import '../../achievement.dart';
import '../../style.dart';

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
    final mindCompleted = await eventsRepository.getEventsCountByCategory(
        EventType.taskCompleted, DevelopmentCategory.MIND.id);
    final healthCompleted = await eventsRepository.getEventsCountByCategory(
        EventType.taskCompleted, DevelopmentCategory.HEALTH.id);
    final relationsCompleted = await eventsRepository.getEventsCountByCategory(
        EventType.taskCompleted, DevelopmentCategory.RELATIONS.id);
    final energyCompleted = await eventsRepository.getEventsCountByCategory(
        EventType.taskCompleted, DevelopmentCategory.ENERGY.id);
    final wealthCompleted = await eventsRepository.getEventsCountByCategory(
        EventType.taskCompleted, DevelopmentCategory.WEALTH.id);
    return Center(
        child: Column(children: [
      Text(
          "$mindCompleted / $numberOfTasks for ${DevelopmentCategory.MIND.name}",
          style: achievementsDetailsTextStyle),
      Text(
          "$healthCompleted / $numberOfTasks for ${DevelopmentCategory.HEALTH.name}",
          style: achievementsDetailsTextStyle),
      Text(
          "$relationsCompleted / $numberOfTasks for ${DevelopmentCategory.RELATIONS.name}",
          style: achievementsDetailsTextStyle),
      Text(
          "$energyCompleted / $numberOfTasks for ${DevelopmentCategory.ENERGY.name}",
          style: achievementsDetailsTextStyle),
      Text(
          "$wealthCompleted / $numberOfTasks for ${DevelopmentCategory.WEALTH.name}",
          style: achievementsDetailsTextStyle)
    ]));
  }
}
