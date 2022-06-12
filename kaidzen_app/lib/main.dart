import 'package:flutter/material.dart';
import 'package:kaidzen_app/views/BoardSection.dart';
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
  final GlobalKey<BoardSectionState> _boardKey = GlobalKey();
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
      body: PageView(
        children: [
          Container(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Your Kaidzen is: ${kaidzens[_index]}',
                ),
              ],
            )),
            color: Colors.blue,
          ),
          Container(
            child: BoardSection(key: _boardKey),
          ),
          Container(
            color: Colors.green,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? text = await openDialog();
          _boardKey.currentState?.addItem(Task(name: text!));
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
