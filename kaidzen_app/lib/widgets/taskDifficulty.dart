import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../assets/constants.dart';

class TaskDifficultyWidget extends StatefulWidget {
  final void Function(int?)? callback;
  final int initialDifficulty;
  const TaskDifficultyWidget(
      {Key? key, required this.callback, required this.initialDifficulty})
      : super(key: key);

  @override
  State<TaskDifficultyWidget> createState() {
    // ignore: no_logic_in_create_state
    return _TaskDifficultyWidgetState(callback, initialDifficulty);
  }
}

class _TaskDifficultyWidgetState extends State<TaskDifficultyWidget> {
  final void Function(int?)? callback;
  _TaskDifficultyWidgetState(this.callback, this._currentDifficulty);
  int _currentDifficulty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: LayoutBuilder(
            builder: (context, constraints) => ToggleButtons(
                constraints: BoxConstraints.expand(
                    width: constraints.maxWidth / 3 - 5,
                    height: MediaQuery.of(context).size.height * 0.05),
                borderRadius: BorderRadius.circular(5),
                children: [
                  getDiffOptionLayout(Difficulty.EASY, _currentDifficulty == 0),
                  getDiffOptionLayout(
                      Difficulty.MEDIUM, _currentDifficulty == 1),
                  getDiffOptionLayout(Difficulty.HARD, _currentDifficulty == 2)
                ],
                isSelected: Iterable<int>.generate(3)
                    .map((e) => e == _currentDifficulty)
                    .toList(),
                onPressed: (newIndex) {
                  setState(() {
                    _currentDifficulty = newIndex;
                  });
                  callback?.call(_currentDifficulty);
                })),
        width: double.infinity);
  }

  StatelessWidget getDiffOptionLayout(Difficulty difficulty, bool selected) {
    return selected
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: selectedToggleColor,
            child: Center(
                child: Text(difficulty.name, style: Fonts.largeTextStyleWhite)))
        : Container(
            width: double.infinity,
            height: double.infinity,
            color: unselectedToggleColor,
            child: Center(
                child: Text(difficulty.name, style: Fonts.largeTextStyle)));
  }
}
