import 'dart:developer';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/HabitState.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:kaidzen_app/views/boardSection.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../service/AnalyticsService.dart';
import '../widgets/switchableBoardsToggle.dart';

class SwitchableBoard extends StatefulWidget {
  const SwitchableBoard({Key? key}) : super(key: key);

  @override
  SwitchableBoardState createState() => SwitchableBoardState();
}

class SwitchableBoardState extends State<SwitchableBoard> {
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
            panel: Stack(children: [
              SizedBox(
                  //width: parentWidth,
                  //height: parentHeight,
                  child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 50.0,
                    sigmaY: 50.0,
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
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Consumer2<TasksState, HabitState>(
                              builder: (context, taskState, habitState, child) {
                            return Board(
                                board: currentBoard,
                                tasks: taskState.getByStatus(currentBoard.name),
                                habits:
                                    habitState.getByStatus(currentBoard.name),
                                sc: sc,
                                scrollEnabled: scrollEnabled);
                          }),
                        ),
                        flex: 10,
                      ),
                      Expanded(
                          child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('Collapse',
                                    style: Fonts.graySubtitleMedium.copyWith(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600)),
                              ),
                              onTap: () async {
                                pc.close();
                                await FirebaseAnalytics.instance.logEvent(
                                    name: AnalyticsEventType
                                        .collapse_button_pressed.name);
                              }),
                          flex: 1)
                    ],
                  ),
                ),
              )),
            ])),
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
