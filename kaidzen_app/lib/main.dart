import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/EventsRepository.dart';

import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/service/TaskRepository.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/views/createTask.dart';
import 'package:kaidzen_app/views/profilePanel.dart';
import 'package:kaidzen_app/views/switchableBoard.dart';
import 'package:provider/provider.dart';

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
    ChangeNotifierProvider(create: (context) {
      AchievementsState achievementsState =
          AchievementsState(repository: EventsRepository());
      achievementsState.loadAll();
      return achievementsState;
    }),
  ], child: const MyApp()));
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
      home: const HomeScreen(title: 'Kaizen App'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<SwitchableBoardState> _switchableBoardKey = GlobalKey();
  final GlobalKey<ProfilePanelState> _profilePanelKey = GlobalKey();

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
          ProfilePanel(key: _profilePanelKey),
          const Padding(padding: EdgeInsets.all(7.0)),
          SwitchableBoard(key: _switchableBoardKey),
        ],
      ))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateTask()));
        },
        tooltip: 'Add task',
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
