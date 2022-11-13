import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/eggWidget.dart';
import 'package:kaidzen_app/achievements/style.dart';

import '../main.dart';

class AchievementDetailsScreen extends StatelessWidget {
  final AchievementSnapshot achievementSnapshot;
  final Widget details;
  const AchievementDetailsScreen(
      {Key? key, required this.achievementSnapshot, required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AchievementsStyle.achievementScreenBackgroundColor,
        body: Column(children: [
          Expanded(
              child: Padding(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      },
                    )
                  ], mainAxisAlignment: MainAxisAlignment.spaceBetween)),
              flex: 1),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Center(
                      child: Stack(children: [
                    achievementSnapshot.status != AchievementStatus.notCompleted
                        ? SvgPicture.asset(
                            width: double.infinity,
                            height: double.infinity,
                            "assets/achievements/${EggWidget.getSubFolder(achievementSnapshot.isSecret)}/completed_egg.svg")
                        : EggWidget.getEggCrack(achievementSnapshot),
                    EggWidget.getProgress(achievementSnapshot.progress,
                        achievementSnapshot.isSecret),
                    Visibility(
                        visible: achievementSnapshot.status !=
                            AchievementStatus.notCompleted,
                        child: SvgPicture.asset(
                            width: double.infinity,
                            height: double.infinity,
                            "assets/achievements/sets/${achievementSnapshot.setId}/${achievementSnapshot.iconName}"))
                  ]))),
              flex: 4),
          Expanded(
              child: Column(children: [
                Expanded(
                    child: Center(
                        child: Text(achievementSnapshot.title,
                            style:
                                AchievementsStyle.achievementsAppBarTextStyle)),
                    flex: 1),
                Expanded(
                    child: Visibility(
                        visible: !achievementSnapshot.isSecret,
                        child: Text(achievementSnapshot.description,
                            style: AchievementsStyle
                                .achievementsDescriptionTextStyle)),
                    flex: 1),
                Expanded(
                    child: !achievementSnapshot.isSecret &&
                            achievementSnapshot.status ==
                                AchievementStatus.notCompleted
                        ? details
                        : Container(),
                    flex: 6)
              ]),
              flex: 6),
        ]));
  }
}
