import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/achievementDetailsScreen.dart';
import 'package:kaidzen_app/achievements/style.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:provider/provider.dart';

import 'achievementSnaphot.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementsState>(
        builder: (context, achievementsState, child) => Scaffold(
            backgroundColor: achievementScreenBackgroundColor,
            appBar: AppBar(
              backgroundColor: achievementScreenBackgroundColor,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: const Text('Achievements',
                  style: achievementsAppBarTextStyle),
              actions: <Widget>[
                IconButton(
                  icon: Image.asset("assets/close_icon.png"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            body: Container(
              color: achievementScreenBackgroundColor,
              child: GridView.count(
                crossAxisCount: 3,
                children:
                    achievementsState.getAchievements().map((achievement) {
                  return Column(
                    children: [
                      Stack(children: [
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: Center(
                                child: SizedBox(
                                    width: 65,
                                    height: 65,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 4,
                                      value: achievement.progress,
                                      backgroundColor:
                                          notCompletedAchievementScreenBackgroundColor,
                                      color:
                                          notCompletedAchievementProgressColor,
                                    )))),
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: Center(
                                child: Card(
                                    elevation: 4.0,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AchievementDetailsScreen(
                                                        achievementSnapshot:
                                                            achievement)));
                                        if (achievement.status ==
                                            AchievementStatus.completed) {
                                          achievementsState
                                              .updateAchievementSnapshot(
                                                  AchievementSnapshot.updateStatus(
                                                      achievement,
                                                      AchievementStatus
                                                          .completedAndShown));
                                        }
                                      },
                                      child: Container(
                                          width: 60,
                                          height: 60,
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 4,
                                                  color:
                                                      achievementScreenBackgroundColor),
                                              shape: BoxShape.circle,
                                              color:
                                                  notCompletedAchievementScreenBackgroundColor),
                                          child: achievement.status !=
                                                  AchievementStatus.notCompleted
                                              ? Image.asset(
                                                  "assets/sets/${achievement.setId}/${achievement.iconName}")
                                              : Image.asset(
                                                  "assets/locked-achievement.png")),
                                    ))))
                      ]),
                      Text(achievement.title, style: achievementsTitleTextStyle)
                    ],
                  );
                }).toList(),
              ),
            )));
  }
}
