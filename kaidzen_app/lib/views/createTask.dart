import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() {
    return _CreateTaskState();
  }
}

class _CreateTaskState extends State<CreateTask> {
  final newTaskController = TextEditingController();
  int _currentCategory = 0;
  int _currentDifficulty = 0;
  bool _isSubtask = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create goal', textAlign: TextAlign.center),
      ),
      body: Container(
        child: Column(children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Goal name'),
            controller: newTaskController,
          ),
          SizedBox(height: 20.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Subtask'),
            Switch(
                value: _isSubtask,
                onChanged: (value) {
                  setState(() {
                    _isSubtask = value;
                  });
                })
          ]),
          SizedBox(height: 40.0),
          Text("Life sphere to be affected", textAlign: TextAlign.left),
          TaskTypeWidget(callback: (value) => _currentCategory = value!),
          SizedBox(height: 20.0),
          Text(
              "Reaching this goal will improve my ${DevelopmentCategory.values.firstWhere((element) => element.id == _currentCategory).name}"),
          TaskDifficultyWidget(
              callback: (value) => _currentDifficulty = value!),
          SizedBox(height: 20.0),
          TextButton(
            onPressed: submit,
            child: Text('Create'),
          )
        ]),
      ),
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
  int _currentCategory = DevelopmentCategory.CAREER_AND_FINANCES.id;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: _currentCategory,
      onChanged: (value) {
        setState(() {
          _currentCategory = value!;
          callback?.call(value);
        });
      },
      items: DevelopmentCategory.values.map((category) {
        return DropdownMenuItem<int>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList(),
    );
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

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      cornerRadius: 10.0,
      radiusStyle: true,
      minHeight: 15.0,
      activeBgColor: [Colors.grey],
      activeFgColor: Colors.black,
      inactiveBgColor: Colors.white,
      inactiveFgColor: Colors.black,
      initialLabelIndex: 0,
      totalSwitches: 3,
      labels: [
        Difficulty.EASY.name,
        Difficulty.MEDIUM.name,
        Difficulty.HARD.name
      ],
      onToggle: (index) {
        callback?.call(index);
      },
    );
  }
}
