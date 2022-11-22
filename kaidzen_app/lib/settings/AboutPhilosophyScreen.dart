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
            title: Text(
              'Philosophy',
              style: Fonts.screenTytleTextStyle,
            )),
        body: StoryView(
            indicatorColor: Colors.black,
            controller: controller,
            storyItems: [
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(251, 245, 206, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/1.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "The idea is to aim for small and consistent growth.\n\nYour regular efforts and progress would eventually lead to significant results.",
                              style: Fonts.screenTytleTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(241, 232, 252, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/2.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Set life mission\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Find time and calm environment to think about your life mission. Something that describes you. Your strives and dreams.Lets imagine that it could be smth general in the begining:\n\n\n",
                              style: Fonts.largeTextStyle),
                          TextSpan(
                              text:
                                  "\"I want to live happy life providing benefits to society and environment\"\n\n\n",
                              style: Fonts.largeTextStyle20
                                  .copyWith(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  "This mission will help you filter out everything which is essential to YOU.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(237, 248, 250, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/3.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Clear your mind\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Surfing through your mind for important things you could forget and sorting them out can be very exuasting. You can't even imagine how many times you go through this cycle daily. It consumes huge amounts of your mental energy.\n\nEmpty your mind.\nCompletely.\nWrite down everything what is important and throw away everything else.\n\nDo it once and you'll save a ton of your energy.\nTurn it into a habit and you'l enjoy how it will reshape your life.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(243, 250, 194, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/4.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Focus on your goals\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Sift everything you've written down through you life mission initial list accordingly to your life mission.\n\n\nIf goal was \"buy a new car\" - is it what you trully want?\nDo you like driving?\nHow much time do you spend driving?\nWill it make you happy?\nWill it be good for environment and society?\n\nIf you like driving, do it a lot, in a free time going to track - then definetely it will make you happy and it's your true goal.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(252, 236, 230, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/5.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Choose spheres to affect\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Split your goals by 5 spheres:\n\u2022 Wealth\n\u2022 Energy\n\u2022 Health\n\u2022 Mind\n\u2022 Relations\n\n\nSometimes goal could be splitted by more than one sphere. In that case choose one sphere that you think will suit best for it.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(242, 233, 252, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/6.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Consistency is the key\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Choose a consistent time period that is comfortable for you.\nIt can be day or week.\n\n\nRegularly check your `Do` list and move goals to `Doing`.\nFocus to finish it during the chosen period.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(251, 245, 206, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/7.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "And...\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "It's your choice how you will develop your spheres - it's not mandatory for them to be same level.\nIt's all up to you and your personal develompent",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45))
            ],
            progressPosition: ProgressPosition.top,
            repeat: true,
            inline: true));
  }
}
