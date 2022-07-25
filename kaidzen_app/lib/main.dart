import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:kaidzen_app/service/TaskRepository.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/views/profilePanel.dart';
import 'package:kaidzen_app/views/switchableBoard.dart';
import 'package:provider/provider.dart';

import 'models/task.dart';
import 'service/ProgressRepository.dart';
import 'service/ProgressState.dart';
import 'package:toggle_switch/toggle_switch.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) {
      TasksState taskState = TasksState(repository: TaskRepository());
      taskState.loadAll();
      return taskState;
    }),
    ChangeNotifierProvider(create: (context) {
      ProgressState progressState = ProgressState(
        repository: ProgressRepository(),
      );
      progressState.loadAll();
      return progressState;
    }),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaizen',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Kaizen App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<SwitchableBoardState> _switchableBoardKey = GlobalKey();
  final GlobalKey<SwitchableBoardState> _profilePanelKey = GlobalKey();
  final newTaskController = TextEditingController();
  int _currentCategory = 0;
  int _currentDifficulty = 0;
  bool _isSubtask = false;

  void _showKaidzen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: SizedBox(
          child: SingleChildScrollView(
              child: Column(
        children: [
          ProfilePanel(
            key: _profilePanelKey,
            name: "Rostyslav Skliar",
          ),
          const Padding(padding: EdgeInsets.all(7.0)),
          SwitchableBoard(key: _switchableBoardKey),
        ],
      ))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () async {
          Task? task = await openDialog();
          _switchableBoardKey.currentState?.addItem(task!);
        },
        tooltip: 'Add task',
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<Task?> openDialog() => showDialog<Task>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Create goal',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
            content: Column(children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(hintText: 'Goal name'),
                controller: newTaskController,
              ),
              SizedBox(height: 20.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Turn into subtask'),
                Switch(
                    value: _isSubtask,
                    onChanged: (value) {
                      setState(() {
                        _isSubtask = value;
                      });
                    })
              ]),
              SizedBox(height: 20.0),
              TaskTypeWidget(callback: (value) => _currentCategory = value!),
              SizedBox(height: 20.0),
              TaskDifficultyWidget(
                  callback: (value) => _currentDifficulty = value!)
            ]),
            actions: [
              TextButton(onPressed: submit, child: Text("Create")),
            ],
          ));

  void submit() {
    Navigator.of(context).pop(Task(
        newTaskController.text,
        DevelopmentCategory.values
            .firstWhere((element) => element.id == _currentCategory),
        Difficulty.values
            .firstWhere((element) => element.id == _currentDifficulty)));
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
    return Container(
        child: DropdownButton<int>(
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
    ));
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
    return Column(children: [
      Text('Its accomplishment will improve my life:'),
      SizedBox(height: 10.0),
      ToggleSwitch(
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
      )
    ]);
  }
}
