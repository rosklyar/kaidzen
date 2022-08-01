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
        builder: (context, state, child) => Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
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
                        style: const TextStyle(fontSize: 20),
                      ),
                    ]),
                    flex: 3),
                Expanded(
                    child: Column(children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(Icons.surfing, size: 30, color: Colors.grey),
                          SizedBox(width: 10),
                          Icon(Icons.subject, size: 30, color: Colors.grey)
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                                children: [
                                  ProgressIndicator(
                                      percent: state
                                          .getValue(DevelopmentCategory.MIND),
                                      level: state
                                          .getLevel(DevelopmentCategory.MIND),
                                      title: DevelopmentCategory.MIND.name,
                                      progressColor:
                                          DevelopmentCategory.MIND.color),
                                  ProgressIndicator(
                                      percent: state
                                          .getValue(DevelopmentCategory.HEALTH),
                                      level: state
                                          .getLevel(DevelopmentCategory.HEALTH),
                                      title: DevelopmentCategory.HEALTH.name,
                                      progressColor:
                                          DevelopmentCategory.HEALTH.color),
                                  ProgressIndicator(
                                      percent: state
                                          .getValue(DevelopmentCategory.ENERGY),
                                      level: state
                                          .getLevel(DevelopmentCategory.ENERGY),
                                      title: DevelopmentCategory.ENERGY.name,
                                      progressColor:
                                          DevelopmentCategory.ENERGY.color),
                                ],
                              ),
                              flex: 5),
                          Expanded(
                              child: Column(
                                children: [
                                  ProgressIndicator(
                                      percent: state
                                          .getValue(DevelopmentCategory.WEALTH),
                                      level: state
                                          .getLevel(DevelopmentCategory.WEALTH),
                                      title: DevelopmentCategory.WEALTH.name,
                                      progressColor:
                                          DevelopmentCategory.WEALTH.color),
                                  ProgressIndicator(
                                      percent: state.getValue(
                                          DevelopmentCategory.RELATIONS),
                                      level: state.getLevel(
                                          DevelopmentCategory.RELATIONS),
                                      title: DevelopmentCategory.RELATIONS.name,
                                      progressColor:
                                          DevelopmentCategory.RELATIONS.color),
                                  const SizedBox(height: 35.0),
                                ],
                              ),
                              flex: 5)
                        ],
                      )
                    ]),
                    flex: 7)
              ],
            )));
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
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      " $title",
                      style: const TextStyle(fontSize: 12),
                    ),
                    Row(children: [
                      const Text(
                        "LVL   ",
                        style: TextStyle(fontSize: 7),
                      ),
                      Text(
                        "$level",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ]),
                  ])),
          LinearPercentIndicator(
            lineHeight: 7.0,
            percent: percent,
            animation: true,
            barRadius: const Radius.circular(3.0),
            backgroundColor: const Color.fromRGBO(225, 218, 218, 1.0),
            progressColor: progressColor,
          )
        ]));
  }
}
