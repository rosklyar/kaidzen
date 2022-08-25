import 'dart:ui';

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
    Status.TODO,
    Status.DOING,
    Status.DONE,
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Stack(children: [
          Positioned(
              child: Image.asset("assets/mountains.png",
                  width: MediaQuery.of(context).size.width),
              top: 0),
          Padding(
              padding: const EdgeInsets.only(top: 75),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20.0,
                    sigmaY: 20.0,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ToggleSwitch(
                          fontSize: 18,
                          minWidth: double.infinity,
                          cornerRadius: 30.0,
                          radiusStyle: true,
                          minHeight: 50.0,
                          activeBgColor: const [selectedToggleColor],
                          activeFgColor: Colors.white,
                          inactiveBgColor: unselectedToggleColor.withOpacity(0),
                          inactiveFgColor: Colors.black,
                          initialLabelIndex: 1,
                          totalSwitches: 3,
                          labels: const [
                            Status.TODO,
                            Status.DOING,
                            Status.DONE
                          ],
                          onToggle: (index) {
                            _switchableBoardContainerKey.currentState
                                ?.changeBoard(_boards[index!]);
                          },
                        ),
                      ),
                      Consumer<TasksState>(
                          builder: (context, state, child) =>
                              SwitchableBoardContainer(state,
                                  key: _switchableBoardContainerKey))
                    ],
                  ),
                ),
              ))
        ])));
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
  late String currentBoard = Status.DOING;
  final GlobalKey<BoardState> _doBoardKey = GlobalKey();
  final GlobalKey<BoardState> _doingBoardKey = GlobalKey();
  final GlobalKey<BoardState> _doneBoardKey = GlobalKey();
  final Map<String, GlobalKey<BoardState>> states = {};

  @override
  void initState() {
    setState(() {
      states.putIfAbsent(Status.TODO, () => _doBoardKey);
      states.putIfAbsent(Status.DOING, () => _doingBoardKey);
      states.putIfAbsent(Status.DONE, () => _doneBoardKey);
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
        list: widget.tasksState.getByStatus(currentBoard));
  }
}
