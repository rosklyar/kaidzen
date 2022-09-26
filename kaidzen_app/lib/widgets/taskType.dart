import 'package:flutter/material.dart';

import '../assets/constants.dart';

class TaskTypeWidget extends StatefulWidget {
  final void Function(int?)? callback;
  final int? initialCategory;
  const TaskTypeWidget({Key? key, required this.callback, this.initialCategory})
      : super(key: key);
  @override
  State<TaskTypeWidget> createState() {
    return _TaskTypeWidgetState(callback);
  }
}

class _TaskTypeWidgetState extends State<TaskTypeWidget> {
  final void Function(int?)? callback;
  _TaskTypeWidgetState(this.callback);
  int? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialCategory ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Wrap(
            spacing: 10,
            children: activeCategories
                .map((cat) => ChoiceChip(
                      selectedColor: selectedToggleColor,
                      disabledColor: unselectedToggleColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      label: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.circle, color: cat.color, size: 7),
                            const SizedBox(width: 5),
                            Text(cat.name,
                                style: cat.index == _value
                                    ? mediumWhiteTextStyle
                                    : mediumTextStyle)
                          ])),
                      selected: _value == cat.index,
                      onSelected: (bool selected) {
                        setState(() {
                          _value = selected ? cat.index : -1;
                        });
                        callback?.call(_value);
                      },
                    ))
                .toList()));
  }
}
