import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/progress.dart';
import 'package:kaidzen_app/views/BoardSection.dart';
import 'package:kaidzen_app/views/profilePanel.dart';
import 'package:kaidzen_app/views/switchableBoard.dart';
import 'dart:math';

import 'models/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaizen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
        title: Text(widget.title),
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Column(
            children: [
              ProfilePanel(
                key: _profilePanelKey,
                name: "Rostyslav Skliar",
                level: 10,
                progressMap: {
                  Category.CAREER_AND_FINANCES: Progress(0.3, 5),
                  Category.HEALTH: Progress(0.4, 7),
                  Category.PERSONAL_DEVELOPMENT: Progress(0.2, 3),
                  Category.LEISURE: Progress(0.7, 15),
                  Category.RELATIONSHIPS: Progress(0.1, 2)
                },
              ),
              SwitchableBoard(key: _switchableBoardKey),
            ],
          ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? text = await openDialog();
          var task = Task(text!, subtasks: [Task(text)]);
          _switchableBoardKey.currentState?.addItem(task);
        },
        tooltip: 'Show Kaidzen',
        child: const Icon(Icons.add),
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
