import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/eggWidget.dart';
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
              child: Center(
                  child: Stack(children: [
                achievementSnapshot.status != AchievementStatus.notCompleted
                    ? SvgPicture.asset(
                        width: double.infinity,
                        height: double.infinity,
                        "assets/achievements/completed_egg.svg")
                    : SvgPicture.asset(
                        width: double.infinity,
                        height: double.infinity,
                        "assets/achievements/egg.svg"),
                EggWidget.getProgress(achievementSnapshot.progress),
                achievementSnapshot.status != AchievementStatus.notCompleted
                    ? SvgPicture.asset(
                        width: double.infinity,
                        height: double.infinity,
                        "assets/achievements/sets/${achievementSnapshot.setId}/${achievementSnapshot.iconName}")
                    : SvgPicture.asset(
                        width: double.infinity,
                        height: double.infinity,
                        "assets/achievements/origami_grey_placeholder.svg")
              ])),
              flex: 3),
          Expanded(
              child: Column(children: [
                const SizedBox(height: 25),
                Text(achievementSnapshot.title,
                    style: achievementsAppBarTextStyle),
                const SizedBox(height: 35),
                Visibility(
                    visible: !achievementSnapshot.isSecret,
                    child: Text(achievementSnapshot.description,
                        style: achievementsDescriptionTextStyle))
              ]),
              flex: 2),
        ]));
  }
}
