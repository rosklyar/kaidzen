import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/achievements/set/DetailsRowWidget.dart';
import 'package:kaidzen_app/achievements/style.dart';

import '../../achievement.dart';

class TaskCreatedAchievement extends Achievement {
  final int numberOfTasks;
  final int achievementId;

  TaskCreatedAchievement(this.achievementId, this.numberOfTasks,
      {required super.eventsRepository,
      required super.completedDetails,
      super.completedDetailsType = CompletedDetailsType.COMING_SOON});

  @override
  Future<double> get progress async {
    var value =
        await eventsRepository.getEventsNumberByType(EventType.taskCreated) /
            numberOfTasks;
    return value.clamp(0.0, 1.0);
  }

  @override
  int get id => achievementId;

  @override
  Future<Widget> get detailsWidget async {
    var createdTasks =
        await eventsRepository.getEventsNumberByType(EventType.taskCreated);
    return DetailsRowWidget(
        progress: (createdTasks / numberOfTasks).clamp(0.0, 1.0),
        progressColor: AchievementsStyle.achievementDetailsActiveProgressColor,
        leadingText: "All spheres",
        centerText: "${numberOfTasks - createdTasks} goals ahead");
  }
}
