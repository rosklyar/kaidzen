import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/eggWidget.dart';
import 'package:kaidzen_app/achievements/style.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../assets/constants.dart';

class AchievementDetailsScreen extends StatelessWidget {
  final AchievementSnapshot achievementSnapshot;
  final Widget details;
  const AchievementDetailsScreen(
      {Key? key, required this.achievementSnapshot, required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: achievementScreenBackgroundColor,
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(children: [
                IconButton(
                  icon: Image.asset("assets/shevron-left.png"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                IconButton(
                  icon: Image.asset("assets/close_icon.png"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween)),
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
              flex: 1),
          Expanded(
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 25),
                    child: Text(achievementSnapshot.title,
                        style: achievementsAppBarTextStyle)),
                Visibility(
                    visible: !achievementSnapshot.isSecret,
                    child: Text(achievementSnapshot.description,
                        style: achievementsDescriptionTextStyle)),
                Padding(padding: const EdgeInsets.only(top: 10), child: details)
              ]),
              flex: 1),
        ]));
  }
}
