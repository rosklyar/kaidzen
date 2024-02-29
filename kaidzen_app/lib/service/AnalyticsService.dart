import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/service/HabitState.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';

import '../assets/light_dark_theme.dart';

class AnalyticsService {
  static void initUserProperties(TasksState tasksState, HabitState habitState,
      EmotionsState emotionsState, TutorialState tutorialState) async {
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.HEALTH_LEVEL.name.toLowerCase(),
        value: tasksState.progressState
            .getLevel(DevelopmentCategoryDark.HEALTH)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.HEALTH_POINTS.name.toLowerCase(),
        value: tasksState.progressState
            .getPoints(DevelopmentCategoryDark.HEALTH)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.WEALTH_LEVEL.name.toLowerCase(),
        value: tasksState.progressState
            .getLevel(DevelopmentCategoryDark.WEALTH)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.WEALTH_POINTS.name.toLowerCase(),
        value: tasksState.progressState
            .getPoints(DevelopmentCategoryDark.WEALTH)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.MIND_LEVEL.name.toLowerCase(),
        value: tasksState.progressState
            .getLevel(DevelopmentCategoryDark.MIND)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.MIND_POINTS.name.toLowerCase(),
        value: tasksState.progressState
            .getPoints(DevelopmentCategoryDark.MIND)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.RELATIONS_LEVEL.name.toLowerCase(),
        value: tasksState.progressState
            .getLevel(DevelopmentCategoryDark.RELATIONS)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.RELATIONS_POINTS.name.toLowerCase(),
        value: tasksState.progressState
            .getPoints(DevelopmentCategoryDark.RELATIONS)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.ENERGY_LEVEL.name.toLowerCase(),
        value: tasksState.progressState
            .getLevel(DevelopmentCategoryDark.ENERGY)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.ENERGY_POINTS.name.toLowerCase(),
        value: tasksState.progressState
            .getPoints(DevelopmentCategoryDark.ENERGY)
            .toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.GOALS_CREATED.name.toLowerCase(),
        value: habitState.count().toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_GOALS_DO.name.toLowerCase(),
        value: habitState.getByStatus(Status.TODO).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_GOALS_DOING.name.toLowerCase(),
        value: habitState.getByStatus(Status.DOING).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_GOALS_DONE.name.toLowerCase(),
        value: habitState.getByStatus(Status.DONE).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.ACHIEVEMENTS_COMPLETED.name.toLowerCase(),
        value: tasksState.achievementsState
            .getCompletedAchievementsCount()
            .toString());

    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.HABITS_CREATED.name.toLowerCase(),
        value: tasksState.count().toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_HABITS_DO.name.toLowerCase(),
        value: tasksState.getByStatus(Status.TODO).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_HABITS_DOING.name.toLowerCase(),
        value: tasksState.getByStatus(Status.DOING).length.toString());
    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.CURRENT_HABITS_DONE.name.toLowerCase(),
        value: tasksState.getByStatus(Status.DONE).length.toString());

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
  mindful_moments_opened,
  announcement_closed,
  survey_opened,
  feature_discovered,
  origami_last_item,
  habit_action;
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
  TUTORIAL_STEPS_COMPLETED,
  HABITS_CREATED,
  CURRENT_HABITS_DO,
  CURRENT_HABITS_DOING,
  CURRENT_HABITS_DONE;
}

const Map<DevelopmentCategoryDark, AnalyticsUserProperties> levelPropertiesMap =
    {
  DevelopmentCategoryDark.ENERGY: AnalyticsUserProperties.ENERGY_LEVEL,
  DevelopmentCategoryDark.HEALTH: AnalyticsUserProperties.HEALTH_LEVEL,
  DevelopmentCategoryDark.MIND: AnalyticsUserProperties.MIND_LEVEL,
  DevelopmentCategoryDark.WEALTH: AnalyticsUserProperties.WEALTH_LEVEL,
  DevelopmentCategoryDark.RELATIONS: AnalyticsUserProperties.RELATIONS_LEVEL
};

const Map<DevelopmentCategoryDark, AnalyticsUserProperties>
    pointsPropertiesMap = {
  DevelopmentCategoryDark.ENERGY: AnalyticsUserProperties.ENERGY_POINTS,
  DevelopmentCategoryDark.HEALTH: AnalyticsUserProperties.HEALTH_POINTS,
  DevelopmentCategoryDark.MIND: AnalyticsUserProperties.MIND_POINTS,
  DevelopmentCategoryDark.WEALTH: AnalyticsUserProperties.WEALTH_POINTS,
  DevelopmentCategoryDark.RELATIONS: AnalyticsUserProperties.RELATIONS_POINTS
};
