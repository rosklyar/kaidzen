import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/service/TasksState.dart';

class AnalyticsService {
  static void initUserProperties(TasksState tasksState) async {
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.HEALTH_LEVEL.name.toLowerCase(),
        value: tasksState.progressState
            .getLevel(DevelopmentCategory.HEALTH)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.HEALTH_POINTS.name.toLowerCase(),
        value: tasksState.progressState
            .getPoints(DevelopmentCategory.HEALTH)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.WEALTH_LEVEL.name.toLowerCase(),
        value: tasksState.progressState
            .getLevel(DevelopmentCategory.WEALTH)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.WEALTH_POINTS.name.toLowerCase(),
        value: tasksState.progressState
            .getPoints(DevelopmentCategory.WEALTH)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.MIND_LEVEL.name.toLowerCase(),
        value: tasksState.progressState
            .getLevel(DevelopmentCategory.MIND)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.MIND_POINTS.name.toLowerCase(),
        value: tasksState.progressState
            .getPoints(DevelopmentCategory.MIND)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.RELATIONS_LEVEL.name.toLowerCase(),
        value: tasksState.progressState
            .getLevel(DevelopmentCategory.RELATIONS)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.RELATIONS_POINTS.name.toLowerCase(),
        value: tasksState.progressState
            .getPoints(DevelopmentCategory.RELATIONS)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.ENERGY_LEVEL.name.toLowerCase(),
        value: tasksState.progressState
            .getLevel(DevelopmentCategory.ENERGY)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.ENERGY_POINTS.name.toLowerCase(),
        value: tasksState.progressState
            .getPoints(DevelopmentCategory.ENERGY)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.GOALS_CREATED.name.toLowerCase(),
        value: tasksState.count().toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_GOALS_DO.name.toLowerCase(),
        value: tasksState.getByStatus(Status.TODO).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_GOALS_DOING.name.toLowerCase(),
        value: tasksState.getByStatus(Status.DOING).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_GOALS_DONE.name.toLowerCase(),
        value: tasksState.getByStatus(Status.DONE).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.ACHIEVEMENTS_COMPLETED.name.toLowerCase(),
        value: tasksState.achievementsState
            .getCompletedAchievementsCount()
            .toString());
  }
}

enum AnalyticsEventType {
  CREATE_GOAL_BUTTON_PRESSED,
  CREATE_GOAL_SCREEN_BACK_BUTTON,
  CREATE_GOAL_SCREEN_CREATE_BUTTON,
  ACHIEVEMENTS_SCREEN_OPENED,
  SETTINGS_SCREEN_OPENED,
  GOAL_ACTION,
  LEVEL_UP;
}

enum AnalyticsUserProperties {
  HEALTH_LEVEL,
  HEALTH_POINTS,
  MIND_LEVEL,
  MIND_POINTS,
  WEALTH_LEVEL,
  WEALTH_POINTS,
  RELATIONS_LEVEL,
  RELATIONS_POINTS,
  ENERGY_LEVEL,
  ENERGY_POINTS,
  GOALS_CREATED,
  CURRENT_GOALS_DO,
  CURRENT_GOALS_DOING,
  CURRENT_GOALS_DONE,
  ACHIEVEMENTS_COMPLETED
}

const Map<DevelopmentCategory, AnalyticsUserProperties> levelPropertiesMap = {
  DevelopmentCategory.ENERGY: AnalyticsUserProperties.ENERGY_LEVEL,
  DevelopmentCategory.HEALTH: AnalyticsUserProperties.HEALTH_LEVEL,
  DevelopmentCategory.MIND: AnalyticsUserProperties.MIND_LEVEL,
  DevelopmentCategory.WEALTH: AnalyticsUserProperties.WEALTH_LEVEL,
  DevelopmentCategory.RELATIONS: AnalyticsUserProperties.RELATIONS_LEVEL
};

const Map<DevelopmentCategory, AnalyticsUserProperties> pointsPropertiesMap = {
  DevelopmentCategory.ENERGY: AnalyticsUserProperties.ENERGY_POINTS,
  DevelopmentCategory.HEALTH: AnalyticsUserProperties.HEALTH_POINTS,
  DevelopmentCategory.MIND: AnalyticsUserProperties.MIND_POINTS,
  DevelopmentCategory.WEALTH: AnalyticsUserProperties.WEALTH_POINTS,
  DevelopmentCategory.RELATIONS: AnalyticsUserProperties.RELATIONS_POINTS
};
