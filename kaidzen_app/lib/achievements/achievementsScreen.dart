import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/achievementDetailsScreen.dart';
import 'package:kaidzen_app/achievements/eggWidget.dart';
import 'package:kaidzen_app/achievements/style.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'achievementSnaphot.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementsState>(
        builder: (context, achievementsState, child) => Scaffold(
            backgroundColor: achievementScreenBackgroundColor,
            body: Column(children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 32),
                            const Text('Achievements',
                                style: achievementsAppBarTextStyle),
                            IconButton(
                              iconSize: 32,
                              icon: Image.asset("assets/close_icon.png"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ])),
                  flex: 1),
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Image.asset("assets/dragon.png")),
                        Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: getNewAchievementsComponent(
                                achievementsState, context))
                      ]),
                  flex: 2),
              Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    children:
                        achievementsState.getAchievements().map((achievement) {
                      return Column(
                        children: [
                          Expanded(
                              child: achievement.isSecret
                                  ? buildSecretEgg(
                                      achievement, context, achievementsState)
                                  : EggWidget(
                                      achievement: achievement,
                                      achievementsState: achievementsState),
                              flex: 10),
                          const Expanded(child: SizedBox(), flex: 1),
                          Expanded(
                              child: Text(achievement.title,
                                  style: achievementsTitleTextStyle),
                              flex: 2)
                        ],
                      );
                    }).toList(),
                  ),
                  flex: 10),
            ])));
  }

  Widget getNewAchievementsComponent(
      AchievementsState achievementsState, BuildContext context) {
    var completedAchievementsCount =
        achievementsState.getCompletedAchievementsCount();
    return completedAchievementsCount > 0
        ? Column(children: [
            Expanded(
                child: Stack(children: [
                  SvgPicture.asset(
                      "assets/achievements/new_origami_text/new_origami_text_${completedAchievementsCount % 10}.svg")
                ]),
                flex: 2),
            const SizedBox(height: 10),
            Expanded(
                child: SvgPicture.asset("assets/achievements/broken_egg.svg"),
                flex: 2),
            const SizedBox(height: 15),
            Expanded(
                child: InkWell(
                    child: SvgPicture.asset(
                        "assets/achievements/origami_collect_button.svg"),
                    onTap: () {
                      AchievementSnapshot achievement =
                          achievementsState.getCompletedAchievement();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AchievementDetailsScreen(
                                  achievementSnapshot: achievement,
                                  details: achievementsState
                                      .getDetailsWidget(achievement.id))));
                      if (achievement.status == AchievementStatus.completed) {
                        achievementsState.updateAchievementSnapshot(
                            AchievementSnapshot.updateStatus(achievement,
                                AchievementStatus.completedAndShown));
                      }
                    }),
                flex: 1)
          ])
        : const Text("Gain\nachievements\nby reaching\nyour goals",
            style: achievementsDescriptionTextStyle,
            textAlign: TextAlign.center);
  }

  Widget buildSecretEgg(AchievementSnapshot achievement, BuildContext context,
      AchievementsState achievementsState) {
    if (achievement.status == AchievementStatus.completedAndShown) {
      return EggWidget(
          achievement: achievement, achievementsState: achievementsState);
    } else if (achievement.status == AchievementStatus.notCompleted) {
      return SvgPicture.asset(
          "assets/achievements/secret/hidden_not_completed.svg");
    } else if (achievement.status == AchievementStatus.completed) {
      return InkWell(
          child: SvgPicture.asset(
              "assets/achievements/secret/hidden_completed.svg"),
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
          });
    }
    return const SizedBox.shrink();
  }
}
