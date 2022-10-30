import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/settings/Story.dart';
import 'package:story_view/story_view.dart';

class AboutPhilosophyScreen extends StatelessWidget {
  final StoryController controller = StoryController();

  AboutPhilosophyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            centerTitle: true,
            actions: [
              IconButton(
                iconSize: 32,
                icon: SvgPicture.asset("assets/settings/close_black_icon.svg"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            backgroundColor: Colors.white.withOpacity(0),
            title: Text(
              'Philosophy',
              style: Fonts.screenTytleTextStyle,
            )),
        body: StoryView(
            controller: controller,
            storyItems: [
              StoryItem(
                  Story(
                      backgroundImage: Image.asset("assets/mountains.png"),
                      backgroundColor: DevelopmentCategory.ENERGY.color,
                      text: Text(
                          "The idea is to aim for\nsmall and consistent growth.",
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
            inline: true));
  }
}
