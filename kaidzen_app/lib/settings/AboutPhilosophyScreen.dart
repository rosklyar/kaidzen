import 'package:flutter/foundation.dart';
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
          leading: IconButton(
            icon: SvgPicture.asset("assets/shevron-left-black.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          centerTitle: true,
          actions: [
            IconButton(
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
                      backgroundColor: const Color.fromRGBO(251, 245, 206, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/1.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "\n\nThe idea is to aim for small and consistent growth.\n\nYour regular efforts and progress will eventually lead to significant results.",
                              style: Fonts.screenTytleTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 20)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(241, 232, 252, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/2.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\n\nSet a life mission\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Find time and a calm environment to think about your life mission.\nSomething that describes you.\nYour strives and dreams.\nLet's imagine that it could be something general in the beginning:\n\n",
                              style: Fonts.largeTextStyle),
                          TextSpan(
                              text:
                                  "\"I want to live happy life providing benefits to society and the environment\"\n\n",
                              style: Fonts.largeTextStyle20
                                  .copyWith(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  "This mission will help you filter out everything which is essential to YOU.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 20)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(237, 248, 250, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/3.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\n\nClear your mind\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Surfing through your mind for important things you could forget and sorting them out can be very exhausting.\nYou can't even imagine how often you go through this cycle daily.\nIt consumes vast amounts of your mental energy.\n\nEmpty your mind.\nCompletely.\nWrite down everything important and throw away everything else.\n\nDo it once, and you'll save a ton of your energy.\nTurn it into a habit, and you'll enjoy how it will reshape your life.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 20)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(243, 250, 194, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/4.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\n\nFocus on your goals\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Sift everything you've written down through your life mission.\n\nIf the goal was \"buy a new car\", - is it what you truly want? \nDo you like driving?\nHow much time do you spend driving?\nWill it make you happy?\nWill it be good for the environment and society?\n\nIf you like driving, do it a lot, in your free time going to track - then definitely it will make you happy, and it's your true goal.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 20)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(252, 236, 230, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/5.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\n\nChoose spheres to affect\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text: "Split your goals by 5 spheres:\n\n",
                              style: Fonts.largeTextStyle),
                          WidgetSpan(
                              baseline: TextBaseline.alphabetic,
                              alignment: PlaceholderAlignment.baseline,
                              child: Icon(Icons.circle_rounded,
                                  color: DevelopmentCategory.WEALTH.color,
                                  size: 10.0)),
                          TextSpan(
                              text: "  Wealth\n", style: Fonts.largeTextStyle),
                          WidgetSpan(
                              baseline: TextBaseline.alphabetic,
                              alignment: PlaceholderAlignment.baseline,
                              child: Icon(Icons.circle_rounded,
                                  color: DevelopmentCategory.ENERGY.color,
                                  size: 10.0)),
                          TextSpan(
                              text: "  Energy\n", style: Fonts.largeTextStyle),
                          WidgetSpan(
                              baseline: TextBaseline.alphabetic,
                              alignment: PlaceholderAlignment.baseline,
                              child: Icon(Icons.circle_rounded,
                                  color: DevelopmentCategory.HEALTH.color,
                                  size: 10.0)),
                          TextSpan(
                              text: "  Health\n", style: Fonts.largeTextStyle),
                          WidgetSpan(
                              baseline: TextBaseline.alphabetic,
                              alignment: PlaceholderAlignment.baseline,
                              child: Icon(Icons.circle_rounded,
                                  color: DevelopmentCategory.MIND.color,
                                  size: 10.0)),
                          TextSpan(
                              text: "  Mind\n", style: Fonts.largeTextStyle),
                          WidgetSpan(
                              baseline: TextBaseline.alphabetic,
                              alignment: PlaceholderAlignment.baseline,
                              child: Icon(Icons.circle_rounded,
                                  color: DevelopmentCategory.RELATIONS.color,
                                  size: 10.0)),
                          TextSpan(
                              text: "  Relations\n",
                              style: Fonts.largeTextStyle),
                          TextSpan(
                              text:
                                  "\nSometimes your goal could match more than one sphere. In that case, choose one that you think will suit it best.",
                              style: Fonts.largeTextStyle),
                        ]),
                      )),
                  duration: const Duration(seconds: 20)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(242, 233, 252, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/6.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\n\nConsistency is the key\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "Regularly update your boards and keep them up to date.\n\nChoose a consistent period that is comfortable for you to sort everything out. Be it a morning routine with a cup of coffee or weekly revision on weekends.\n\nStick to it.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 20)),
              StoryItem(
                  Story(
                      backgroundColor: const Color.fromRGBO(251, 245, 206, 1.0),
                      backgroundImage: Image.asset(
                          "assets/settings/philosophy/7.png",
                          width: MediaQuery.of(context).size.width),
                      text: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "\n\nAnd...\n\n",
                              style: Fonts.screenTytleTextStyle),
                          TextSpan(
                              text:
                                  "It's your choice how you will develop your spheres - it's not mandatory for them to be at the same level. It's all up to you and your personal development.",
                              style: Fonts.largeTextStyle)
                        ]),
                      )),
                  duration: const Duration(seconds: 20))
            ],
            progressPosition: ProgressPosition.top,
            onComplete: () => Navigator.pop(context),
            repeat: false,
            inline: true));
  }
}
