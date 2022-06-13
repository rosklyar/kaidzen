import 'package:flutter/material.dart';

import 'package:kaidzen_app/views/boardSection.dart';

class SwitchableBoard extends StatefulWidget {
  const SwitchableBoard({Key? key}) : super(key: key);

  @override
  SwitchableBoardState createState() => SwitchableBoardState();
}

class SwitchableBoardState extends State<SwitchableBoard> {
  final Map<String, BoardSection> sections = {};
  final doLabel = "Do";
  final doingLabel = "Doing";
  final doneLabel = "Done";
  late String currentBoard = doLabel;

  @override
  void initState() {
    setState(() {
      sections;
      sections.putIfAbsent(doLabel, () => BoardSection(GlobalKey()));
      sections.putIfAbsent(doingLabel, () => BoardSection(GlobalKey()));
      sections.putIfAbsent(doneLabel, () => BoardSection(GlobalKey()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: sections[currentBoard],
    );
  }
}
