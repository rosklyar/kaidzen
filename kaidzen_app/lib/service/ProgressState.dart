import 'package:flutter/widgets.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:kaidzen_app/models/task.dart';
import "package:collection/collection.dart";
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

  updateProgress(
      Category category, double progressDelta, int levelDelta) async {
    Progress updatedProgress = Progress(
      _progress[category]!.value + progressDelta,
      _progress[category]!.level + levelDelta,
    );
    await repository.updateProgress(category, updatedProgress);
    _progress[category] = updatedProgress;
    notifyListeners();
  }
}
