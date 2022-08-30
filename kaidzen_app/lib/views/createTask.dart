import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../achievements/AchievementsState.dart';
import '../achievements/event.dart';
import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';

class CreateTask extends StatefulWidget {
  final Task? parent;

  const CreateTask({Key? key, this.parent}) : super(key: key);

  @override
  State<CreateTask> createState() {
    return _CreateTaskState();
  }
}

class _CreateTaskState extends State<CreateTask> {
  late TextEditingController newTaskController;
  int _currentCategory = -1;
  int _currentDifficulty = 0;
  bool _isCreateButtonActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(children: [
                  Expanded(
                      child: IconButton(
                        icon: SvgPicture.asset("assets/shevron-left-black.svg"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      flex: 1),
                  const Expanded(
                      child: Center(
                          child: Text(
                        "Goal",
                        style: screenTytleTextStyle,
                      )),
                      flex: 9),
                  const Expanded(child: SizedBox(), flex: 1)
                ])),
            flex: 3),
        Expanded(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: newTaskController.clear,
                          icon: Visibility(
                              visible: newTaskController.text.isNotEmpty,
                              child:
                                  SvgPicture.asset("assets/close-grey.svg"))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              color: inputInactiveBorderColor)),
                      hintText: 'Goal title',
                      hintStyle: inputHintTextStyle),
                  controller: newTaskController,
                )),
            flex: 3),
        const Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: SizedBox(
                    width: double.infinity,
                    child: Text("Life sphere to be affected",
                        textAlign: TextAlign.left, style: largeTextStyle))),
            flex: 1),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TaskTypeWidget(
                    callback: (value) => setState(() {
                          _currentCategory = value!;
                          _isCreateButtonActive =
                              newTaskController.text.isNotEmpty &&
                                  _currentCategory >= 0;
                        }))),
            flex: 4),
        Expanded(
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Achieving this will improve my ${_currentCategory >= 0 ? DevelopmentCategory.values.firstWhere((element) => element.id == _currentCategory).name : 'life sphere'}...",
                        style: largeTextStyle,
                      ))),
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: SizedBox(
                      width: double.infinity,
                      child: TaskDifficultyWidget(
                          callback: (value) => _currentDifficulty = value!)))
            ]),
            flex: 5),
        Expanded(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isCreateButtonActive
                          ? () {
                              setState(() {
                                _isCreateButtonActive = false;
                              });
                              submit();
                            }
                          : null,
                      child: Text('Create',
                          style: _isCreateButtonActive
                              ? largeTextStyle20.copyWith(color: Colors.white)
                              : largeTextStyle20),
                      style: ElevatedButton.styleFrom(
                          primary: _isCreateButtonActive
                              ? activeButtonColor
                              : unselectedToggleColor),
                    ))),
            flex: 2),
      ]),
    );
  }

  void submit() {
    var category = activeCategories
        .firstWhere((element) => element.id == _currentCategory);
    Provider.of<TasksState>(context, listen: false).addTask(Task(
        newTaskController.text,
        category,
        Difficulty.values
            .firstWhere((element) => element.id == _currentDifficulty),
        parent: widget.parent != null ? widget.parent!.id : null));
    Provider.of<AchievementsState>(context, listen: false)
        .addEvent(Event(EventType.taskCreated, DateTime.now(), category));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    newTaskController = TextEditingController();
    newTaskController.addListener(() {
      final _isCreateButtonActive =
          newTaskController.text.isNotEmpty && _currentCategory >= 0;
      setState(() {
        this._isCreateButtonActive = _isCreateButtonActive;
      });
    });
  }
}

class TaskTypeWidget extends StatefulWidget {
  final void Function(int?)? callback;
  const TaskTypeWidget({Key? key, required this.callback}) : super(key: key);
  @override
  State<TaskTypeWidget> createState() {
    return _TaskTypeWidgetState(callback);
  }
}

class _TaskTypeWidgetState extends State<TaskTypeWidget> {
  final void Function(int?)? callback;
  _TaskTypeWidgetState(this.callback);
  int? _value = -1;

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
                          _value = selected ? cat.index : _value;
                        });
                        callback?.call(_value);
                      },
                    ))
                .toList()));
  }
}

class TaskDifficultyWidget extends StatefulWidget {
  final void Function(int?)? callback;
  const TaskDifficultyWidget({Key? key, required this.callback})
      : super(key: key);

  @override
  State<TaskDifficultyWidget> createState() {
    return _TaskDifficultyWidgetState(callback);
  }
}

class _TaskDifficultyWidgetState extends State<TaskDifficultyWidget> {
  final void Function(int?)? callback;
  _TaskDifficultyWidgetState(this.callback);
  int? _currentDifficulty = 0;

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
