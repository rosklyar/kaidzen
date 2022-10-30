import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/settings/SettingsScreen.dart';

class Story extends StatelessWidget {
  final Text text;
  final Color backgroundColor;
  final Image backgroundImage;

  const Story(
      {super.key,
      required this.text,
      required this.backgroundColor,
      required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: backgroundColor),
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 30,
        ),
        child: Column(children: [
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    CircleAvatar(
                        backgroundColor: Colors.black,
                        foregroundImage:
                            Image.asset("assets/settings/story_dragon.png")
                                .image),
                    const SizedBox(width: 2),
                    Text("Philosophy", style: Fonts.xLargeTextStyle)
                  ]),
                  const SizedBox()
                ],
              ),
              flex: 1),
          Expanded(
              child: Stack(children: [
                Positioned(bottom: 0, child: backgroundImage),
                text
              ]),
              flex: 9),
        ]));
  }
}
