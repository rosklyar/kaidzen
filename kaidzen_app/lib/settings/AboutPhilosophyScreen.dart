import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';
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
                StoryItem.text(
                    title: DevelopmentCategory.ENERGY.name,
                    backgroundColor: DevelopmentCategory.ENERGY.color),
                StoryItem.text(
                    title: DevelopmentCategory.HEALTH.name,
                    backgroundColor: DevelopmentCategory.HEALTH.color),
                StoryItem.text(
                  title: DevelopmentCategory.MIND.name,
                  backgroundColor: DevelopmentCategory.MIND.color,
                ),
                StoryItem.text(
                  title: DevelopmentCategory.RELATIONS.name,
                  backgroundColor: DevelopmentCategory.RELATIONS.color,
                ),
                StoryItem.text(
                  title: DevelopmentCategory.WEALTH.name,
                  backgroundColor: DevelopmentCategory.WEALTH.color,
                )
              ],
              onStoryShow: (s) {},
              onComplete: () {},
              progressPosition: ProgressPosition.top,
              repeat: true,
              inline: true),
          flex: 1)
    ]));
  }
}
