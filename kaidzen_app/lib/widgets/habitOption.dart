import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../assets/constants.dart';
import '../assets/light_dark_theme.dart';

class HabitOptionWidget extends StatefulWidget {
  final void Function(HabitType?)? callback;
  final HabitType initialOption;
  final int categoryColor;
  const HabitOptionWidget(
      {Key? key,
      required this.callback,
      required this.initialOption,
      required this.categoryColor})
      : super(key: key);

  @override
  State<HabitOptionWidget> createState() {
    return _HabitOptionWidgetState(callback, initialOption, categoryColor);
  }
}

class _HabitOptionWidgetState extends State<HabitOptionWidget> {
  final void Function(HabitType?)? callback;
  final int categoryColor;

  _HabitOptionWidgetState(
    this.callback,
    this._currentType,
    this.categoryColor,
  );
  HabitType _currentType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: LayoutBuilder(
            builder: (context, constraints) => ToggleButtons(
                constraints: BoxConstraints.expand(
                    width: constraints.maxWidth / 2 - 5,
                    height: MediaQuery.of(context).size.height * 0.05),
                borderRadius: BorderRadius.circular(5),
                children: [
                  getDiffOptionLayout(
                      HabitType.FIXED, _currentType == HabitType.FIXED),
                  getDiffOptionLayout(HabitType.GIVE_IT_A_TRY,
                      _currentType == HabitType.GIVE_IT_A_TRY)
                ],
                isSelected: Iterable<int>.generate(2)
                    .map((e) => e == _currentType.id)
                    .toList(),
                onPressed: (newIndex) {
                  setState(() {
                    _currentType = HabitType.getById(newIndex);
                  });
                  callback?.call(_currentType);
                })),
        width: double.infinity);
  }

  Widget getDiffOptionLayout(HabitType habitType, bool selected) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    bool isDarkTheme = themeProvider.darkTheme;

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
            Text(habitType.title,
                style: selected
                    ? Fonts_mode.largeTextStyleWhite(isDarkTheme, fontSize: 16)
                    : Fonts_mode.largeTextStyle(isDarkTheme, fontSize: 16))
          ]),
        )));
  }
}
