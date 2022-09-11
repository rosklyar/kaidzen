import 'package:flutter/material.dart';

import '../style.dart';

class DetailsRowWidget extends StatelessWidget {
  final double progress;
  final Color progressColor;
  final String leadingText;
  final String centerText;
  final String? trailingText;
  final Color? trailingColor;

  const DetailsRowWidget(
      {super.key,
      required this.progress,
      required this.progressColor,
      required this.leadingText,
      required this.centerText,
      this.trailingText,
      this.trailingColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                  value: progress,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  backgroundColor: achievementDetailsBackgroundProgressColor)),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                  child: Text(leadingText,
                      style: achievementsDetailsLeadingTextStyle,
                      textAlign: TextAlign.left),
                  flex: 1),
              Expanded(
                  child: Text(centerText,
                      style: achievementsDetailsCenterTextStyle,
                      textAlign: TextAlign.center),
                  flex: 1),
              Expanded(
                  child: Text(trailingText ?? "",
                      style: TextStyle(color: trailingColor ?? Colors.white),
                      textAlign: TextAlign.right),
                  flex: 1),
            ],
          )
        ]));
  }

  static TextStyle achievementsDetailsLeadingTextStyle = const TextStyle(
      fontSize: 12,
      color: Color.fromRGBO(108, 107, 107, 1),
      fontFamily: 'Montserrat');

  static TextStyle achievementsDetailsCenterTextStyle = const TextStyle(
      fontSize: 12,
      color: Color.fromRGBO(202, 196, 196, 1),
      fontFamily: 'Montserrat');
}
