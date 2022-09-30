import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../assets/constants.dart';

class TaskDifficultyWidget extends StatefulWidget {
  final void Function(int?)? callback;
  final int? initialDifficulty;
  const TaskDifficultyWidget(
      {Key? key, required this.callback, this.initialDifficulty})
      : super(key: key);

  @override
  State<TaskDifficultyWidget> createState() {
    return _TaskDifficultyWidgetState(callback);
  }
}

class _TaskDifficultyWidgetState extends State<TaskDifficultyWidget> {
  final void Function(int?)? callback;
  _TaskDifficultyWidgetState(this.callback);
  int? _currentDifficulty;

  @override
  void initState() {
    super.initState();
    _currentDifficulty = widget.initialDifficulty ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: double.infinity,
      activeBgColor: const [selectedToggleColor],
      activeFgColor: Colors.white,
      inactiveBgColor: unselectedToggleColor,
      inactiveFgColor: activeButtonColor,
      initialLabelIndex: _currentDifficulty,
      dividerColor: selectedToggleColor,
      totalSwitches: 3,
      cornerRadius: 5,
      labels: [
        Difficulty.EASY.name,
        Difficulty.MEDIUM.name,
        Difficulty.HARD.name
      ],
      onToggle: (index) {
        setState(() {
          _currentDifficulty = index;
        });
        callback?.call(_currentDifficulty);
      },
    );
  }
}
