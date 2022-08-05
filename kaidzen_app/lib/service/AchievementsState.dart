import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/views/achievements.dart';

import 'package:kaidzen_app/service/AchievementsRepository.dart';
import 'package:kaidzen_app/models/achievement.dart';

class AchievementsState extends ChangeNotifier {
  final AchievementsRepository repository;
  Map<int, List<Achievement>> _achievements = {};
  AchievementsState({
    required this.repository,
  });

  List<Achievement> getAchievements([int setId = 0]) {
    return _achievements[setId] ?? [];
  }

  Future loadAll() async {
    List<Achievement> achievements = await repository.getAchievements();
    _achievements = {0: achievements};
    notifyListeners();
  }
}
