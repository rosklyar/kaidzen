import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:kaidzen_app/views/boardSection.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../widgets/switchableBoardsToggle.dart';

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

  var currentState = Status.TODO;

  void addItem(Task newTask) {
    Provider.of<TasksState>(context, listen: false).addTask(newTask);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var parentHeight = MediaQuery.of(context).size.height;
    debugPrint("building Panel");
    return SlidingUpPanel(
      boxShadow: const <BoxShadow>[
        BoxShadow(
          blurRadius: 8.0,
          color: Color.fromRGBO(255, 255, 255, 0),
        )
      ],
      color: Colors.white.withOpacity(0),
      maxHeight: parentHeight * 0.97,
      minHeight: parentHeight * 0.68,
      panel: SizedBox(
          //width: parentWidth,
          //height: parentHeight,
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
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: SwitchableBoardsToggleWidget((value) => setState(() {
                                  currentState = toggleBoards[value!].name;
                                }), 0)
,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Consumer<TasksState>(builder: (context, state, child) {
                    debugPrint("building SwitchableBoardContainer");
                    return SwitchableBoardContainer(
                        state,
                        currentState,
                        ScrollController(),
                        key: _switchableBoardContainerKey);
                  }),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

class SwitchableBoardContainer extends StatefulWidget {
  final TasksState tasksState;
  String currentBoard;
  final ScrollController sc;

  SwitchableBoardContainer(
    this.tasksState,
    this.currentBoard,
    this.sc, {
    Key? key,
  }) : super(key: key);

  @override
  SwitchableBoardContainerState createState() =>
      SwitchableBoardContainerState();
}

class SwitchableBoardContainerState extends State<SwitchableBoardContainer> {
  void changeBoard(String board) {
    if (widget.currentBoard != board) {
      setState(() {
        widget.currentBoard = board;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("building Board" + widget.currentBoard);
    return Board(
        name: widget.currentBoard,
        list: widget.tasksState.getByStatus(widget.currentBoard),
        sc: widget.sc);
  }
}
