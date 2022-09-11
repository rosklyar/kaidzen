import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/achievements/AchievementsRepository.dart';

import 'package:kaidzen_app/achievements/EventsRepository.dart';
import 'package:kaidzen_app/achievements/achievement.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCompletedInSomeSphereAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCreatedAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TasksCompletedInAllSpheresAchievement.dart';

class AchievementsState extends ChangeNotifier {
  AchievementsRepository achievementsRepository;
  EventsRepository eventsRepository;
  Map<int, Achievement>? achievements;
  Map<int, AchievementSnapshot> _snaphots = {};
  Map<int, Widget> detailsWidgets = {};

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
    var fiveTasksCompletedInEachSphere = TaskCompletedInAllSpheresAchievement(
        6, 5,
        eventsRepository: eventsRepository);
    var tenTasksCompletedInEachSphere = TaskCompletedInAllSpheresAchievement(
        7, 10,
        eventsRepository: eventsRepository);
    var thirtyTasksCompletedInEachSphere = TaskCompletedInAllSpheresAchievement(
        8, 30,
        eventsRepository: eventsRepository);
    var fiftyTasksCompletedInEachSphere = TaskCompletedInAllSpheresAchievement(
        9, 50,
        eventsRepository: eventsRepository);
    var hundredTasksCompletedInEachSphere =
        TaskCompletedInAllSpheresAchievement(10, 100,
            eventsRepository: eventsRepository);
    var secretAchievement =
        TaskCreatedAchievement(11, 10, eventsRepository: eventsRepository);

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
      fiveTasksCompletedInEachSphere.id: fiveTasksCompletedInEachSphere,
      tenTasksCompletedInEachSphere.id: tenTasksCompletedInEachSphere,
      thirtyTasksCompletedInEachSphere.id: thirtyTasksCompletedInEachSphere,
      fiftyTasksCompletedInEachSphere.id: fiftyTasksCompletedInEachSphere,
      hundredTasksCompletedInEachSphere.id: hundredTasksCompletedInEachSphere,
      secretAchievement.id: secretAchievement
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

    final widgetsFutures = achievements!.entries
        .map((e) => MapEntry(e.key, e.value.detailsWidget))
        .toList();
    for (var i = 0; i < widgetsFutures.length; i++) {
      final widget = await widgetsFutures[i].value;
      detailsWidgets[widgetsFutures[i].key] = widget;
    }

    notifyListeners();
  }

  List<AchievementSnapshot> getAchievements() {
    return _snaphots.values.toList();
  }

  AchievementSnapshot getCompletedAchievement() {
    return _snaphots.values
        .firstWhere((s) => s.status == AchievementStatus.completed);
  }

  int getCompletedAchievementsCount() {
    return _snaphots.values
        .where((s) => s.status == AchievementStatus.completed)
        .length;
  }

  Widget getDetailsWidget(int id) {
    return detailsWidgets[id]!;
  }

  addEvent(Event event) async {
    await eventsRepository.addEvent(event).then((value) => loadAll());
  }

  void updateAchievementSnapshot(
      AchievementSnapshot achievementSnapshot) async {
    achievementsRepository.updateAchievementSnapshot(achievementSnapshot);
    _snaphots[achievementSnapshot.id] = achievementSnapshot;
    notifyListeners();
  }
}
