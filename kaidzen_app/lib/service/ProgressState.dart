import 'package:flutter/widgets.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:kaidzen_app/models/task.dart';
import "package:collection/collection.dart";
import 'package:kaidzen_app/service/ProgressCalculator.dart';
import 'package:kaidzen_app/service/ProgressRepository.dart';
import 'package:kaidzen_app/service/TaskRepository.dart';

class ProgressState extends ChangeNotifier {
  final ProgressRepository repository;
  Map<Category, Progress> _progress;

  ProgressState({
    required this.repository,
  }) : _progress = {};

  Future loadAll() async {
    _progress = await repository.getProgress();
    notifyListeners();
  }

  updateProgress(Task task) async {
    var progress = _progress[Category.HEALTH]!.value;
    double progressDelta = ProgressCalculator.progressDelta(progress, task);
    var level = _progress[Category.HEALTH]!.level;
    int levelDelta = ProgressCalculator.levelDelta(level, task);
    Progress updatedProgress = Progress(
      progress + progressDelta,
      levelDelta + levelDelta,
    );
    await repository.updateProgress(Category.HEALTH, updatedProgress);
    _progress[Category.HEALTH] = updatedProgress;
    notifyListeners();
  }

  int getTotalLevel() {
    return _progress.entries
        .fold(0, (int acc, entry) => acc + entry.value.level);
  }

  int getLevel(Category category) {
    return _progress[category]?.level ?? 0;
  }

  double getValue(Category category) {
    return _progress[category]?.value ?? 0;
  }
}
