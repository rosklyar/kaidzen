import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:kaidzen_app/service/ProgressState.dart';
import 'package:kaidzen_app/views/achievements.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ProfilePanel extends StatefulWidget {
  const ProfilePanel({Key? key}) : super(key: key);

  @override
  ProfilePanelState createState() => ProfilePanelState();
}

class ProfilePanelState extends State<ProfilePanel> {
  ProfilePanelState();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressState>(
        builder: (context, progressState, child) => Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                    child: Stack(children: [
                      const Icon(
                        Icons.circle,
                        size: 130.0,
                        color: Colors.grey,
                      ),
                      Positioned(
                          top: 0.0,
                          left: 70.0,
                          right: 10.0,
                          bottom: 80.0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.grey),
                              shape: BoxShape.circle,
                              // You can use like this way or like the below line
                              //borderRadius: new BorderRadius.circular(30.0),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(progressState.getTotalLevel().toString(),
                                    style: const TextStyle(fontSize: 12)),
                                const Text('LVL', style: TextStyle(fontSize: 8))
                              ],
                            ),
                          )),
                    ]),
                    flex: 4),
                Expanded(
                    child: Column(children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Achievements()));
                            },
                            child: const Icon(
                              Icons.surfing,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.subject,
                              size: 30, color: Colors.grey)
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                                children: [
                                  ProgressIndicator(
                                      percent: progressState
                                          .getLevelProgressFraction(
                                              DevelopmentCategory.MIND),
                                      level: progressState
                                          .getLevel(DevelopmentCategory.MIND),
                                      title: DevelopmentCategory.MIND.name,
                                      progressColor:
                                          DevelopmentCategory.MIND.color),
                                  ProgressIndicator(
                                      percent: progressState
                                          .getLevelProgressFraction(
                                              DevelopmentCategory.HEALTH),
                                      level: progressState
                                          .getLevel(DevelopmentCategory.HEALTH),
                                      title: DevelopmentCategory.HEALTH.name,
                                      progressColor:
                                          DevelopmentCategory.HEALTH.color),
                                  ProgressIndicator(
                                      percent: progressState
                                          .getLevelProgressFraction(
                                              DevelopmentCategory.ENERGY),
                                      level: progressState
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
                                      percent: progressState
                                          .getLevelProgressFraction(
                                              DevelopmentCategory.WEALTH),
                                      level: progressState
                                          .getLevel(DevelopmentCategory.WEALTH),
                                      title: DevelopmentCategory.WEALTH.name,
                                      progressColor:
                                          DevelopmentCategory.WEALTH.color),
                                  ProgressIndicator(
                                      percent: progressState
                                          .getLevelProgressFraction(
                                              DevelopmentCategory.RELATIONS),
                                      level: progressState.getLevel(
                                          DevelopmentCategory.RELATIONS),
                                      title: DevelopmentCategory.RELATIONS.name,
                                      progressColor:
                                          DevelopmentCategory.RELATIONS.color),
                                  const SizedBox(height: 30.0),
                                ],
                              ),
                              flex: 5)
                        ],
                      )
                    ]),
                    flex: 6)
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
            lineHeight: 6.0,
            percent: percent,
            animation: true,
            barRadius: const Radius.circular(1.0),
            backgroundColor: const Color.fromRGBO(225, 218, 218, 1.0),
            progressColor: progressColor,
          )
        ]));
  }
}
