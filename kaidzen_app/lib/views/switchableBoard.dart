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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Scrollbar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ToggleSwitch(
                    cornerRadius: 10.0,
                    radiusStyle: true,
                    minHeight: 50.0,
                    activeBgColor: [Colors.grey],
                    activeFgColor: Colors.black,
                    inactiveBgColor: Colors.white,
                    inactiveFgColor: Colors.black,
                    customWidths: [130.0, 130.0, 130.0],
                    initialLabelIndex: 0,
                    totalSwitches: 3,
                    labels: const [Boards.DO, Boards.DOING, Boards.DONE],
                    onToggle: (index) {
                      _switchableBoardContainerKey.currentState
                          ?.changeBoard(_boards[index!]);
                    },
                  ),
                ),
              ),
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
  final GlobalKey<BoardState> _doBoardKey = GlobalKey();
  final GlobalKey<BoardState> _doingBoardKey = GlobalKey();
  final GlobalKey<BoardState> _doneBoardKey = GlobalKey();
  final Map<String, Board> boards = {};
  final Map<String, GlobalKey<BoardState>> states = {};

  @override
  void initState() {
    setState(() {
      boards;
      states;
      boards.putIfAbsent(
          Boards.DO, () => Board(key: _doBoardKey, name: Boards.DO, list: []));
      boards.putIfAbsent(Boards.DOING,
          () => Board(key: _doingBoardKey, name: Boards.DOING, list: []));
      boards.putIfAbsent(Boards.DONE,
          () => Board(key: _doneBoardKey, name: Boards.DONE, list: []));

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
      currentBoard = board;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: boards[currentBoard]!,
    );
  }
}
