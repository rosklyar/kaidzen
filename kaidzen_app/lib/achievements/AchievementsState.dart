import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/achievements/AchievementsRepository.dart';

import 'package:kaidzen_app/achievements/EventsRepository.dart';
import 'package:kaidzen_app/achievements/achievement.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCompletedInSomeSphereAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCreatedAchievement.dart';

class AchievementsState extends ChangeNotifier {
  AchievementsRepository achievementsRepository;
  EventsRepository eventsRepository;
  Map<int, Achievement>? achievements;
  Map<int, AchievementSnapshot> _snaphots = {};

  AchievementsState(
      {required this.eventsRepository, required this.achievementsRepository}) {
    var fiveTasksCreatedAchievement =
        TaskCreatedAchievement(0, 5, eventsRepository: eventsRepository);
    var twentyFiveTasksCreatedAchievement =
        TaskCreatedAchievement(1, 25, eventsRepository: eventsRepository);
    var hundredTasksCreatedAchievement =
        TaskCreatedAchievement(2, 100, eventsRepository: eventsRepository);
    var fiveTasksCompletedInSomeSphereAchievement =
        TaskCompletedInSomeSphereAchievement(3, 5,
            eventsRepository: eventsRepository);
    var fiftyTasksCompletedInSomeSphereAchievement =
        TaskCompletedInSomeSphereAchievement(4, 50,
            eventsRepository: eventsRepository);
    var hundredAndFiftyTasksCompletedInSomeSphereAchievement =
        TaskCompletedInSomeSphereAchievement(5, 150,
            eventsRepository: eventsRepository);

    achievements = {
      fiveTasksCreatedAchievement.id: fiveTasksCreatedAchievement,
      twentyFiveTasksCreatedAchievement.id: twentyFiveTasksCreatedAchievement,
      hundredTasksCreatedAchievement.id: hundredTasksCreatedAchievement,
      fiveTasksCompletedInSomeSphereAchievement.id:
          fiveTasksCompletedInSomeSphereAchievement,
      fiftyTasksCompletedInSomeSphereAchievement.id:
          fiftyTasksCompletedInSomeSphereAchievement,
      hundredAndFiftyTasksCompletedInSomeSphereAchievement.id:
          hundredAndFiftyTasksCompletedInSomeSphereAchievement,
    };
  }

  loadAll() async {
    final snapshotsList = await achievementsRepository
        .getAchievementSnapshots()
        .then((snapshots) => Future.wait(snapshots
            .map((s) => AchievementSnapshot.updateProgress(
                s, achievements![s.id]!.progress))
            .toList()));
    _snaphots = Map.fromEntries(snapshotsList.map((s) => MapEntry(s.id, s)));
    notifyListeners();
  }

  List<AchievementSnapshot> getAchievements() {
    return _snaphots.values.toList();
  }

  int getCompletedAchievementsCount() {
    return _snaphots.values
        .where((s) => s.status == AchievementStatus.completed)
        .length;
  }

  addEvent(Event event) async {
    await eventsRepository.addEvent(event);
    loadAll();
  }

  void updateAchievementSnapshot(
      AchievementSnapshot achievementSnapshot) async {
    achievementsRepository.updateAchievementSnapshot(achievementSnapshot);
    _snaphots[achievementSnapshot.id] = achievementSnapshot;
    notifyListeners();
  }
}
