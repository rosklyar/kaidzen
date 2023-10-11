import 'package:flutter/material.dart';

import '../assets/constants.dart';

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
            Expanded(child: categoryChoice(DevelopmentCategory.MIND), flex: 10),
            const Expanded(child: SizedBox(), flex: 1),
            Expanded(
                child: categoryChoice(DevelopmentCategory.HEALTH), flex: 10),
            const Expanded(child: SizedBox(), flex: 1),
            Expanded(
                child: categoryChoice(DevelopmentCategory.ENERGY), flex: 10)
          ]),
          flex: 5),
      const Expanded(child: SizedBox(), flex: 1),
      Expanded(
          child: Row(children: [
            Expanded(
                child: categoryChoice(DevelopmentCategory.RELATIONS), flex: 14),
            const Expanded(child: SizedBox(), flex: 1),
            Expanded(
                child: categoryChoice(DevelopmentCategory.WEALTH), flex: 10),
            const Expanded(child: SizedBox(), flex: 1),
            const Expanded(child: SizedBox(), flex: 6)
          ]),
          flex: 5)
    ]);
  }

  ChoiceChip categoryChoice(DevelopmentCategory cat) {
    return ChoiceChip(
      selectedColor: selectedToggleColor,
      disabledColor: unselectedToggleColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
          child: SizedBox(
            child: Center(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.circle, color: cat.color, size: 9),
              const SizedBox(width: 6),
              Text(cat.name,
                  style: cat.index == _value
                      ? Fonts.largeTextStyleWhite
                      : Fonts.largeTextStyle)
            ])),
            width: double.infinity,
            height: double.infinity,
          )),
      selected: _value == cat.index,
      onSelected: (bool selected) {
        setState(() {
          _value = selected ? cat.index : -1;
        });
        callback?.call(_value);
      },
    );
  }
}
