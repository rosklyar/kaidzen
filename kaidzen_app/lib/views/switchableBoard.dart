import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:kaidzen_app/views/boardSection.dart';
import 'package:kaidzen_app/assets/constants.dart';

class SwitchableBoard extends StatefulWidget {
  const SwitchableBoard({Key? key}) : super(key: key);

  @override
  SwitchableBoardState createState() => SwitchableBoardState();
}

class SwitchableBoardState extends State<SwitchableBoard> {
  final GlobalKey<SwitchableBoardContainerState> _switchableBoardContainerKey =
      GlobalKey();
  final List<String> _boards = [
    Boards.DO,
    Boards.DOING,
    Boards.DONE,
  ];

  void addItem(Task newTask) {
    _switchableBoardContainerKey.currentState?.addItemToCurrentBoard(newTask);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Column(
          children: [
            ToggleSwitch(
              initialLabelIndex: 0,
              totalSwitches: 3,
              labels: const [Boards.DO, Boards.DOING, Boards.DONE],
              onToggle: (index) {
                _switchableBoardContainerKey.currentState
                    ?.changeBoard(_boards[index!]);
              },
            ),
            SwitchableBoardContainer(key: _switchableBoardContainerKey)
          ],
        )));
  }
}

class SwitchableBoardContainer extends StatefulWidget {
  const SwitchableBoardContainer({Key? key}) : super(key: key);

  @override
  SwitchableBoardContainerState createState() =>
      SwitchableBoardContainerState();
}

class SwitchableBoardContainerState extends State<SwitchableBoardContainer> {
  late String currentBoard = Boards.DO;
  final GlobalKey<BoardSectionState> _doBoardKey = GlobalKey();
  final GlobalKey<BoardSectionState> _doingBoardKey = GlobalKey();
  final GlobalKey<BoardSectionState> _doneBoardKey = GlobalKey();
  final Map<String, BoardSection> sections = {};
  final Map<String, GlobalKey<BoardSectionState>> states = {};

  @override
  void initState() {
    setState(() {
      sections;
      states;
      sections.putIfAbsent(Boards.DO, () => BoardSection(key: _doBoardKey));
      sections.putIfAbsent(
          Boards.DOING, () => BoardSection(key: _doingBoardKey));
      sections.putIfAbsent(Boards.DONE, () => BoardSection(key: _doneBoardKey));

      states.putIfAbsent(Boards.DO, () => _doBoardKey);
      states.putIfAbsent(Boards.DOING, () => _doingBoardKey);
      states.putIfAbsent(Boards.DONE, () => _doneBoardKey);
    });
    super.initState();
  }

  void addItemToCurrentBoard(Task newTask) {
    states[currentBoard]!.currentState?.addItem(newTask);
  }

  void changeBoard(String board) {
    setState(() {
      log('changeBoard board=' + board);
      currentBoard = board;
    });
  }

  @override
  Widget build(BuildContext context) {
    log('build SwitchableBoardContainerState');
    return Container(
      child: sections[currentBoard]!,
    );
  }
}
