import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/settings/Story.dart';
import 'package:story_view/story_view.dart';

import '../main.dart';

class AboutPhilosophyScreen extends StatelessWidget {
  final StoryController controller = StoryController();

  AboutPhilosophyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
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
                      backgroundImage:
                          Image.asset("assets/settings/philosophy/1.png"),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "\nThe idea is to aim for small and consistent growth.\n\nYour regular efforts and progress will eventually lead to significant results.",
                              style: Fonts.screenTytleTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundImage:
                          Image.asset("assets/settings/philosophy/2.png"),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nSet life mission\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Find time and a calm environment to think about your life mission. Something that describes you. Your strives and dreams. Let's imagine that it could be smth general in the beginning:\n\n\n",
                              style: Fonts.largeTextStyle),
                          TextSpan(
                              text:
                                  "\"I want to live happy life providing benefits to society and the environment\"\n\n\n",
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
                      backgroundImage:
                          Image.asset("assets/settings/philosophy/3.png"),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nClear your mind\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Surfing through your mind for important things you could forget and sorting them out can be very exhausting. You can't even imagine how often you go through this cycle daily. It consumes huge amounts of your mental energy.\n\nEmpty your mind.\nCompletely.\nWrite down everything that is important and throw away everything else.\n\nDo it once, and you'll save a ton of your energy.\nTurn it into a habit, and you'll enjoy how it will reshape your life.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundImage:
                          Image.asset("assets/settings/philosophy/4.png"),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nFocus on your goals\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Sift everything you've written down through your life mission.\n\n\nIf a goal was \"buy a new car\" - is it what you truly want?\nDo you like driving?\nHow much time do you spend driving?\nWill it make you happy?\nWill it be good for the environment and society?\n\nIf you like driving, do it a lot, in your free time going to track - then definitely it will make you happy, and it's your true goal.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundImage:
                          Image.asset("assets/settings/philosophy/5.png"),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nChoose spheres to affect\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Split your goals by 5 spheres:\n\u2022 Wealth\n\u2022 Energy\n\u2022 Health\n\u2022 Mind\n\u2022 Relations\n\n\nSometimes your goal could match more than one sphere. In that case, choose one sphere that you think will suit it best.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundImage:
                          Image.asset("assets/settings/philosophy/6.png"),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nConsistency is the key\n\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Regularly update your boards and keep them up to date.\n\nChoose a consistent period that is comfortable for you to sort everything out. Be it a morning routine with a cup of coffee or weekly revision on weekends. \nStick to it.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 45)),
              StoryItem(
                  Story(
                      backgroundImage:
                          Image.asset("assets/settings/philosophy/7.png"),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\nAnd...\n\n\n",
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
