import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/achievements/set/DetailsRowWidget.dart';

import '../../achievement.dart';
import '../../style.dart';

class NTasksCompletedEachKDaysForMPeriodsAchievement extends Achievement {
  final int achievementId;
  final int numberOfTasks;
  final int numberOfDays;
  final int numberOfPeriods;
  final double periodDelta;

  NTasksCompletedEachKDaysForMPeriodsAchievement(this.achievementId,
      this.numberOfTasks, this.numberOfDays, this.numberOfPeriods,
      {required super.eventsRepository})
      : periodDelta = 1.0 / numberOfPeriods;

  @override
  Future<double> get progress async {
    DateTime now = DateTime.now();
    PeriodAchievementInfo info =
        await eventsRepository.getPeriodAchievementInfo(achievementId);
    if (info.startEventId == -1) {
      return 0.0;
    } else {
      Event startEvent = await eventsRepository.getEventById(info.startEventId);
      DateTime from = startEvent.timestamp;
      double progress = 0.0;
      for (int i = 0; i < numberOfPeriods; i++) {
        DateTime to = _getToDatetime(from, now);
        int completedTasks =
            await eventsRepository.getNumberOfTasksCompletedInPeriod(from, to);
        if (completedTasks >= numberOfTasks) {
          progress += periodDelta;
        } else {
          var periodExpired = to.difference(from).inDays == numberOfDays;
          if (periodExpired) {
            eventsRepository.breakPeriodAchievement(info);
            progress = 0.0;
          }
          break;
        }
        from = to;
      }
      return progress;
    }
  }

  @override
  int get id => achievementId;

  @override
  Future<Widget> get detailsWidget async {
    PeriodAchievementInfo info =
        await eventsRepository.getPeriodAchievementInfo(achievementId);
    if (info.startEventId == -1) {
      return Column(
          children: List.generate(
              numberOfPeriods,
              (index) => Expanded(
                  child: notCompletedDetailsRowWidget(getLeadingText(index)),
                  flex: 1)));
    }
    List<Widget> detailsRows = [];
    Event startEvent = await eventsRepository.getEventById(info.startEventId);
    DateTime from = startEvent.timestamp;
    DateTime now = DateTime.now();
    for (int i = 0; i < numberOfPeriods; i++) {
      if (from.isAtSameMomentAs(now)) {
        detailsRows.add(notCompletedDetailsRowWidget(getLeadingText(i)));
      } else {
        DateTime to = _getToDatetime(from, now);
        int completedTasks =
            await eventsRepository.getNumberOfTasksCompletedInPeriod(from, to);
        if (completedTasks >= numberOfTasks) {
          detailsRows.add(DetailsRowWidget(
              progress: 1.0,
              progressColor:
                  AchievementsStyle.achievementDetailsActiveProgressColor,
              leadingText: getLeadingText(i),
              centerText: "Completed"));
        } else {
          DateTime periodEnd = from.add(Duration(days: numberOfDays));
          int daysLeft = periodEnd.difference(now).inDays;
          int hoursLeft = periodEnd.difference(now).inHours;
          detailsRows.add(
            DetailsRowWidget(
                progress: (completedTasks / numberOfTasks).clamp(0.0, 1.0),
                progressColor:
                    AchievementsStyle.achievementDetailsActiveProgressColor,
                leadingText: getLeadingText(i),
                centerText: "${numberOfTasks - completedTasks} goals ahead",
                trailingText:
                    getTrailingText(daysLeft, hoursLeft, periodEnd, now),
                trailingColor: daysLeft > 0
                    ? const Color.fromRGBO(192, 216, 39, 1)
                    : const Color.fromRGBO(234, 125, 98, 1)),
          );
        }
        from = to;
      }
    }
    return Column(
        children: detailsRows.map((e) => Expanded(child: e, flex: 1)).toList());
  }

  String getLeadingText(int i) => numberOfDays == 7
      ? "Week ${i + 1}"
      : "Days ${(i * numberOfDays) + 1} - ${(i + 1) * numberOfDays}";

  String getTrailingText(
      int daysLeft, int hoursLeft, DateTime periodEnd, DateTime now) {
    return daysLeft > 0
        ? "$daysLeft days left"
        : hoursLeft > 0
            ? "$hoursLeft hours left"
            : "${periodEnd.difference(now).inMinutes} mins left";
  }

  DateTime _getToDatetime(DateTime from, DateTime now) {
    DateTime to = from.add(Duration(days: numberOfDays));
    return to.isAfter(now) ? now : to;
  }

  DetailsRowWidget notCompletedDetailsRowWidget(String leadingText) {
    return DetailsRowWidget(
        progress: 0.0,
        progressColor: AchievementsStyle.achievementDetailsActiveProgressColor,
        leadingText: leadingText,
        centerText: "Not started");
  }
}
