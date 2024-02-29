import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/ProgressCalculator.dart';
import 'package:kaidzen_app/service/ProgressRepository.dart';

import '../assets/light_dark_theme.dart';
import '../models/habit.dart';
import 'AnalyticsService.dart';

class ProgressState extends ChangeNotifier {
  final ProgressRepository repository;
  Map<DevelopmentCategoryDark, Progress> _progress;

  ProgressState({
    required this.repository,
  }) : _progress = {};

  Future loadAll() async {
    _progress = await repository.getProgress();
    notifyListeners();
  }

  updateProgress(Task task) async {
    var currentProgress = _progress[task.category]!;
    var updatedProgress = ProgressCalculator.progress(currentProgress, task);
    // print(updatedProgress);

    //point shere updated - current

    await handleProgressChanged(updatedProgress, currentProgress, task);
    notifyListeners();
  }

  updateHabitProgress(Habit habit) async {
    var currentProgress = _progress[habit.task.category]!;
    var updatedProgress =
        ProgressCalculator.habitProgress(currentProgress, habit);
    await handleProgressChanged(updatedProgress, currentProgress, habit.task);
    notifyListeners();
  }

  Future<void> handleProgressChanged(
      Progress updatedProgress, Progress currentProgress, Task task) async {
    if (updatedProgress != currentProgress) {
      await FirebaseAnalytics.instance.setUserProperty(
          name: levelPropertiesMap[task.category]!.name.toLowerCase(),
          value: updatedProgress.level.toString());
      await FirebaseAnalytics.instance.setUserProperty(
          name: pointsPropertiesMap[task.category]!.name.toLowerCase(),
          value: updatedProgress.points.toString());

      if (updatedProgress.level > currentProgress.level) {
        //We do this 3 step update to be able to correctly display progress animation
        var progressToMax = Progress(currentProgress.level,
            ProgressCalculator.getMaxLevelPoints(currentProgress.level + 1));
        await repository.updateProgress(task.category, progressToMax);
        _progress[task.category] = progressToMax;
        await notifyWithDelay();

        var progressToZero = Progress(updatedProgress.level, 0);
        await repository.updateProgress(task.category, progressToZero);
        _progress[task.category] = progressToZero;
        await notifyWithDelay();

        await repository.updateProgress(task.category, updatedProgress);
        _progress[task.category] = updatedProgress;

        await FirebaseAnalytics.instance.logEvent(
            name: AnalyticsEventType.level_up.name,
            parameters: {
              "sphere": task.category.id,
              "level": updatedProgress.level
            });
      } else {
        await repository.updateProgress(task.category, updatedProgress);
        _progress[task.category] = updatedProgress;
      }
    }
  }

  Future<void> notifyWithDelay() async {
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
  }

  int getTotalLevel() {
    return _progress.entries
        .fold(0, (int acc, entry) => acc + entry.value.level);
  }

  int getLevel(DevelopmentCategoryDark category) {
    return _progress[category]?.level ?? 0;
  }

  int getPoints(DevelopmentCategoryDark category) {
    return _progress[category]?.points ?? 0;
  }

  double getLevelProgressFraction(DevelopmentCategoryDark category) {
    return _progress[category] != null
        ? ProgressCalculator.getLevelFraction(category, _progress[category]!)
        : 0.0;
  }
}
