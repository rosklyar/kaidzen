import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/achievements/AchievementsRepository.dart';

import 'package:kaidzen_app/achievements/EventsRepository.dart';
import 'package:kaidzen_app/achievements/achievement.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/achievementStatus.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/achievements/set/default/AnyFiveTasksCompletedAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCompletedAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCreatedAchievement.dart';

class AchievementsState extends ChangeNotifier {
  AchievementsRepository achievementsRepository;
  EventsRepository eventsRepository;
  List<Achievement> achievements;
  List<AchievementSnapshot> _snaphots = [];

  AchievementsState(
      {required this.eventsRepository, required this.achievementsRepository})
      : achievements = [
          TaskCreatedAchievement(eventsRepository: eventsRepository),
          TaskCompletedAchievement(eventsRepository: eventsRepository),
          AnyFiveTasksCompletedAchievement(eventsRepository: eventsRepository)
        ];

  loadAll() async {
    final states = await achievementsRepository.getAchievementStates();
    _snaphots = await Future.wait(achievements.map((achievement) => achievement
        .getSnapshot(states.firstWhere((state) => state.id == achievement.id,
            orElse: () =>
                AchievementState(-1, AchievementStatus.notCompleted)))));
    for (var snapshot in _snaphots) {
      if (snapshot.status == AchievementStatus.notCompleted &&
          snapshot.progress >= 1.0) {
        achievementsRepository.updateAchievementState(
            AchievementState(snapshot.id, AchievementStatus.completed));
        snapshot.setStatus(AchievementStatus.completed);
      }
    }
    notifyListeners();
  }

  List<AchievementSnapshot> getAchievements() {
    return _snaphots;
  }

  addEvent(Event event) async {
    await eventsRepository.addEvent(event);
    loadAll();
  }
}
