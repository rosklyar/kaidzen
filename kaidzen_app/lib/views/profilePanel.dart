import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/features/Feature.dart';
import 'package:kaidzen_app/features/FeaturesState.dart';
import 'package:kaidzen_app/service/AnalyticsService.dart';
import 'package:kaidzen_app/service/ProgressState.dart';
import 'package:kaidzen_app/achievements/achievementsScreen.dart';
import 'package:kaidzen_app/settings/SettingsScreen.dart';
import 'package:kaidzen_app/views/utils.dart';
import 'package:provider/provider.dart';

import '../service/HabitState.dart';
import '../service/TasksState.dart';
import '../tutorial/TutorialState.dart';
import '../utils/snackbar.dart';

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
    return Consumer6<ProgressState, AchievementsState, EmotionsState,
            TutorialState, FeaturesState, HabitState>(
        builder: (context, progressState, achievementsState, emotionsState,
                tutorialState, featuresState, habitState, child) =>
            Stack(children: [
              Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: parentHeight * 0.055),
                        child: Column(children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: parentHeight * 0.01,
                                      left: parentWidth * 0.015),
                                  child: GestureDetector(
                                    onTap: () => showDefaultTopFlushbar(
                                        getTextForEmotion(
                                            tutorialState, emotionsState),
                                        context),
                                    child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 1200),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          var fadeTransition = FadeTransition(
                                              opacity: animation, child: child);
                                          return tutorialState
                                                  .tutorialCompleted()
                                              ? fadeTransition
                                              : RotationTransition(
                                                  child: child,
                                                  alignment: Alignment.center,
                                                  turns: shackingAnimation()
                                                      .animate(animation));
                                        },
                                        child: avatar(
                                            tutorialState, emotionsState)),
                                  )),
                              flex: 4),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    scale: animation, child: child);
                              },
                              child: RichText(
                                key: ValueKey<int>(progressState
                                    .getTotalLevel()), // This key is needed for AnimatedSwitcher to know when the child changes
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "TOTAL LVL  ",
                                      style: Fonts.smallTextStyle.copyWith(
                                          fontSize: 9, letterSpacing: 0.02)),
                                  TextSpan(
                                    text: progressState
                                        .getTotalLevel()
                                        .toString(),
                                    style: Fonts.mediumBoldTextStyle
                                        .copyWith(fontSize: 18),
                                  )
                                ]),
                              ),
                            ),
                            flex: 1,
                          )
                        ]),
                      ),
                      flex: 4),
                  Expanded(
                      child: Column(children: [
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: parentHeight * 0.05,
                                  right: parentWidth * 0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Stack(children: [
                                    IconButton(
                                      padding: EdgeInsets.only(
                                          right: parentWidth * 0.01),
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AchievementsScreen()));
                                        await FirebaseAnalytics.instance
                                            .logEvent(
                                                name: AnalyticsEventType
                                                    .achievements_screen_opened
                                                    .name);
                                        if (!featuresState.isFeatureDiscovered(
                                                Features.ORIGAMI.id) &&
                                            achievementsState
                                                .notShownWithOrigamiCompleted()) {
                                          featuresState.discoverFeature(
                                              Features.ORIGAMI.id);
                                        }
                                      },
                                      icon: Image.asset(
                                          "assets/achievements_icon.png",
                                          height: parentWidth * 0.06),
                                    ),
                                    Visibility(
                                        visible: achievementsState
                                                    .getCompletedAchievementsCount() >
                                                0 ||
                                            (!featuresState.isFeatureDiscovered(
                                                    Features.ORIGAMI.id) &&
                                                achievementsState
                                                    .notShownWithOrigamiCompleted()),
                                        child: Positioned(
                                          right: parentWidth * 0.01,
                                          top: parentWidth * 0.01,
                                          child: Container(
                                            width: parentWidth * 0.03,
                                            height: parentWidth * 0.02,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                            child: const Center(
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ]),
                                  Stack(
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SettingsScreen()));
                                          await FirebaseAnalytics.instance
                                              .logEvent(
                                                  name: AnalyticsEventType
                                                      .settings_screen_opened
                                                      .name);
                                        },
                                        icon: Image.asset(
                                            "assets/burger_icon.png",
                                            height: parentWidth * 0.06),
                                      ),
                                      Visibility(
                                          visible: !featuresState
                                              .isFeatureDiscovered(
                                                  Features.REMINDER.id),
                                          child: Positioned(
                                            right: parentWidth * 0.01,
                                            top: parentWidth * 0.01,
                                            child: Container(
                                              width: parentWidth * 0.03,
                                              height: parentWidth * 0.02,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red),
                                              child: const Center(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            flex: 4),
                        const Expanded(child: SizedBox(), flex: 1),
                        Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: parentWidth * 0.02),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: ProgressIndicator(
                                                  percent: progressState
                                                      .getLevelProgressFraction(
                                                          DevelopmentCategory
                                                              .MIND),
                                                  level: progressState.getLevel(
                                                      DevelopmentCategory.MIND),
                                                  title: DevelopmentCategory
                                                      .MIND.name,
                                                  progressColor:
                                                      DevelopmentCategory
                                                          .MIND.color),
                                              flex: 1),
                                          Expanded(
                                              child: ProgressIndicator(
                                                  percent: progressState
                                                      .getLevelProgressFraction(
                                                          DevelopmentCategory
                                                              .HEALTH),
                                                  level: progressState.getLevel(
                                                      DevelopmentCategory
                                                          .HEALTH),
                                                  title: DevelopmentCategory
                                                      .HEALTH.name,
                                                  progressColor:
                                                      DevelopmentCategory
                                                          .HEALTH.color),
                                              flex: 1),
                                          Expanded(
                                              child: ProgressIndicator(
                                                  percent: progressState
                                                      .getLevelProgressFraction(
                                                          DevelopmentCategory
                                                              .ENERGY),
                                                  level: progressState.getLevel(
                                                      DevelopmentCategory
                                                          .ENERGY),
                                                  title: DevelopmentCategory
                                                      .ENERGY.name,
                                                  progressColor:
                                                      DevelopmentCategory
                                                          .ENERGY.color),
                                              flex: 1),
                                        ],
                                      ),
                                      flex: 1),
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: ProgressIndicator(
                                                  percent: progressState
                                                      .getLevelProgressFraction(
                                                          DevelopmentCategory
                                                              .WEALTH),
                                                  level: progressState.getLevel(
                                                      DevelopmentCategory
                                                          .WEALTH),
                                                  title: DevelopmentCategory
                                                      .WEALTH.name,
                                                  progressColor:
                                                      DevelopmentCategory
                                                          .WEALTH.color),
                                              flex: 1),
                                          Expanded(
                                              child: ProgressIndicator(
                                                  percent: progressState
                                                      .getLevelProgressFraction(
                                                          DevelopmentCategory
                                                              .RELATIONS),
                                                  level: progressState.getLevel(
                                                      DevelopmentCategory
                                                          .RELATIONS),
                                                  title: DevelopmentCategory
                                                      .RELATIONS.name,
                                                  progressColor:
                                                      DevelopmentCategory
                                                          .RELATIONS.color),
                                              flex: 1),
                                          const Expanded(
                                              child: SizedBox(), flex: 1),
                                        ],
                                      ),
                                      flex: 1)
                                ],
                              ),
                            ),
                            flex: 4)
                      ]),
                      flex: 6)
                ],
              )
            ]));
  }

  Image avatar(TutorialState tutorialState, EmotionsState emotionsState) {
    var avatarPath = Utils.resolveEmotionedAvatar(tutorialState, emotionsState);
    return Image.asset(
        key: ValueKey(avatarPath),
        avatarPath,
        width: MediaQuery.of(context).size.width * 0.4);
  }

  String getTextForEmotion(
      TutorialState tutorialState, EmotionsState emotionsState) {
    if (!tutorialState.tutorialCompleted()) {
      return "...";
    }
    if (Provider.of<TasksState>(context, listen: false)
            .getCountByStatus(Status.TODO) ==
        0) {
      return "How are you going to achieve your goals if you don't have any?";
    }

    return emotionsState.getCurrentEmotion().text;
  }

  TweenSequence<double> shackingAnimation() {
    return TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 0.01)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 0.01, end: -0.01)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: -0.01, end: 0.01)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 0.01, end: -0.01)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: Tween(begin: -0.01, end: 0.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        ),
      ],
    );
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
        _color = widget.progressColor;
      });
    } else {
      if (oldWidget.percent < widget.percent) {
        _controller.animateTo(widget.percent,
            duration: const Duration(seconds: 1));
      } else {
        _controller.animateTo(widget.percent,
            duration: const Duration(milliseconds: 1));
      }
      setState(() {
        _color = lighten(_color!, 0.1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        child: Text(
                          " ${widget.title}",
                          style: Fonts.mediumTextStyle,
                          textAlign: TextAlign.left,
                        ),
                        padding: EdgeInsets.zero),
                    Row(children: [
                      Text(
                        "LVL   ",
                        style: Fonts.smallTextStyleLvl,
                      ),
                      Text(
                        "${widget.level}",
                        style: Fonts.mediumTextStyle,
                      ),
                    ]),
                  ])),
          Padding(
              padding: const EdgeInsets.only(left: 3, right: 10),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(1.0)),
                  child: AnimatedContainer(
                      height: 4.0,
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
