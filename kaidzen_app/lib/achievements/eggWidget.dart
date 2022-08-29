import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';

import 'achievementDetailsScreen.dart';

class EggWidget extends StatelessWidget {
  static int step = 25;
  static List<int> percents = [for (var i = 0; i <= 100; i = i + step) i];
  final AchievementSnapshot achievement;
  final AchievementsState achievementsState;
  const EggWidget(
      {Key? key, required this.achievement, required this.achievementsState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      achievement.status == AchievementStatus.completedAndShown
          ? SvgPicture.asset(
              width: double.infinity,
              height: double.infinity,
              "assets/achievements/completed_egg.svg")
          : SvgPicture.asset(
              width: double.infinity,
              height: double.infinity,
              "assets/achievements/egg.svg"),
      getProgress(achievement.progress),
      InkWell(
          child: getOrigami(achievement),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AchievementDetailsScreen(
                        achievementSnapshot: achievement,
                        details: achievementsState
                            .getDetailsWidget(achievement.id))));
            if (achievement.status == AchievementStatus.completed) {
              achievementsState.updateAchievementSnapshot(
                  AchievementSnapshot.updateStatus(
                      achievement, AchievementStatus.completedAndShown));
            }
          }),
      Visibility(
          visible: achievement.status == AchievementStatus.completed,
          child: Positioned(
              top: 5,
              right: 0,
              child: SvgPicture.asset("assets/achievements/new_label.svg")))
    ]);
  }

  static Widget getProgress(double progress) {
    int res = percents.lastWhere(
        (element) => (progress * 100).toInt() >= element,
        orElse: () => 0);
    return SvgPicture.asset(
        width: double.infinity,
        height: double.infinity,
        "assets/achievements/progress/$res%.svg");
  }

  static SvgPicture getOrigami(AchievementSnapshot snapshot) {
    return snapshot.status == AchievementStatus.completedAndShown
        ? SvgPicture.asset(
            width: double.infinity,
            height: double.infinity,
            "assets/achievements/sets/${snapshot.setId}/${snapshot.iconName}")
        : SvgPicture.asset(
            width: double.infinity,
            height: double.infinity,
            "assets/achievements/origami_grey_placeholder.svg");
  }
}
