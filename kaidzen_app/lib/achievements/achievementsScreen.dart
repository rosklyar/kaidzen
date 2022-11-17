import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/achievementDetailsScreen.dart';
import 'package:kaidzen_app/achievements/eggWidget.dart';
import 'package:kaidzen_app/achievements/style.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:provider/provider.dart';
import '../tutorial/TutorialState.dart';
import '../views/utils.dart';
import 'achievementSnaphot.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<AchievementsState, TutorialState, EmotionsState>(
        builder: (context, achievementsState, tutorialState, emotionsSate,
                child) =>
            AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                    statusBarColor: AchievementsStyle
                        .achievementScreenBackgroundColor
                        .withOpacity(0),
                    statusBarIconBrightness: Brightness.light,
                    systemNavigationBarIconBrightness: Brightness.light),
                child: Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) => [
                      SliverAppBar(
                        centerTitle: true,
                        title: Text('Achievements',
                            style:
                                AchievementsStyle.achievementsAppBarTextStyle),
                        automaticallyImplyLeading: false,
                        actions: [
                          IconButton(
                            iconSize: 32,
                            icon: Image.asset("assets/close_icon.png"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                        pinned: true,
                        floating: true,
                        backgroundColor:
                            AchievementsStyle.achievementScreenBackgroundColor,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.23,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(children: [
                            const Expanded(child: SizedBox(), flex: 3),
                            Expanded(
                                child: Stack(children: [
                                  Positioned(
                                      bottom: 0,
                                      child: SvgPicture.asset(
                                          "assets/achievements/dotted_line_ach.svg",
                                          width: MediaQuery.of(context)
                                              .size
                                              .width)),
                                  Column(children: [
                                    Expanded(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(children: [
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05),
                                                avatarImage(context,
                                                    tutorialState, emotionsSate)
                                              ]),
                                              Row(children: [
                                                getNewAchievementsComponent(
                                                    achievementsState, context),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.1)
                                              ])
                                            ]),
                                        flex: 25),
                                    const Expanded(child: SizedBox(), flex: 1)
                                  ])
                                ]),
                                flex: 5),
                          ]),
                        ),
                      )
                    ],
                    body: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      children: achievementsState
                          .getAchievements()
                          .map((achievement) {
                        return Column(
                          children: [
                            Expanded(
                                child: EggWidget(
                                    achievement: achievement,
                                    achievementsState: achievementsState),
                                flex: 10),
                            const Expanded(child: SizedBox(), flex: 1),
                            Expanded(
                                child: Text(achievement.title,
                                    style: AchievementsStyle
                                        .achievementsTitleTextStyle),
                                flex: 2)
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  backgroundColor:
                      AchievementsStyle.achievementScreenBackgroundColor,
                )));
  }

  Widget getNewAchievementsComponent(
      AchievementsState achievementsState, BuildContext context) {
    var completedAchievementsCount =
        achievementsState.getCompletedAchievementsCount();
    return completedAchievementsCount > 0
        ? Column(children: [
            Expanded(
                child: Stack(children: [
                  SvgPicture.asset(
                      "assets/achievements/new_origami_text/new_origami_text_${completedAchievementsCount % 13}.svg")
                ]),
                flex: 2),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Expanded(
                child: SvgPicture.asset("assets/achievements/broken_egg.svg"),
                flex: 2),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Expanded(
                child: InkWell(
                    child: SvgPicture.asset(
                        "assets/achievements/origami_collect_button.svg"),
                    onTap: () {
                      AchievementSnapshot achievement =
                          achievementsState.getCompletedAchievement();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AchievementDetailsScreen(
                                  achievementSnapshot: achievement,
                                  details: achievementsState
                                      .getDetailsWidget(achievement.id))));
                      if (achievement.status == AchievementStatus.completed) {
                        achievementsState.updateAchievementSnapshot(
                            AchievementSnapshot.updateStatus(achievement,
                                AchievementStatus.completedAndShown));
                      }
                    }),
                flex: 1)
          ])
        : Text("Gain\nachievements\nby reaching\nyour goals",
            style: AchievementsStyle.achievementsDescriptionTextStyle,
            textAlign: TextAlign.center);
  }

  Image avatarImage(BuildContext context, TutorialState tutorialState,
      EmotionsState emotionsState) {
    var avatarPath = Utils.resolveEmotionedAvatar(tutorialState, emotionsState);
    return Image.asset(key: ValueKey(avatarPath), avatarPath);
  }
}
