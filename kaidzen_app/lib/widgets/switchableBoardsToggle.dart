import 'dart:ui';

import 'package:flutter/material.dart';

import '../assets/constants.dart';

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
                                BorderRadius.all(Radius.circular(30))),
                        label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(board.name,
                                        style: board.index == _value
                                            ? Fonts.xLargeWhiteTextStyle
                                            : Fonts.xLargeTextStyle),
                                  ])),
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
