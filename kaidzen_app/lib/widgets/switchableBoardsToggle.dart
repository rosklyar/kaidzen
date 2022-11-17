import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../service/TasksState.dart';

class SwitchableBoardsToggleWidget extends StatefulWidget {
  final void Function(int?)? callback;
  final int? initialCategory;

  const SwitchableBoardsToggleWidget(
    this.callback,
    this.initialCategory, {
    Key? key,
  }) : super(key: key);
  @override
  State<SwitchableBoardsToggleWidget> createState() {
    return _SwitchableBoardsToggleWidgetState(callback);
  }
}

class _SwitchableBoardsToggleWidgetState
    extends State<SwitchableBoardsToggleWidget> {
  final void Function(int?)? callback;
  _SwitchableBoardsToggleWidgetState(this.callback);
  int? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: toggleBoards
                .map((board) => Theme(
                      data: ThemeData(canvasColor: Colors.transparent),
                      child: ChoiceChip(
                        backgroundColor: unselectedToggleColor.withOpacity(0),
                        selectedColor: Colors.black,
                        disabledColor: unselectedToggleColor.withOpacity(0),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8))),
                        label: Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(board.name,
                                            style: board.index == _value
                                                ? Fonts.xLargeWhiteTextStyle
                                                : Fonts.xLargeTextStyle),
                                      ])),
                            ),
                            Visibility(
                              visible: board == ToggleBoard.DOING,
                              child: Consumer<TasksState>(
                                builder: (context, taskState, child) => Visibility(
                                  visible: taskState.getCountByStatus(board.name) > 0,
                                  child: Positioned(
                                      top: 0,
                                      right: -2,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width * 0.05,
                                        height:
                                            MediaQuery.of(context).size.width * 0.04,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(0)),
                                        child: Center(
                                          child: Text(
                                            taskState.getCountByStatus(board.name).toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: board.index == _value
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                        selected: _value == board.index,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = board.index;
                          });
                          callback?.call(_value);
                        },
                      ),
                    ))
                .toList()));
  }
}
