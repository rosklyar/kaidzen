import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/settings/Story.dart';
import 'package:story_view/story_view.dart';

class AboutPhilosophyScreen extends StatelessWidget {
  final StoryController controller = StoryController();

  AboutPhilosophyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
          child: StoryView(
              controller: controller,
              storyItems: [
                StoryItem(
                    Story(
                        backgroundImage: Image.asset("assets/mountains.png"),
                        backgroundColor: DevelopmentCategory.ENERGY.color,
                        text: Text(
                            "The idea is to aim for small and consistent growth.",
                            style: Fonts.screenTytleTextStyle)),
                    duration: const Duration(seconds: 3)),
                StoryItem(
                    Story(
                        backgroundImage: Image.asset("assets/mountains.png"),
                        backgroundColor: DevelopmentCategory.HEALTH.color,
                        text: Text("Set life mission",
                            style: Fonts.screenTytleTextStyle)),
                    duration: const Duration(seconds: 3)),
                StoryItem(
                    Story(
                        backgroundImage: Image.asset("assets/mountains.png"),
                        backgroundColor: DevelopmentCategory.MIND.color,
                        text: Text("Clear your mind",
                            style: Fonts.screenTytleTextStyle)),
                    duration: const Duration(seconds: 3)),
              ],
              progressPosition: ProgressPosition.top,
              repeat: true,
              inline: true,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              }),
          flex: 1)
    ]));
  }
}
