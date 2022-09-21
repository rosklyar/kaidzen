import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/ProgressCalculator.dart';
import 'package:kaidzen_app/service/ProgressRepository.dart';

import 'AnalyticsService.dart';

class ProgressState extends ChangeNotifier {
  final ProgressRepository repository;
  Map<DevelopmentCategory, Progress> _progress;

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
    if (updatedProgress != currentProgress) {
      await repository.updateProgress(task.category, updatedProgress);
      _progress[task.category] = updatedProgress;
      await FirebaseAnalytics.instance.setUserProperty(
          name: levelPropertiesMap[task.category]!.name.toLowerCase(),
          value: updatedProgress.level.toString());
      await FirebaseAnalytics.instance.setUserProperty(
          name: pointsPropertiesMap[task.category]!.name.toLowerCase(),
          value: updatedProgress.points.toString());
      notifyListeners();
    }
  }

  int getTotalLevel() {
    return _progress.entries
        .fold(0, (int acc, entry) => acc + entry.value.level);
  }

  int getLevel(DevelopmentCategory category) {
    return _progress[category]?.level ?? 0;
  }

  int getPoints(DevelopmentCategory category) {
    return _progress[category]?.points ?? 0;
  }

  double getLevelProgressFraction(DevelopmentCategory category) {
    return _progress[category] != null
        ? ProgressCalculator.getLevelFraction(category, _progress[category]!)
        : 0.0;
  }
}
