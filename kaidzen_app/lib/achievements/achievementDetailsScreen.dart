import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/style.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../assets/constants.dart';

class AchievementDetailsScreen extends StatelessWidget {
  final AchievementSnapshot achievementSnapshot;

  const AchievementDetailsScreen({Key? key, required this.achievementSnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: achievementScreenBackgroundColor,
        appBar: AppBar(
          backgroundColor: achievementScreenBackgroundColor,
          leading: IconButton(
            icon: Image.asset("assets/shevron-left.png"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Image.asset("assets/close_icon.png"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: Column(children: [
          const SizedBox(height: 25),
          Expanded(
              child: Stack(children: [
                Center(
                    child: SizedBox(
                        width: 310,
                        height: 310,
                        child: CircularPercentIndicator(
                          radius: 150,
                          lineWidth: 10,
                          percent: achievementSnapshot.progress,
                          progressColor: achievementDetailsProgressColor,
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor:
                              notCompletedAchievementScreenBackgroundColor,
                        ))),
                Center(
                    child: SizedBox(
                        width: 280,
                        height: 280,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 10,
                                    color: achievementScreenBackgroundColor),
                                shape: BoxShape.circle,
                                color:
                                    notCompletedAchievementScreenBackgroundColor),
                            child: achievementSnapshot.status !=
                                    AchievementStatus.notCompleted
                                ? Image.asset(
                                    "assets/sets/${achievementSnapshot.setId}/${achievementSnapshot.iconName}")
                                : Image.asset(
                                    "assets/locked-achievement-big.png"))))
              ]),
              flex: 3),
          Expanded(
              child: Column(children: [
                const SizedBox(height: 25),
                Text(achievementSnapshot.title,
                    style: achievementsAppBarTextStyle),
                const SizedBox(height: 35),
                Text(achievementSnapshot.description,
                    style: achievementsDescriptionTextStyle)
              ]),
              flex: 2),
        ]));
  }
}
