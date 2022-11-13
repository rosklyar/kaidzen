import 'package:flutter/material.dart';

class Story extends StatelessWidget {
  final RichText text;
  final Image backgroundImage;

  const Story({super.key, required this.text, required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: backgroundImage.image,
          fit: BoxFit.fill,
        )),
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Column(children: [
          const Expanded(child: SizedBox(), flex: 1),
          Expanded(
              child: Stack(children: [
                Column(children: [
                  Align(alignment: Alignment.topLeft, child: text)
                ])
              ]),
              flex: 6)
        ]));
  }
}
