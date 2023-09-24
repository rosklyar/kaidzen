import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';

import '../service/AnalyticsService.dart';
import 'achievementDetailsScreen.dart';

class EggWidget extends StatelessWidget {
  static int step = 5;
  static List<int> percents = [for (var i = 0; i <= 100; i = i + step) i];
  final AchievementSnapshot achievement;
  final AchievementsState achievementsState;
  const EggWidget(
      {Key? key, required this.achievement, required this.achievementsState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (achievement.status == AchievementStatus.completedAndShown) {
      return Stack(children: [
        SvgPicture.asset(
            width: double.infinity,
            height: double.infinity,
            "assets/achievements/${getSubFolder(achievement.isSecret)}/completed_egg.svg"),
        getProgress(achievement.progress, achievement.isSecret),
        InkWell(
            child: SvgPicture.asset(
                width: double.infinity,
                height: double.infinity,
                "assets/achievements/sets/${achievement.setId}/${achievement.iconName}"),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AchievementDetailsScreen(
                            achievementSnapshot: achievement,
                            details: achievementsState
                                .getDetailsWidget(achievement.id),
                            completedDetails: achievementsState
                                .getCompletedDetailsWidget(achievement.id),
                          )));
              await FirebaseAnalytics.instance.logEvent(
                  name: AnalyticsEventType.achievement_status_checked.name,
                  parameters: {
                    "id": achievement.id,
                    "progress": achievement.progress
                  });
            })
      ]);
    } else {
      return Stack(children: [
        getEggCrack(achievement),
        InkWell(
            child: getProgress(achievement.progress, achievement.isSecret),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AchievementDetailsScreen(
                          achievementSnapshot: achievement,
                          details: achievementsState
                              .getDetailsWidget(achievement.id),
                          completedDetails: achievementsState
                              .getCompletedDetailsWidget(achievement.id))));
              await FirebaseAnalytics.instance.logEvent(
                  name: AnalyticsEventType.achievement_status_checked.name,
                  parameters: {
                    "id": achievement.id,
                    "progress": achievement.progress
                  });
              if (achievement.status == AchievementStatus.completed) {
                achievementsState.updateAchievementSnapshot(
                    AchievementSnapshot.updateStatus(
                        achievement, AchievementStatus.completedAndShown));
                await FirebaseAnalytics.instance.logEvent(
                    name: AnalyticsEventType.achievement_collected.name,
                    parameters: {"id": achievement.id});
              }
            }),
        Visibility(
            visible: achievement.status == AchievementStatus.completed,
            child: Positioned(
                top: 5,
                right: 0,
                child: SvgPicture.asset(
                    "assets/achievements/${getSubFolder(achievement.isSecret)}/new_label.svg")))
      ]);
    }
  }

  static SvgPicture getEggCrack(AchievementSnapshot achievementSnapshot) {
    int part = (achievementSnapshot.progress * 3).floor().clamp(0, 2);
    return SvgPicture.asset(
        width: double.infinity,
        height: double.infinity,
        "assets/achievements/${getSubFolder(achievementSnapshot.isSecret)}/${part}_3_egg.svg");
  }

  static Widget getProgress(double progress, bool isSecret) {
    final subFolder = isSecret ? 'secret' : 'general';
    int res = percents.lastWhere(
        (element) => (progress * 100).toInt() >= element,
        orElse: () => 0);
    return SvgPicture.asset(
        width: double.infinity,
        height: double.infinity,
        "assets/achievements/$subFolder/progress/$res%.svg");
  }

  static getSubFolder(bool isSecret) {
    return isSecret ? 'secret' : 'general';
  }
}
