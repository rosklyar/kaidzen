import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/style.dart';

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
          const SizedBox(height: 15),
          Expanded(
              child: Stack(children: [
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 10, color: achievementScreenBackgroundColor),
                        shape: BoxShape.circle,
                        color: notCompletedAchievementScreenBackgroundColor),
                    child: achievementSnapshot.status !=
                            AchievementStatus.notCompleted
                        ? Image.asset(
                            "assets/sets/${achievementSnapshot.setId}/${achievementSnapshot.iconName}")
                        : Image.asset("assets/locked-achievement-big.png"))
              ]),
              flex: 1),
          const SizedBox(height: 15),
          Text(achievementSnapshot.title, style: achievementsAppBarTextStyle),
          const SizedBox(height: 30),
          Expanded(
              child: Text(achievementSnapshot.description,
                  style: achievementsTitleTextStyle)),
        ]));
  }
}
