import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:kaidzen_app/service/TaskRepository.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/views/profilePanel.dart';
import 'package:kaidzen_app/views/switchableBoard.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'models/task.dart';
import 'service/ProgressRepository.dart';
import 'service/ProgressState.dart';

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
  static const kaidzens = ["Warrior", "Mage", "Rogue", "Hunter"];
  int _index = 0;
  Random _random = Random();
  final GlobalKey<SwitchableBoardState> _switchableBoardKey = GlobalKey();
  final GlobalKey<SwitchableBoardState> _profilePanelKey = GlobalKey();
  final newTaskController = TextEditingController();

  void _showKaidzen() {
    setState(() {
      _index = _random.nextInt(kaidzens.length);
    });
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
          String? text = await openDialog();
          var task = Task(text!, subtasks: [Task(text)]);
          _switchableBoardKey.currentState?.addItem(task);
        },
        tooltip: 'Add task',
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('New task'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'What should be done?'),
              controller: newTaskController,
            ),
            actions: [
              TextButton(onPressed: submit, child: Text("Create")),
            ],
          ));
  void submit() {
    Navigator.of(context).pop(newTaskController.text);
  }
}
