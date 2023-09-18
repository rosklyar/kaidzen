import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../assets/constants.dart';

class HabitOptionWidget extends StatefulWidget {
  final void Function(HabitType?)? callback;
  final HabitType initialOption;
  const HabitOptionWidget(
      {Key? key, required this.callback, required this.initialOption})
      : super(key: key);

  @override
  State<HabitOptionWidget> createState() {
    return _HabitOptionWidgetState(callback, initialOption);
  }
}

class _HabitOptionWidgetState extends State<HabitOptionWidget> {
  final void Function(HabitType?)? callback;
  _HabitOptionWidgetState(this.callback, this._currentType);
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
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: selected ? selectedToggleColor : unselectedToggleColor,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(habitType.title,
                style:
                    selected ? Fonts.largeTextStyleWhite : Fonts.largeTextStyle)
          ]),
        )));
  }
}
