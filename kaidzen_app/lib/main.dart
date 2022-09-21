import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsRepository.dart';
import 'package:kaidzen_app/achievements/EventsRepository.dart';

import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/service/AnalyticsService.dart';
import 'package:kaidzen_app/service/TaskRepository.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/views/createTask.dart';
import 'package:kaidzen_app/views/profilePanel.dart';
import 'package:kaidzen_app/views/switchableBoard.dart';
import 'package:provider/provider.dart';

import 'service/ProgressRepository.dart';
import 'service/ProgressState.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ProgressState progressState = ProgressState(
    repository: ProgressRepository(),
  );
  AchievementsState achievementsState = AchievementsState(
      eventsRepository: EventsRepository(),
      achievementsRepository: AchievementsRepository());

  TasksState taskState = TasksState(
      repository: TaskRepository(),
      progressState: progressState,
      achievementsState: achievementsState);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) {
      taskState.loadAll();
      AnalyticsService.initUserProperties(taskState);
      return taskState;
    }),
    ChangeNotifierProvider(create: (context) {
      progressState.loadAll();
      return progressState;
    }),
    ChangeNotifierProvider(create: (context) {
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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
          child: Column(
        children: [
          ProfilePanel(key: _profilePanelKey),
          SwitchableBoard(key: _switchableBoardKey),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateTask()));
          await FirebaseAnalytics.instance.logEvent(
              name: AnalyticsEventType.CREATE_TASK_BUTTON_PRESSED.name);
        },
        tooltip: 'Add task',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
