import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/achievementDetailsScreen.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:provider/provider.dart';

import 'achievementSnaphot.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementsState>(
        builder: (context, achievementsState, child) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Achievements', style: largeTextStyle),
              ),
              body: GridView.count(
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
                                      backgroundColor: Colors.grey,
                                      color: Colors.green,
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
                                              .achievementsRepository
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
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: achievement.status !=
                                                  AchievementStatus.notCompleted
                                              ? Image.asset(
                                                  "assets/sets/${achievement.setId}/${achievement.iconName}")
                                              : const Icon(
                                                  Icons.question_answer)),
                                    ))))
                      ]),
                      Text(achievement.title)
                    ],
                  );
                }).toList(),
              ),
            ));
  }
}
