import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:kaidzen_app/achievements/AchievementsRepository.dart';

import 'package:kaidzen_app/achievements/EventsRepository.dart';
import 'package:kaidzen_app/achievements/achievement.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/achievements/set/default/CompletedDetailsSwiper.dart';
import 'package:kaidzen_app/achievements/set/default/NTasksCompletedEachKDaysForMPeriodsAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCompletedInSomeSphereAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TaskCreatedAchievement.dart';
import 'package:kaidzen_app/achievements/set/default/TasksCompletedInAllSpheresAchievement.dart';
import 'package:kaidzen_app/service/AnalyticsService.dart';

import 'style.dart';

class AchievementsState extends ChangeNotifier {
  AchievementsRepository achievementsRepository;
  EventsRepository eventsRepository;
  Map<int, Achievement>? achievements;
  Map<int, AchievementSnapshot> _snaphots = {};
  Map<int, Widget> detailsWidgets = {};

  AchievementsState(
      {required this.eventsRepository, required this.achievementsRepository}) {
    var twentyFiveTasksCreatedAchievement = TaskCreatedAchievement(0, 5,
        eventsRepository: eventsRepository,
        completedDetails: const CompletedDetailsSwiper(
            itemCount: 19,
            subfolder: "0/details/fish",
            filePrefix: "Fish",
            color: Color.fromRGBO(195, 184, 239, 1)),
        completedDetailsType: CompletedDetailsType.ORIGAMI_INSTRUCTION);

    var fiftyTasksCreatedAchievement = TaskCreatedAchievement(1, 6,
        eventsRepository: eventsRepository,
        completedDetails: const CompletedDetailsSwiper(
            itemCount: 11,
            subfolder: "0/details/duck",
            filePrefix: "Duck",
            color: Color.fromRGBO(195, 184, 239, 1)),
        completedDetailsType: CompletedDetailsType.ORIGAMI_INSTRUCTION);
    var hundredTasksCreatedAchievement = TaskCreatedAchievement(2, 7,
        eventsRepository: eventsRepository,
        completedDetails: const CompletedDetailsSwiper(
            itemCount: 20,
            subfolder: "0/details/seahorse",
            filePrefix: "Seahorse",
            color: Color.fromRGBO(195, 184, 239, 1)),
        completedDetailsType: CompletedDetailsType.ORIGAMI_INSTRUCTION);
    var fiveTasksCompletedInSomeSphereAchievement =
        TaskCompletedInSomeSphereAchievement(3, 5,
            eventsRepository: eventsRepository,
            completedDetails: comingSoonWidget());
    var fiftyTasksCompletedInSomeSphereAchievement =
        TaskCompletedInSomeSphereAchievement(4, 50,
            eventsRepository: eventsRepository,
            completedDetails: comingSoonWidget());
    var hundredAndFiftyTasksCompletedInSomeSphereAchievement =
        TaskCompletedInSomeSphereAchievement(5, 150,
            eventsRepository: eventsRepository,
            completedDetails: comingSoonWidget());
    var fiveTasksCompletedInEachSphere = TaskCompletedInAllSpheresAchievement(
        6, 5,
        eventsRepository: eventsRepository,
        completedDetails: comingSoonWidget());
    var tenTasksCompletedInEachSphere = TaskCompletedInAllSpheresAchievement(
        7, 15,
        eventsRepository: eventsRepository,
        completedDetails: comingSoonWidget());
    var thirtyTasksCompletedInEachSphere = TaskCompletedInAllSpheresAchievement(
        8, 40,
        eventsRepository: eventsRepository,
        completedDetails: comingSoonWidget());
    var twoWeeks5tasksCompletedAchievement =
        NTasksCompletedEachKDaysForMPeriodsAchievement(9, 5, 7, 2,
            eventsRepository: eventsRepository,
            completedDetails: comingSoonWidget());
    var threeWeeks10tasksCompletedAchievement =
        NTasksCompletedEachKDaysForMPeriodsAchievement(10, 10, 7, 3,
            eventsRepository: eventsRepository,
            completedDetails: comingSoonWidget());
    var fourWeeks20tasksCompletedAchievement =
        NTasksCompletedEachKDaysForMPeriodsAchievement(11, 20, 7, 4,
            eventsRepository: eventsRepository,
            completedDetails: comingSoonWidget());

    achievements = {
      twentyFiveTasksCreatedAchievement.id: twentyFiveTasksCreatedAchievement,
      fiftyTasksCreatedAchievement.id: fiftyTasksCreatedAchievement,
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
      twoWeeks5tasksCompletedAchievement.id: twoWeeks5tasksCompletedAchievement,
      threeWeeks10tasksCompletedAchievement.id:
          threeWeeks10tasksCompletedAchievement,
      fourWeeks20tasksCompletedAchievement.id:
          fourWeeks20tasksCompletedAchievement
    };
  }

  Widget comingSoonWidget() {
    return Align(
        child: Text("Coming soon...",
            style: AchievementsStyle.achievementsDescriptionTextStyle),
        alignment: Alignment.center);
  }

  loadAll() async {
    final achievementsState =
        await achievementsRepository.getAchievementSnapshots();

    final updatedAchievementsState =
        await Future.wait(achievementsState.map((s) {
      if (s.status == AchievementStatus.notCompleted) {
        return AchievementSnapshot.updateProgress(
            s, achievements![s.id]!.progress);
      } else {
        return Future.value(s);
      }
    }));

    // update newly completed achievements in db
    final notCompletedAchievementsIds = achievementsState
        .where((element) => element.status == AchievementStatus.notCompleted)
        .map((e) => e.id)
        .toSet();
    updatedAchievementsState
        .where((ach) =>
            ach.status == AchievementStatus.completed &&
            notCompletedAchievementsIds.contains(ach.id))
        .forEach((element) async {
      achievementsRepository.updateAchievementSnapshot(element);
      await FirebaseAnalytics.instance.logEvent(
          name: AnalyticsEventType.achievement_received.name,
          parameters: {"id": element.id});
    });

    _snaphots =
        Map.fromEntries(updatedAchievementsState.map((s) => MapEntry(s.id, s)));

    final widgetsFutures = achievements!.entries
        .map((e) => MapEntry(e.key, e.value.detailsWidget))
        .toList();
    for (var i = 0; i < widgetsFutures.length; i++) {
      final widget = await widgetsFutures[i].value;
      detailsWidgets[widgetsFutures[i].key] = widget;
    }

    await FirebaseAnalytics.instance.setUserProperty(
        name: AnalyticsUserProperties.ACHIEVEMENTS_COMPLETED.name.toLowerCase(),
        value: getCompletedAchievementsCount().toString());

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

  bool notShownWithOrigamiCompleted() {
    // ignore: iterable_contains_unrelated_type
    return _snaphots.values.contains((s) =>
        s.status == AchievementStatus.completedAndShown &&
        achievements![s.id]!.completedDetailsType ==
            CompletedDetailsType.ORIGAMI_INSTRUCTION);
  }

  Widget getDetailsWidget(int id) {
    return detailsWidgets[id]!;
  }

  Widget getCompletedDetailsWidget(int id) {
    return achievements![id]!.completedDetails;
  }

  CompletedDetailsType getCompletedDetailsType(int id) {
    return achievements![id]!.completedDetailsType;
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
