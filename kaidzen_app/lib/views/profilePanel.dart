import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/service/AnalyticsService.dart';
import 'package:kaidzen_app/service/ProgressState.dart';
import 'package:kaidzen_app/achievements/achievementsScreen.dart';
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
                        Padding(
                            padding: const EdgeInsets.only(left: 30, top: 6),
                            child: Image.asset("assets/dragon.png", width: 100))
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
                                          .ACHIEVEMENTS_SCREEN_OPENED.name);
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
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                await FirebaseAnalytics.instance.logEvent(
                                    name: AnalyticsEventType
                                        .SETTINGS_SCREEN_OPENED.name);
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
                      style: mediumTextStyle,
                    ),
                    Row(children: [
                      const Text(
                        "LVL   ",
                        style: smallTextStyle,
                      ),
                      Text(
                        "${widget.level}",
                        style: mediumTextStyle,
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
