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
                      backgroundImage:
                          Image.asset("assets/settings/philosophy/1.png"),
                      backgroundColor: DevelopmentCategory.ENERGY.color,
                      title: "Set a life mission",
                      text:
                          "You need to find time and calm environment to identify your life mission\n\nIt could be something that describe you, your strives and dreams.\n\nLets imagine that it could be smth general in the begining:\n\n\"I want to live happy life providing benefits to society and environment\""),
                  duration: const Duration(seconds: 3)),
              StoryItem(
                  Story(
                      backgroundImage:
                          Image.asset("assets/settings/philosophy/2.png"),
                      backgroundColor: DevelopmentCategory.HEALTH.color,
                      title: "Clear your mind",
                      text:
                          "Write down all your goals and dreams. You need to write literally everything so nothing will stay in your mind."),
                  duration: const Duration(seconds: 3)),
              StoryItem(
                  Story(
                      backgroundImage:
                          Image.asset("assets/settings/philosophy/3.png"),
                      backgroundColor: DevelopmentCategory.MIND.color,
                      title: "Choose spheres to affect",
                      text:
                          "Split your goals by 5 spheres — Wealth, Energy, Health, Mind, and Relations."),
                  duration: const Duration(seconds: 3)),
            ],
            progressPosition: ProgressPosition.top,
            repeat: true,
            inline: true));
  }
}
