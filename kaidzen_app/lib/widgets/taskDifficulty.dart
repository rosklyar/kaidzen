import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../assets/constants.dart';
import '../assets/light_dark_theme.dart';

class TaskDifficultyWidget extends StatefulWidget {
  final void Function(int?)? callback;
  final int initialDifficulty;
  final int categoryColor;

  const TaskDifficultyWidget({
    Key? key,
    required this.callback,
    required this.initialDifficulty,
    required this.categoryColor,
  }) : super(key: key);

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
                    height: MediaQuery.of(context).size.height * 0.045),
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

  Widget getDiffOptionLayout(Difficulty difficulty, bool selected) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    bool isDarkTheme = themeProvider.darkTheme;
    // Color iconColor = selected
    //     ? DevelopmentCategoryDark.values
    //         .firstWhere((element) => element.id == widget.categoryColor)
    //         .getBackgroundColor(isDarkTheme)
    //     : DevelopmentCategoryDark.values
    //         .firstWhere((element) => element.id == widget.categoryColor)
    //         .getBackgroundColor(isDarkTheme);

    Color categoryColorSelectedDark = DevelopmentCategoryDark.values
        .firstWhere((element) => element.id == widget.categoryColor)
        .getBackgroundColor(isDarkTheme);

    Color categoryColorSelected = widget.categoryColor >= 0
        ? DevelopmentCategoryDark.values
            .firstWhere((element) => element.id == widget.categoryColor)
            .color
        : darkenColor(
            DevelopmentCategoryDark.values
                .firstWhere((element) => element.id == widget.categoryColor)
                .color,
            0.77);

    return Container(
        width: double.infinity,
        height: double.infinity,
        color: selected
            ? isDarkTheme
                ? darkenColor(categoryColorSelected, 0.2)
                : darkenColor(categoryColorSelected, 0.1)
            : widget.categoryColor >= 0
                ? isDarkTheme
                    ? Color.lerp(categoryColorSelectedDark, Colors.white, 0.2)!
                    : Color.lerp(categoryColorSelectedDark, Colors.grey, 0.1)!
                : dark_light_modes.unselectedToggleColor(isDarkTheme),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.circle_rounded,
                color: categoryColorSelected, size: 8.0 + difficulty.id * 4),
            const SizedBox(width: 5),
            Text(difficulty.name,
                style: selected
                    ? Fonts_mode.largeTextStyleWhite(isDarkTheme, fontSize: 16)
                    : Fonts_mode.largeTextStyle(isDarkTheme, fontSize: 16))
          ]),
        )));
  }
}
