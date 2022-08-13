import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/achievementSnaphot.dart';
import 'package:kaidzen_app/achievements/achievementStatus.dart';

import '../assets/constants.dart';

class AchievementDetailsScreen extends StatelessWidget {
  final AchievementSnapshot achievementSnapshot;

  const AchievementDetailsScreen({Key? key, required this.achievementSnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(achievementSnapshot.title, style: largeTextStyle),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Column(children: [
          Expanded(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.all(3.0),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: achievementSnapshot.status !=
                          AchievementStatus.notCompleted
                      ? Image.asset(
                          "assets/sets/${achievementSnapshot.setId}/${achievementSnapshot.iconName}")
                      : const Icon(Icons.question_answer)),
              flex: 3),
          Expanded(
              child:
                  Text(achievementSnapshot.description, style: largeTextStyle),
              flex: 1),
        ]));
  }
}
