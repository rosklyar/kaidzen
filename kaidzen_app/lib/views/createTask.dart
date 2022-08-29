import 'package:flutter/material.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create goal'),
      ),
      body: Column(children: [
        Expanded(
            child: Column(children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: newTaskController.clear,
                            icon: const Icon(Icons.clear)),
                        border: const OutlineInputBorder(),
                        hintText: 'Goal title',
                        labelText: 'Goal title'),
                    controller: newTaskController,
                  )),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: SizedBox(
                      width: double.infinity,
                      child: Text("Life sphere to be affected",
                          textAlign: TextAlign.left, style: mediumTextStyle))),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TaskTypeWidget(
                      callback: (value) => setState(() {
                            _currentCategory = value!;
                            _isCreateButtonActive =
                                newTaskController.text.isNotEmpty &&
                                    _currentCategory >= 0;
                          }))),
              Visibility(
                  visible: _currentCategory >= 0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Reaching this goal will improve my ${_currentCategory >= 0 ? DevelopmentCategory.values.firstWhere((element) => element.id == _currentCategory).name : 'life sphere'}",
                            style: mediumTextStyle,
                          )))),
              const SizedBox(height: 10),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Visibility(
                      visible: _currentCategory >= 0,
                      child: TaskDifficultyWidget(
                          callback: (value) => _currentDifficulty = value!)))
            ]),
            flex: 7),
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
                      child:
                          const Text('Create', style: TextStyle(fontSize: 20)),
                    ))),
            flex: 1)
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
      inactiveFgColor: Colors.black,
      initialLabelIndex: _currentDifficulty,
      dividerColor: const Color.fromARGB(255, 76, 80, 82),
      totalSwitches: 3,
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
