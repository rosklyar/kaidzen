import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/service/AnalyticsService.dart';
import 'package:kaidzen_app/service/ProgressState.dart';
import 'package:kaidzen_app/achievements/achievementsScreen.dart';
import 'package:provider/provider.dart';

import '../tutorial/TutorialState.dart';

class ProfilePanel extends StatefulWidget {
  const ProfilePanel({Key? key}) : super(key: key);

  @override
  ProfilePanelState createState() => ProfilePanelState();
}

class ProfilePanelState extends State<ProfilePanel>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );
  ProfilePanelState();

  @override
  Widget build(BuildContext context) {
    return Consumer4<ProgressState, AchievementsState, EmotionsState,
            TutorialState>(
        builder: (context, progressState, achievementsState, emotionsState,
                tutorialState, child) =>
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(children: [
                  Row(
                    children: [
                      Expanded(
                          child: Column(children: [
                            Stack(children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 20),
                                  child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 800),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return FadeTransition(
                                            opacity: animation, child: child);
                                      },
                                      child: avatar(
                                          tutorialState, emotionsState))),
                            ]),
                            Row(children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 65, top: 2),
                                  child: Text(
                                    "LVL ",
                                    style: Fonts.smallTextStyle,
                                  )),
                              Text(
                                progressState.getTotalLevel().toString(),
                                style: Fonts.mediumTextStyle,
                              )
                            ])
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
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AchievementsScreen()));
                                      await FirebaseAnalytics.instance.logEvent(
                                          name: AnalyticsEventType
                                              .achievements_screen_opened.name);
                                    },
                                    icon: Image.asset(
                                        "assets/achievements_icon.png"),
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
                                              style: Fonts.mediumTextStyle)))
                                ]),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    await FirebaseAnalytics.instance.logEvent(
                                        name: AnalyticsEventType
                                            .settings_screen_opened.name);
                                  },
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
                                            level: progressState.getLevel(
                                                DevelopmentCategory.MIND),
                                            title:
                                                DevelopmentCategory.MIND.name,
                                            progressColor:
                                                DevelopmentCategory.MIND.color),
                                        ProgressIndicator(
                                            percent: progressState
                                                .getLevelProgressFraction(
                                                    DevelopmentCategory.HEALTH),
                                            level: progressState.getLevel(
                                                DevelopmentCategory.HEALTH),
                                            title:
                                                DevelopmentCategory.HEALTH.name,
                                            progressColor: DevelopmentCategory
                                                .HEALTH.color),
                                        ProgressIndicator(
                                            percent: progressState
                                                .getLevelProgressFraction(
                                                    DevelopmentCategory.ENERGY),
                                            level: progressState.getLevel(
                                                DevelopmentCategory.ENERGY),
                                            title:
                                                DevelopmentCategory.ENERGY.name,
                                            progressColor: DevelopmentCategory
                                                .ENERGY.color),
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
                                            title:
                                                DevelopmentCategory.WEALTH.name,
                                            progressColor: DevelopmentCategory
                                                .WEALTH.color),
                                        ProgressIndicator(
                                            percent: progressState
                                                .getLevelProgressFraction(
                                                    DevelopmentCategory
                                                        .RELATIONS),
                                            level: progressState.getLevel(
                                                DevelopmentCategory.RELATIONS),
                                            title: DevelopmentCategory
                                                .RELATIONS.name,
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

  Image avatar(TutorialState tutorialState, EmotionsState emotionsState) {
    var avatarPath = resolveEmotionedAvatar(tutorialState, emotionsState);
    return Image.asset(key: ValueKey(avatarPath), avatarPath, width: 100);
  }

  String resolveEmotionedAvatar(
      TutorialState tutorialState, EmotionsState emotionsState) {
    var points = emotionsState.emotionPoints.points;

    var completedStepsCount =
        tutorialState.getTutorialProgress().completedStepsCount();

    if (completedStepsCount < 3) {
      if (completedStepsCount == 0) {
        return "assets/emotions/egg01.png";
      } else if (completedStepsCount == 1) {
        return "assets/emotions/egg02.png";
      } else {
        return "assets/emotions/egg03.png";
      }
    }

    if (points <= 10) {
      return "assets/emotions/sad03.png";
    } else if (points > 10 && points <= 20) {
      return "assets/emotions/sad02.png";
    } else if (points > 20 && points <= 30) {
      return "assets/emotions/sad01.png";
    } else if (points > 30 && points <= 40) {
      return "assets/emotions/regular.png";
    } else if (points > 40 && points <= 50) {
      return "assets/emotions/happy01.png";
    } else if (points > 50 && points <= 60) {
      return "assets/emotions/happy02.png";
    } else if (points > 60) {
      return "assets/emotions/happy03.png";
    }

    return "assets/emotions/regular.png";
  }
}

class ProgressIndicator extends StatefulWidget {
  final double percent;
  final int level;
  final String title;
  final Color progressColor;

  const ProgressIndicator(
      {Key? key,
      required this.percent,
      required this.level,
      required this.title,
      required this.progressColor})
      : super(key: key);

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant ProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent <= widget.percent) {
      _controller.animateTo(widget.percent,
          duration: const Duration(seconds: 1));
    } else {
      _controller.animateTo(1.0, duration: const Duration(milliseconds: 500));
      _controller.animateTo(widget.percent,
          duration: const Duration(milliseconds: 500));
    }
  }

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
                      " ${widget.title}",
                      style: Fonts.mediumTextStyle,
                    ),
                    Row(children: [
                      Text(
                        "LVL   ",
                        style: Fonts.smallTextStyle,
                      ),
                      Text(
                        "${widget.level}",
                        style: Fonts.mediumTextStyle,
                      ),
                    ]),
                  ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                  child: LinearProgressIndicator(
                      minHeight: 8.0,
                      value: _controller.value,
                      backgroundColor: const Color.fromRGBO(225, 218, 218, 1.0),
                      color: widget.progressColor)))
        ]));
  }
}
