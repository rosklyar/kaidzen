import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfilePanel extends StatefulWidget {
  const ProfilePanel(
      {Key? key,
      required this.name,
      required this.level,
      required this.progressMap})
      : super(key: key);

  final String name;
  final int level;
  final Map<Category, Progress> progressMap;

  @override
  ProfilePanelState createState() =>
      ProfilePanelState(name, level, progressMap);
}

class ProfilePanelState extends State<ProfilePanel> {
  ProfilePanelState(this.name, this.level, this.progressMap);
  String name;
  int level;
  Map<Category, Progress> progressMap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(children: [
              const Icon(
                Icons.person,
                size: 100.0,
                color: Colors.grey,
              ),
              Text(
                '$level LEVEL',
                style: const TextStyle(fontSize: 20.0),
              ),
            ]),
            flex: 3),
        Expanded(
            child: Column(children: [
              SizedBox(
                height: 25.0,
                width: 300.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.surfing, size: 20.0, color: Colors.grey),
                    Icon(Icons.subject, size: 20.0, color: Colors.grey)
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                        children: [
                          progressIndicator(Category.CAREER_AND_FINANCES),
                          progressIndicator(Category.PERSONAL_DEVELOPMENT),
                          progressIndicator(Category.RELATIONSHIPS)
                        ],
                      ),
                      flex: 5),
                  Expanded(
                      child: Column(
                        children: [
                          progressIndicator(Category.HEALTH),
                          progressIndicator(Category.LEISURE),
                          const SizedBox(height: 25.0),
                        ],
                      ),
                      flex: 5)
                ],
              )
            ]),
            flex: 7)
      ],
    );
  }

  Padding progressIndicator(Category category) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: LinearPercentIndicator(
        lineHeight: 15.0,
        percent: progressMap[category]!.value,
        center:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            " ${category.name}",
            style: const TextStyle(fontSize: 8.0),
          ),
          Text(
            "LVL ${progressMap[category]!.level} ",
            style: const TextStyle(fontSize: 8.0),
          ),
        ]),
        barRadius: const Radius.circular(3.0),
        backgroundColor: Colors.white,
        progressColor: Colors.grey,
      ),
    );
  }
}
