import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/service/ProgressState.dart';
import 'package:kaidzen_app/achievements/achievementsScreen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ProfilePanel extends StatefulWidget {
  const ProfilePanel({Key? key}) : super(key: key);

  @override
  ProfilePanelState createState() => ProfilePanelState();
}

class ProfilePanelState extends State<ProfilePanel> {
  ProfilePanelState();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProgressState, AchievementsState>(
        builder: (context, progressState, achievementsState, child) => Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(children: [
              Row(
                children: [
                  Expanded(
                      child: Stack(children: [
                        const Icon(
                          Icons.circle,
                          size: 130.0,
                          color: Colors.grey,
                        ),
                        Positioned(
                            top: 0.0,
                            left: 70.0,
                            right: 10.0,
                            bottom: 80.0,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2,
                                    color: const Color.fromARGB(
                                        255, 199, 192, 192)),
                                shape: BoxShape.circle,
                                // You can use like this way or like the below line
                                //borderRadius: new BorderRadius.circular(30.0),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(progressState.getTotalLevel().toString(),
                                      style: mediumTextStyle),
                                  const Text('LVL', style: smallTextStyle)
                                ],
                              ),
                            )),
                      ]),
                      flex: 4),
                  Expanded(
                      child: Column(children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Stack(children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AchievementsScreen()));
                                },
                                icon:
                                    Image.asset("assets/achievements_icon.png"),
                              ),
                              Visibility(
                                  visible: achievementsState
                                          .getCompletedAchievementsCount() >
                                      0,
                                  child: Positioned(
                                      top: 0.0,
                                      right: 4.0,
                                      child: Text(
                                          achievementsState
                                              .getCompletedAchievementsCount()
                                              .toString(),
                                          style: mediumTextStyle)))
                            ]),
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset("assets/burger_icon.png"),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                  children: [
                                    ProgressIndicator(
                                        percent: progressState
                                            .getLevelProgressFraction(
                                                DevelopmentCategory.MIND),
                                        level: progressState
                                            .getLevel(DevelopmentCategory.MIND),
                                        title: DevelopmentCategory.MIND.name,
                                        progressColor:
                                            DevelopmentCategory.MIND.color),
                                    ProgressIndicator(
                                        percent: progressState
                                            .getLevelProgressFraction(
                                                DevelopmentCategory.HEALTH),
                                        level: progressState.getLevel(
                                            DevelopmentCategory.HEALTH),
                                        title: DevelopmentCategory.HEALTH.name,
                                        progressColor:
                                            DevelopmentCategory.HEALTH.color),
                                    ProgressIndicator(
                                        percent: progressState
                                            .getLevelProgressFraction(
                                                DevelopmentCategory.ENERGY),
                                        level: progressState.getLevel(
                                            DevelopmentCategory.ENERGY),
                                        title: DevelopmentCategory.ENERGY.name,
                                        progressColor:
                                            DevelopmentCategory.ENERGY.color),
                                  ],
                                ),
                                flex: 5),
                            Expanded(
                                child: Column(
                                  children: [
                                    ProgressIndicator(
                                        percent: progressState
                                            .getLevelProgressFraction(
                                                DevelopmentCategory.WEALTH),
                                        level: progressState.getLevel(
                                            DevelopmentCategory.WEALTH),
                                        title: DevelopmentCategory.WEALTH.name,
                                        progressColor:
                                            DevelopmentCategory.WEALTH.color),
                                    ProgressIndicator(
                                        percent: progressState
                                            .getLevelProgressFraction(
                                                DevelopmentCategory.RELATIONS),
                                        level: progressState.getLevel(
                                            DevelopmentCategory.RELATIONS),
                                        title:
                                            DevelopmentCategory.RELATIONS.name,
                                        progressColor: DevelopmentCategory
                                            .RELATIONS.color),
                                    const SizedBox(height: 32.0),
                                  ],
                                ),
                                flex: 5)
                          ],
                        )
                      ]),
                      flex: 6)
                ],
              )
            ])));
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator(
      {Key? key,
      required this.percent,
      required this.level,
      required this.title,
      required this.progressColor})
      : super(key: key);

  final double percent;
  final int level;
  final String title;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      " $title",
                      style: mediumTextStyle,
                    ),
                    Row(children: [
                      const Text(
                        "LVL   ",
                        style: smallTextStyle,
                      ),
                      Text(
                        "$level",
                        style: mediumTextStyle,
                      ),
                    ]),
                  ])),
          LinearPercentIndicator(
            animateFromLastPercent: true,
            lineHeight: 8.0,
            percent: percent,
            animation: true,
            barRadius: const Radius.circular(3.0),
            backgroundColor: const Color.fromRGBO(225, 218, 218, 1.0),
            animationDuration: 1000,
            progressColor: progressColor,
          )
        ]));
  }
}
