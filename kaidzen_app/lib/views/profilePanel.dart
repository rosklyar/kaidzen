import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:kaidzen_app/service/ProgressState.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ProfilePanel extends StatefulWidget {
  const ProfilePanel({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  ProfilePanelState createState() => ProfilePanelState(name);
}

class ProfilePanelState extends State<ProfilePanel> {
  ProfilePanelState(this.name);
  String name;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressState>(
        builder: (context, state, child) => Row(
              children: [
                Expanded(
                    child: Column(children: [
                      const Icon(
                        Icons.person,
                        size: 100.0,
                        color: Colors.grey,
                      ),
                      Text(
                        '${state.getTotalLevel()} LEVEL',
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
                                  ProgressIndicator(
                                      percent: state.getValue(
                                          DevelopmentCategory
                                              .CAREER_AND_FINANCES),
                                      level: state.getLevel(DevelopmentCategory
                                          .CAREER_AND_FINANCES),
                                      title: DevelopmentCategory
                                          .CAREER_AND_FINANCES.name,
                                      progressColor: DevelopmentCategory
                                          .CAREER_AND_FINANCES.color),
                                  ProgressIndicator(
                                      percent: state.getValue(
                                          DevelopmentCategory
                                              .PERSONAL_DEVELOPMENT),
                                      level: state.getLevel(DevelopmentCategory
                                          .PERSONAL_DEVELOPMENT),
                                      title: DevelopmentCategory
                                          .PERSONAL_DEVELOPMENT.name,
                                      progressColor: DevelopmentCategory
                                          .PERSONAL_DEVELOPMENT.color),
                                  ProgressIndicator(
                                      percent: state.getValue(
                                          DevelopmentCategory.RELATIONSHIPS),
                                      level: state.getLevel(
                                          DevelopmentCategory.RELATIONSHIPS),
                                      title: DevelopmentCategory
                                          .RELATIONSHIPS.name,
                                      progressColor: DevelopmentCategory
                                          .RELATIONSHIPS.color),
                                ],
                              ),
                              flex: 5),
                          Expanded(
                              child: Column(
                                children: [
                                  ProgressIndicator(
                                      percent: state
                                          .getValue(DevelopmentCategory.HEALTH),
                                      level: state
                                          .getLevel(DevelopmentCategory.HEALTH),
                                      title: DevelopmentCategory.HEALTH.name,
                                      progressColor:
                                          DevelopmentCategory.HEALTH.color),
                                  ProgressIndicator(
                                      percent: state.getValue(
                                          DevelopmentCategory.LEISURE),
                                      level: state.getLevel(
                                          DevelopmentCategory.LEISURE),
                                      title: DevelopmentCategory.LEISURE.name,
                                      progressColor:
                                          DevelopmentCategory.LEISURE.color),
                                  const SizedBox(height: 25.0),
                                ],
                              ),
                              flex: 5)
                        ],
                      )
                    ]),
                    flex: 7)
              ],
            ));
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator(
      {Key? key,
      required this.percent,
      required this.level,
      required this.title,
      required this.progressColor})
      : super(key: key);

  final double percent;
  final int level;
  final String title;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: LinearPercentIndicator(
        lineHeight: 15.0,
        percent: percent,
        center:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            " $title",
            style: const TextStyle(fontSize: 8.0),
          ),
          Text(
            "LVL $level",
            style: const TextStyle(fontSize: 8.0),
          ),
        ]),
        barRadius: const Radius.circular(3.0),
        backgroundColor: Colors.white,
        progressColor: progressColor,
      ),
    );
  }
}
