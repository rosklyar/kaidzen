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
                                child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder()),
                              child: const Icon(Icons.add),
                              onPressed: () {},
                            ))),
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: Center(
                                child: CircularProgressIndicator(
                              value: achievement.progress,
                              color: Colors.red,
                            )))
                      ]),
                      Text(achievement.title)
                    ],
                  );
                }).toList(),
              ),
            ));
  }
}
