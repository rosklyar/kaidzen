import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/service/AchievementsState.dart';
import 'package:provider/provider.dart';

import '../models/achievement.dart';

class Achievements extends StatelessWidget {
  const Achievements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementsState>(
        builder: (context, achievementsState, child) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title:
                    const Text('Achievements', style: TextStyle(fontSize: 12)),
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
                                child: Card(
                                    elevation: 4.0,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(150),
                                    ),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                          width: 60,
                                          height: 60,
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: achievement.progress >= 1.0
                                              ? Image.asset(
                                                  "assets/sets/${achievement.setId}/${achievement.iconName}")
                                              : const Icon(
                                                  Icons.question_answer)),
                                    )))),
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: Center(
                                child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      value: achievement.progress,
                                      color: Colors.green,
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
