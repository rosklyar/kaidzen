import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/ProgressCalculator.dart';
import 'package:kaidzen_app/service/ProgressRepository.dart';
import 'package:kaidzen_app/settings/ReviewUtils.dart';

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

        if (getTotalLevel() % 10 == 0) {
          ReviewUtils.requestReview();
        }
      } else {
        await repository.updateProgress(task.category, updatedProgress);
        _progress[task.category] = updatedProgress;
      }
    }
    notifyListeners();
  }

  Future<void> notifyWithDelay() async {
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
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
