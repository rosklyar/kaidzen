import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/achievements/AchievementsRepository.dart';

import 'package:kaidzen_app/achievements/EventsRepository.dart';
import 'package:kaidzen_app/achievements/achievement.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/achievements/set/default/AnyFiveTasksCompletedAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCompletedAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCreatedAchievement.dart';

class AchievementsState extends ChangeNotifier {
  AchievementsRepository achievementsRepository;
  EventsRepository eventsRepository;
  Map<int, Achievement>? achievements;
  List<AchievementSnapshot> _snaphots = [];

  AchievementsState(
      {required this.eventsRepository, required this.achievementsRepository}) {
    var taskCreatedAchievement =
        TaskCreatedAchievement(eventsRepository: eventsRepository);
    var taskCompletedAchievement =
        TaskCompletedAchievement(eventsRepository: eventsRepository);
    var anyFiveTasksCompletedAchievement =
        AnyFiveTasksCompletedAchievement(eventsRepository: eventsRepository);
    achievements = {
      taskCreatedAchievement.id: taskCreatedAchievement,
      taskCompletedAchievement.id: taskCompletedAchievement,
      anyFiveTasksCompletedAchievement.id: anyFiveTasksCompletedAchievement,
    };
  }

  loadAll() async {
    _snaphots = await achievementsRepository.getAchievementSnapshots().then(
        (snapshots) => Future.wait(snapshots
            .map((s) => AchievementSnapshot.updateProgress(
                s, achievements![s.id]!.progress))
            .toList()));
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
