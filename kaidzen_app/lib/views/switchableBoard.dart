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
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Stack(children: [
          Positioned(child: Image.asset("assets/mountains.png"), top: 0),
          Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Scrollbar(
                      child: ToggleSwitch(
                        minWidth: double.infinity,
                        cornerRadius: 10.0,
                        radiusStyle: true,
                        minHeight: 50.0,
                        activeBgColor: const [selectedToggleColor],
                        activeFgColor: Colors.white,
                        inactiveBgColor: unselectedToggleColor,
                        inactiveFgColor: Colors.black,
                        initialLabelIndex: 0,
                        totalSwitches: 3,
                        labels: const [Status.TODO, Status.DOING, Status.DONE],
                        onToggle: (index) {
                          _switchableBoardContainerKey.currentState
                              ?.changeBoard(_boards[index!]);
                        },
                      ),
                    ),
                  ),
                  Consumer<TasksState>(
                      builder: (context, state, child) =>
                          SwitchableBoardContainer(state,
                              key: _switchableBoardContainerKey))
                ],
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
  late String currentBoard = Status.TODO;
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
