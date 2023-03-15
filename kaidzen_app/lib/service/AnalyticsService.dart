import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';

class AnalyticsService {
  static void initUserProperties(TasksState tasksState,
      EmotionsState emotionsState, TutorialState tutorialState) async {
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

    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.EMOTION_POINTS.name.toLowerCase(),
        value: emotionsState.emotionPoints.points.toString());

    await FirebaseAnalytics.instance.setUserProperty(
        name:
            AnalyticsUserProperties.TUTORIAL_STEPS_COMPLETED.name.toLowerCase(),
        value: tutorialState
            .getTutorialProgress()
            .completedStepsCount()
            .toString());
  }
}

enum AnalyticsEventType {
  create_goal_button_pressed,
  create_goal_screen_back_button,
  edit_goal_screen_back_button,
  create_goal_screen_create_button,
  edit_goal_screen_save_button,
  achievements_screen_opened,
  settings_screen_opened,
  about_philosophy_opened,
  spheres_explanation_opened,
  send_feedback_opened,
  share_app_opened,
  terms_of_use_opened,
  privacy_policy_opened,
  goal_action,
  achievement_status_checked,
  achievement_received,
  achievement_collected,
  level_up,
  emotion_changed,
  tutorial_step_completed,
  collapse_button_pressed,
  goals_reordered,
  mindful_moments_opened;
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
  ACHIEVEMENTS_COMPLETED,
  EMOTION_POINTS,
  TUTORIAL_STEPS_COMPLETED;
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
