import 'package:flutter/cupertino.dart';

import 'package:kaidzen_app/achievements/EventsRepository.dart';
import 'package:kaidzen_app/achievements/achievement.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/achievements/set/default/AnyFiveTasksCompletedAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCompletedAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCreatedAchievement.dart';

class AchievementsState extends ChangeNotifier {
  EventsRepository repository;
  List<Achievement> achievements;
  List<AchievementSnapshot> _snaphots = [];

  AchievementsState({required this.repository})
      : achievements = [
          TaskCreatedAchievement(eventsRepository: repository),
          TaskCompletedAchievement(eventsRepository: repository),
          AnyFiveTasksCompletedAchievement(eventsRepository: repository)
        ];

  loadAll() async {
    _snaphots = await Future.wait(
        achievements.map((achievement) => achievement.getSnapshot()));
    notifyListeners();
  }

  List<AchievementSnapshot> getAchievements() {
    return _snaphots;
  }

  addEvent(Event event) async {
    await repository.addEvent(event);
    loadAll();
  }
}
