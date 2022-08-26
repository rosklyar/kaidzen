import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/achievementDetailsScreen.dart';
import 'package:kaidzen_app/achievements/style.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

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
                      ]),
                  flex: 1),
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Image.asset("assets/dragon.png")),
                        Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child:
                                getNewAchievementsComponent(achievementsState))
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
                          Stack(children: [
                            SvgPicture.asset("assets/achievements/egg.svg"),
                            Visibility(
                                visible: achievement.progress > 0.0,
                                child: getProgressWidget(achievement.progress)),
                            InkWell(
                                child: getOrigami(achievement),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AchievementDetailsScreen(
                                                  achievementSnapshot:
                                                      achievement)));
                                  if (achievement.status ==
                                      AchievementStatus.completed) {
                                    achievementsState.updateAchievementSnapshot(
                                        AchievementSnapshot.updateStatus(
                                            achievement,
                                            AchievementStatus
                                                .completedAndShown));
                                  }
                                }),
                            Visibility(
                                visible: achievement.status ==
                                    AchievementStatus.completed,
                                child: Positioned(
                                    top: 5,
                                    right: 0,
                                    child: SvgPicture.asset(
                                        "assets/achievements/new_label.svg")))
                          ]),
                          const SizedBox(height: 5),
                          Text(achievement.title,
                              style: achievementsTitleTextStyle)
                        ],
                      );
                    }).toList(),
                  ),
                  flex: 8),
            ])));
  }

  SvgPicture getOrigami(AchievementSnapshot snapshot) {
    return snapshot.status == AchievementStatus.completedAndShown
        ? SvgPicture.asset("assets/sets/${snapshot.setId}/${snapshot.iconName}")
        : SvgPicture.asset("assets/achievements/origami_grey_placeholder.svg");
  }

  Positioned getProgressWidget(double progress) {
    return Positioned(
        right: 0, child: SvgPicture.asset("assets/achievements/progress.svg"));
  }

  Widget getNewAchievementsComponent(AchievementsState achievementsState) {
    var completedAchievementsCount =
        achievementsState.getCompletedAchievementsCount();
    return completedAchievementsCount > 0
        ? Column(children: [
            Expanded(
                child: Stack(children: [
                  SvgPicture.asset("assets/achievements/new_origami_text.svg"),
                  Positioned(
                      top: 3.4,
                      right: 28.0,
                      child: Text(completedAchievementsCount.toString(),
                          style: achievementsTitleTextStyle))
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
                    onTap: null),
                flex: 1)
          ])
        : const Text("Gain\nachievements\nby reaching\nyour goals",
            style: achievementsDescriptionTextStyle,
            textAlign: TextAlign.center);
  }
}
