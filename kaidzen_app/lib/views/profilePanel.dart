import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/service/AnalyticsService.dart';
import 'package:kaidzen_app/service/ProgressState.dart';
import 'package:kaidzen_app/achievements/achievementsScreen.dart';
import 'package:kaidzen_app/settings/SettingsScreen.dart';
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

  @override
  Widget build(BuildContext context) {
    var parentHeight = MediaQuery.of(context).size.height;
    var parentWidth = MediaQuery.of(context).size.width;
    return Consumer4<ProgressState, AchievementsState, EmotionsState,
            TutorialState>(
        builder: (context, progressState, achievementsState, emotionsState,
                tutorialState, child) =>
            Stack(children: [
              Row(
                children: [
                  Expanded(
                      child: Column(children: [
                        Stack(children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(top: parentHeight * 0.09),
                              child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 800),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                  child: avatar(tutorialState, emotionsState))),
                        ]),
                        Row(children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(left: parentHeight * 0.07),
                              child: Text("TOTAL LVL  ",
                                  style: Fonts.smallTextStyle)),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: parentHeight * 0.005),
                            child: Text(
                              progressState.getTotalLevel().toString(),
                              style: Fonts.mediumBoldTextStyle,
                            ),
                          )
                        ])
                      ]),
                      flex: 4),
                  Expanded(
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: parentHeight * 0.05,
                              right: parentWidth * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Stack(children: [
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AchievementsScreen()));
                                    await FirebaseAnalytics.instance.logEvent(
                                        name: AnalyticsEventType
                                            .achievements_screen_opened.name);
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: parentWidth * 0.04,
                                          right: parentWidth * 0.03),
                                      child: Image.asset(
                                          "assets/achievements_icon.png",
                                          height: parentWidth * 0.07)),
                                ),
                                Visibility(
                                    visible: achievementsState
                                            .getCompletedAchievementsCount() >
                                        0,
                                    child: Positioned(
                                      top: parentWidth * 0.01,
                                      right: 0,
                                      child: Container(
                                        width: parentWidth * 0.05,
                                        height: parentWidth * 0.04,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromARGB(
                                                255, 204, 158, 243)),
                                        child: Center(
                                          child: Text(
                                            achievementsState
                                                .getCompletedAchievementsCount()
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              ]),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SettingsScreen()));
                                  await FirebaseAnalytics.instance.logEvent(
                                      name: AnalyticsEventType
                                          .settings_screen_opened.name);
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: parentWidth * 0.04, right: 7),
                                    child: Image.asset("assets/burger_icon.png",
                                        height: parentWidth * 0.06)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: parentHeight * 0.01),
                        Padding(
                          padding: EdgeInsets.only(right: parentWidth * 0.02),
                          child: Row(
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
                                          title: DevelopmentCategory.MIND.name,
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
                                          progressColor:
                                              DevelopmentCategory.HEALTH.color),
                                      ProgressIndicator(
                                          percent: progressState
                                              .getLevelProgressFraction(
                                                  DevelopmentCategory.ENERGY),
                                          level: progressState.getLevel(
                                              DevelopmentCategory.ENERGY),
                                          title:
                                              DevelopmentCategory.ENERGY.name,
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
                                          title:
                                              DevelopmentCategory.WEALTH.name,
                                          progressColor:
                                              DevelopmentCategory.WEALTH.color),
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
                          ),
                        )
                      ]),
                      flex: 6)
                ],
              )
            ]));
  }

  Image avatar(TutorialState tutorialState, EmotionsState emotionsState) {
    var avatarPath = resolveEmotionedAvatar(tutorialState, emotionsState);
    return Image.asset(
        key: ValueKey(avatarPath),
        avatarPath,
        width: MediaQuery.of(context).size.width * 0.25);
  }

  String resolveEmotionedAvatar(
      TutorialState tutorialState, EmotionsState emotionsState) {
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

    return emotionsState.getCurrentEmotion().assetPath;
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
  double _height = 8.0;
  Color? _color;

  @override
  void initState() {
    super.initState();
    _color = widget.progressColor;
    _controller = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant ProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent == widget.percent) {
      setState(() {
        _height = 8.0;
        _color = widget.progressColor;
      });
    } else {
      if (oldWidget.percent < widget.percent) {
        _controller.animateTo(widget.percent,
            duration: const Duration(seconds: 1));
      } else {
        _controller.animateTo(1.0, duration: const Duration(milliseconds: 500));
        _controller.animateTo(0.0, duration: const Duration(microseconds: 1));
        _controller.animateTo(widget.percent,
            duration: const Duration(milliseconds: 500));
      }
      setState(() {
        _height = 12.0;
        _color = lighten(_color!, 0.2);
      });
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
                  child: AnimatedContainer(
                      height: _height,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      child: LinearProgressIndicator(
                          value: _controller.value,
                          backgroundColor: whiteBackgroundColor,
                          color: _color))))
        ]));
  }

  Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
