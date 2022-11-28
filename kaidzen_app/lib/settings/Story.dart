import 'package:flutter/material.dart';

class Story extends StatelessWidget {
  final RichText text;
  Image? backgroundImage;
  final Color backgroundColor;

  Story(
      {super.key,
      required this.text,
      this.backgroundImage,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundColor,
        child: Column(children: [
          const Expanded(child: SizedBox(), flex: 1),
          Expanded(
              child: Stack(children: [
                backgroundImage != null
                    ? Positioned(child: backgroundImage!, bottom: 0)
                    : const SizedBox(),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Align(alignment: Alignment.topLeft, child: text))
              ]),
              flex: 5)
        ]));
  }
}
