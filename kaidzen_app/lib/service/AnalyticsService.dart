import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/service/ProgressState.dart';
import 'package:kaidzen_app/service/TasksState.dart';

class AnalyticsService {
  final FirebaseAnalytics firebaseAnalytics;
  final ProgressState progressState;
  final AchievementsState achievementsState;
  final TasksState tasksState;

  AnalyticsService(this.firebaseAnalytics, this.progressState,
      this.achievementsState, this.tasksState);

  Future<void> logEvent(AnalyticsEventType eventType,
      [Map<String, dynamic> additionalParameters = const {}]) async {
    Map<String, dynamic> basicParameters = {
      "healthLevel": progressState.getLevel(DevelopmentCategory.HEALTH),
      "healthTotalPoints": progressState.getPoints(DevelopmentCategory.HEALTH),
      "mindLevel": progressState.getLevel(DevelopmentCategory.MIND),
      "mindTotalPoints": progressState.getPoints(DevelopmentCategory.MIND),
      "wealthLevel": progressState.getLevel(DevelopmentCategory.WEALTH),
      "wealthTotalPoints": progressState.getPoints(DevelopmentCategory.WEALTH),
      "relationsLevel": progressState.getLevel(DevelopmentCategory.RELATIONS),
      "relationsTotalPoints":
          progressState.getPoints(DevelopmentCategory.RELATIONS),
      "energyLevel": progressState.getLevel(DevelopmentCategory.ENERGY),
      "energyTotalPoints": progressState.getPoints(DevelopmentCategory.ENERGY),
      "tasksCreated": tasksState.count(),
      "tasksInDo": tasksState.getByStatus(Status.TODO).length,
      "tasksInDoing": tasksState.getByStatus(Status.DOING).length,
      "achievementsCompleted": achievementsState.getCompletedAchievementsCount()
    };

    basicParameters.addAll(additionalParameters);

    await firebaseAnalytics.logEvent(
        name: eventType.name, parameters: basicParameters);
  }
}

enum AnalyticsEventType {
  CREATE_TASK_BUTTON_PRESSED;
}
