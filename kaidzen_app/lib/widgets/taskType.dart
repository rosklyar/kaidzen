import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../assets/light_dark_theme.dart';

class TaskTypeWidget extends StatefulWidget {
  final void Function(int?)? callback;
  final int initialCategory;
  const TaskTypeWidget(
      {Key? key, required this.callback, required this.initialCategory})
      : super(key: key);
  @override
  State<TaskTypeWidget> createState() {
    return _TaskTypeWidgetState(callback, initialCategory);
  }
}

class _TaskTypeWidgetState extends State<TaskTypeWidget> {
  final void Function(int?)? callback;
  _TaskTypeWidgetState(this.callback, this._value);
  int? _value;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: Row(children: [
            Expanded(
                child: categoryChoice(DevelopmentCategoryDark.MIND), flex: 10),
            const Expanded(child: SizedBox(), flex: 1),
            Expanded(
                child: categoryChoice(DevelopmentCategoryDark.HEALTH),
                flex: 10),
            const Expanded(child: SizedBox(), flex: 1),
            Expanded(
                child: categoryChoice(DevelopmentCategoryDark.ENERGY), flex: 10)
          ]),
          flex: 5),
      const Expanded(child: SizedBox(), flex: 1),
      Expanded(
          child: Row(children: [
            const Expanded(child: SizedBox(), flex: 3),
            Expanded(
                child: categoryChoice(DevelopmentCategoryDark.RELATIONS),
                flex: 10),
            const Expanded(child: SizedBox(), flex: 1),
            Expanded(
                child: categoryChoice(DevelopmentCategoryDark.WEALTH),
                flex: 10),
            const Expanded(child: SizedBox(), flex: 3),
            // const Expanded(child: SizedBox(), flex: 6)
          ]),
          flex: 5)
    ]);
  }

  ChoiceChip categoryChoice(DevelopmentCategoryDark cat) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    bool isDarkTheme = themeProvider.darkTheme;
    bool isSelected = _value == cat.index;

    // Determine if any chip is selected
    bool anySelected = _value != -1;

    Color backgroundColor = isSelected
        ? isDarkTheme
            ? darkenColor(cat.color, 0.2)
            : darkenColor(cat.color, 0.1)
        : anySelected
            ? isDarkTheme
                ? Color.lerp(
                    DevelopmentCategoryDark.values
                        .firstWhere((element) => element.id == _value)
                        .getBackgroundColor(isDarkTheme),
                    Colors.white,
                    0.2)!
                : Color.lerp(
                    DevelopmentCategoryDark.values
                        .firstWhere((element) => element.id == _value)
                        .getBackgroundColor(isDarkTheme),
                    Colors.grey,
                    0.1)!
            // Unselected, others are selected
            : dark_light_modes
                .unselectedToggleColor(isDarkTheme); // Default unselected color

    return ChoiceChip(
      selectedColor: backgroundColor,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
          child: SizedBox(
            child: Center(
                child: Row(
                    mainAxisSize: MainAxisSize.min, // Use minimum space
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.circle, color: cat.color, size: 9),
                  const SizedBox(width: 6),
                  Text(cat.name,
                      style: isSelected
                          ? Fonts_mode.largeTextStyleWhite(isDarkTheme,
                              fontSize: 16)
                          : Fonts_mode.largeTextStyle(isDarkTheme,
                              fontSize: 16))
                ])),
            width: double.infinity,
            height: double.infinity,
          )),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _value = selected ? cat.index : -1;
        });
        callback?.call(_value);
      },
    );
  }
}
