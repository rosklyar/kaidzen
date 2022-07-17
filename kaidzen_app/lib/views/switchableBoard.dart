import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:provider/provider.dart';
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
    Provider.of<TasksState>(context, listen: false).addTask(newTask);
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
            Consumer<TasksState>(
              builder: (context, state, child) => SwitchableBoardContainer(state, key: _switchableBoardContainerKey)
              )
          ],
        )));
  }
}

class SwitchableBoardContainer extends StatefulWidget {
  final TasksState tasksState;

  const SwitchableBoardContainer(
    this.tasksState, {
    Key? key,
  }) : super(key: key);

  @override
  SwitchableBoardContainerState createState() =>
      SwitchableBoardContainerState();
}

class SwitchableBoardContainerState extends State<SwitchableBoardContainer> {
  late String currentBoard = Boards.DO;
  final GlobalKey<BoardState> _doBoardKey = GlobalKey();
  final GlobalKey<BoardState> _doingBoardKey = GlobalKey();
  final GlobalKey<BoardState> _doneBoardKey = GlobalKey();
  final Map<String, GlobalKey<BoardState>> states = {};
  final Map<String, String> boardToStatus = {
    Boards.DO: Status.TODO,
    Boards.DOING: Status.DOING,
    Boards.DONE: Status.DONE,
  };

  @override
  void initState() {
    setState(() {
      states.putIfAbsent(Boards.DO, () => _doBoardKey);
      states.putIfAbsent(Boards.DOING, () => _doingBoardKey);
      states.putIfAbsent(Boards.DONE, () => _doneBoardKey);
    });
    super.initState();
  }

  void changeBoard(String board) {
    setState(() {
      currentBoard = board;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Board(
        key: states[currentBoard],
        name: currentBoard,
        list: widget.tasksState.getByStatus(boardToStatus[currentBoard]!));
  }
}
