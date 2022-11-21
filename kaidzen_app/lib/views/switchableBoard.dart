import 'dart:developer';
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

  var currentBoard = toggleBoards[1];
  var scrollEnabled = false;
  var isOpen = false;
  final pc = PanelController();
  void addItem(Task newTask) {
    Provider.of<TasksState>(context, listen: false).addTask(newTask);
  }

  @override
  void initState() {
    super.initState();
    var taskState = Provider.of<TasksState>(context, listen: false);

    var countInDoing = taskState.getCountByStatus(toggleBoards[1].name);
    currentBoard = countInDoing == 0 ? toggleBoards[0] : toggleBoards[1];
  }

  @override
  Widget build(BuildContext context) {
    var parentHeight = MediaQuery.of(context).size.height;
    debugPrint("building Panel");
    var sc = ScrollController();
    return Stack(
      children: [
        SlidingUpPanel(
          controller: pc,
          onPanelClosed: () {
            if (scrollEnabled) {
              setState(() {
                isOpen = false;
                scrollEnabled = false;
              });
            }
            sc.animateTo(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          },
          onPanelOpened: () {
            if (!scrollEnabled) {
              setState(() {
                isOpen = true;
                scrollEnabled = true;
              });
            }
          },
          boxShadow: const <BoxShadow>[
            BoxShadow(
              blurRadius: 8.0,
              color: Color.fromRGBO(255, 255, 255, 0),
            )
          ],
          color: Colors.white.withOpacity(0),
          maxHeight: parentHeight * 0.95,
          minHeight: parentHeight * 0.65,
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
                    child: SwitchableBoardsToggleWidget(
                        (value) => setState(() {
                              currentBoard = toggleBoards[value!];
                            }),
                        currentBoard.id),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Consumer<TasksState>(
                          builder: (context, state, child) {
                        debugPrint("building SwitchableBoardContainer");
                        return SwitchableBoardContainer(
                            state, currentBoard, sc, pc, scrollEnabled,
                            key: _switchableBoardContainerKey);
                      }),
                    ),
                  )
                ],
              ),
            ),
          )),
        ),
        Visibility(
          visible: false, //TODO fix position to match floating button
          child: Positioned.directional(
            textDirection: Directionality.of(context),
            bottom: MediaQuery.of(context).size.height * 0.05,
            start: MediaQuery.of(context).size.width * 0.1,
            child: Visibility(
                visible: true,
                child: FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () async {
                    pc.close();
                  },
                  child: const Icon(
                    Icons.arrow_downward_outlined,
                    color: Colors.white,
                  ),
                )),
          ),
        )
      ],
    );
  }
}

class SwitchableBoardContainer extends StatefulWidget {
  final TasksState tasksState;
  ToggleBoard currentBoard;
  final ScrollController sc;
  final PanelController pc;
  final bool scrollEnabled;

  SwitchableBoardContainer(
    this.tasksState,
    this.currentBoard,
    this.sc,
    this.pc,
    this.scrollEnabled, {
    Key? key,
  }) : super(key: key);

  @override
  SwitchableBoardContainerState createState() =>
      SwitchableBoardContainerState();
}

class SwitchableBoardContainerState extends State<SwitchableBoardContainer> {
  @override
  Widget build(BuildContext context) {
    debugPrint("building Board " + widget.currentBoard.name);
    return Board(
        name: widget.currentBoard.name,
        list: widget.tasksState.getByStatus(widget.currentBoard.name),
        sc: widget.sc,
        pnc: widget.pc,
        scrollEnabled: widget.scrollEnabled);
  }
}
