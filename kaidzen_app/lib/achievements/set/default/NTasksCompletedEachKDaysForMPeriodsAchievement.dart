import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/achievements/set/DetailsRowWidget.dart';
import 'package:kaidzen_app/achievements/style.dart';

import '../../../assets/constants.dart';
import '../../achievement.dart';

class NTasksCompletedEachKDaysForMPeriodsAchievement extends Achievement {
  final int achievementId;
  final int numberOfTasks;
  final int numberOfDays;
  final int numberOfPeriods;

  NTasksCompletedEachKDaysForMPeriodsAchievement(this.achievementId,
      this.numberOfTasks, this.numberOfDays, this.numberOfPeriods,
      {required super.eventsRepository});

  @override
  Future<double> get progress async {
    return 0.0;
  }

  @override
  int get id => achievementId;

  @override
  Future<Widget> get detailsWidget async {
    return Container();
  }
}
