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
      ProfilePanelState(this.name, this.level, this.progressMap);
}

class ProfilePanelState extends State<ProfilePanel> {
  ProfilePanelState(this.name, this.level, this.progressMap);
  String name;
  int level;
  Map<Category, Progress> progressMap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Row(
      children: [
        Container(
          child: Column(children: [
            Icon(
              Icons.person,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              '$level LEVEL',
              style: TextStyle(fontSize: 20.0),
            ),
          ]),
          padding: const EdgeInsets.all(10.0),
        ),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                progressIndicator(Category.CAREER_AND_FINANCES),
                progressIndicator(Category.PERSONAL_DEVELOPMENT),
                progressIndicator(Category.RELATIONSHIPS)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                progressIndicator(Category.HEALTH),
                progressIndicator(Category.LEISURE)
              ],
            )
          ],
        )
      ],
    ));
  }

  Padding progressIndicator(Category category) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: new LinearPercentIndicator(
        width: 70.0,
        lineHeight: 14.0,
        percent: this.progressMap[category]!.progress,
        center: Text(
          "${category.description}",
          style: new TextStyle(fontSize: 12.0),
        ),
        trailing: Text("LVL ${this.progressMap[category]!.level}"),
        linearStrokeCap: LinearStrokeCap.roundAll,
        backgroundColor: Colors.white,
        progressColor: Colors.grey,
      ),
    );
  }
}
