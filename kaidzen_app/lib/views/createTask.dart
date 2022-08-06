import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';
import 'package:chip_list/chip_list.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() {
    return _CreateTaskState();
  }
}

class _CreateTaskState extends State<CreateTask> {
  late TextEditingController newTaskController;
  int _currentCategory = -1;
  int _currentDifficulty = 0;
  bool _isSubtask = false;
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
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Goal title',
                        labelText: 'Goal title'),
                    controller: newTaskController,
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtask'),
                        Switch(
                            value: _isSubtask,
                            onChanged: (value) {
                              setState(() {
                                _isSubtask = value;
                              });
                            })
                      ])),
              const SizedBox(height: 30),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: SizedBox(
                      width: double.infinity,
                      child: Text("Life sphere to be affected",
                          textAlign: TextAlign.left))),
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
              const SizedBox(height: 20),
              Visibility(
                  visible: _currentCategory >= 0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Reaching this goal will improve my ${_currentCategory >= 0 ? DevelopmentCategory.values.firstWhere((element) => element.id == _currentCategory).name : 'life sphere'}",
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
    Provider.of<TasksState>(context, listen: false).addTask(Task(
        newTaskController.text,
        DevelopmentCategory.values
            .firstWhere((element) => element.id == _currentCategory),
        Difficulty.values
            .firstWhere((element) => element.id == _currentDifficulty)));
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
            children: DevelopmentCategory.values
                .map((cat) => ChoiceChip(
                      selectedColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      label: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.circle, color: cat.color, size: 7),
                            const SizedBox(width: 5),
                            Text(cat.name, style: const TextStyle(fontSize: 14))
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
    return SizedBox(
        width: double.infinity,
        child: Wrap(
            children: Difficulty.values
                .map((diff) => ChoiceChip(
                      selectedColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      label: SizedBox(
                          width: 100,
                          child: Text(diff.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14))),
                      selected: _currentDifficulty == diff.index,
                      onSelected: (bool selected) {
                        setState(() {
                          _currentDifficulty =
                              selected ? diff.index : _currentDifficulty;
                        });
                        callback?.call(_currentDifficulty);
                      },
                    ))
                .toList()));
  }
}
