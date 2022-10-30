import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Column(children: [
          const Expanded(child: SizedBox(), flex: 1),
          Expanded(
              child: Stack(children: [
                Positioned(bottom: 0, child: backgroundImage),
                Center(child: text)
              ]),
              flex: 6)
        ]));
  }
}
