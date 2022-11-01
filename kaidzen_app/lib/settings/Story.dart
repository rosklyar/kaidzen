import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';

class Story extends StatelessWidget {
  final String title;
  final String text;
  final Color backgroundColor;
  final Image backgroundImage;

  const Story(
      {super.key,
      required this.title,
      required this.text,
      required this.backgroundColor,
      required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: backgroundColor),
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Column(children: [
          const Expanded(child: SizedBox(), flex: 1),
          Expanded(
              child: Stack(children: [
                Positioned(bottom: 0, child: backgroundImage),
                Column(children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text(title, style: Fonts.screenTytleTextStyle)),
                      flex: 1),
                  Expanded(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(text, style: Fonts.largeTextStyle)),
                      flex: 8)
                ])
              ]),
              flex: 6)
        ]));
  }
}
