import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/settings/Story.dart';
import 'package:story_view/story_view.dart';

class SpheresExplanationScreen extends StatelessWidget {
  final StoryController controller = StoryController();

  SpheresExplanationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.095,
          leading: IconButton(
            iconSize: 32,
            icon: SvgPicture.asset("assets/shevron-left-black.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          centerTitle: true,
          actions: [
            IconButton(
              iconSize: 32,
              icon: SvgPicture.asset("assets/settings/close_black_icon.svg"),
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
            )
          ],
          backgroundColor: Colors.white.withOpacity(0),
        ),
        body: StoryView(
            indicatorColor: Colors.black,
            controller: controller,
            storyItems: [
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromARGB(255, 182, 178, 157),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "\nYou are the main character of you own game of Life.\n\nEach decision you make, each goal you achieve\nhave a positive impact of one of your character's traits.",
                              style: Fonts.screenTytleTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor:
                          Color(DevelopmentCategory.MIND.backgroundColor),
                      backgroundImage: Image.asset(
                          "assets/settings/spheres/2.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nMind\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Increases your ability to focus, learn new skills, improve existing ones, understand complex concepts, unveil hidden senses\n\nRead, learn, explore, try something new, and be curious; there is so much interesting around!",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor:
                          Color(DevelopmentCategory.HEALTH.backgroundColor),
                      backgroundImage: Image.asset(
                          "assets/settings/spheres/3.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nHealth\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Improves you overall physical wellbeing, performance in different kind of activities, ability to concentrate, restore and having a good sleep.\n\nStay active, build beneficial habits, fight bad ones, master your sleep, don't stop.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor:
                          Color(DevelopmentCategory.ENERGY.backgroundColor),
                      backgroundImage: Image.asset(
                          "assets/settings/spheres/4.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nEnergy\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Increases your capacity to perform in all areas of your life.\n\nKeep your battery charged by building clean and comfortable environment in which you would strive. Remove all disruptions and stresses and simply have fun!",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor:
                          Color(DevelopmentCategory.RELATIONS.backgroundColor),
                      backgroundImage: Image.asset(
                          "assets/settings/spheres/5.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nRelations\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Increases your ability to build new social connections, strengthen existing ones. Improves you empathy. Increase overall level of happiness, and not only yours.\n\nYour friends, family and loved ones needs you attention, as well as you need theirs. Strong bonds are powerful drivers and reliable support at the same time.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor:
                          Color(DevelopmentCategory.WEALTH.backgroundColor),
                      backgroundImage: Image.asset(
                          "assets/settings/spheres/6.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nWealth\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Increases your level of freedom, provides more opportunities and open doors to new experiences. Reduces amount of stress.\n\nInvest in your professional growth and it will pay you back.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromARGB(255, 148, 209, 224),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "\nWhat if the goal relates to several shperes?\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "‘I am going to play tennis with my kid’.\n\nIs it health, energy or relations? Just choose any of them that you feel is more important for you now.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromARGB(255, 182, 178, 157),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "\nGood luck and have fun on your way to the best version of Yourself!",
                              style: Fonts.screenTytleTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45))
            ],
            progressPosition: ProgressPosition.top,
            repeat: true,
            inline: true));
  }
}
