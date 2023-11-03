import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/achievements/achievement.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/eggWidget.dart';
import 'package:kaidzen_app/achievements/style.dart';

import '../assets/constants.dart';

class AchievementDetailsScreen extends StatelessWidget {
  final AchievementSnapshot achievementSnapshot;
  final Widget details;
  final Widget completedDetails;
  final CompletedDetailsType completedDetailsType;
  const AchievementDetailsScreen(
      {Key? key,
      required this.achievementSnapshot,
      required this.details,
      required this.completedDetails,
      this.completedDetailsType = CompletedDetailsType.COMING_SOON})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AchievementsStyle.achievementScreenBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: Image.asset("assets/shevron-left.png"),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Image.asset("assets/close_icon.png"),
              onPressed: () {
                SystemChrome.setApplicationSwitcherDescription(
                    ApplicationSwitcherDescription(
                        label: "Sticky Goals",
                        primaryColor: moreScreenBackColor.value));
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
            )
          ],
          backgroundColor: AchievementsStyle.achievementScreenBackgroundColor,
        ),
        body: Column(children: [
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
                        child: achievementSnapshot.status !=
                                    AchievementStatus.notCompleted &&
                                completedDetailsType ==
                                    CompletedDetailsType.ORIGAMI_INSTRUCTION
                            ? Text(
                                "You've unlocked an origami!\nAssemble it to proudly display your\nachievement!",
                                style: AchievementsStyle
                                    .achievementsDescriptionTextStyle,
                                textAlign: TextAlign.center)
                            : Text(achievementSnapshot.description,
                                style: AchievementsStyle
                                    .achievementsDescriptionTextStyle)),
                    flex: 1),
                Expanded(
                    child: !achievementSnapshot.isSecret &&
                            achievementSnapshot.status ==
                                AchievementStatus.notCompleted
                        ? details
                        : completedDetails,
                    flex: 6)
              ]),
              flex: 7),
        ]));
  }
}
