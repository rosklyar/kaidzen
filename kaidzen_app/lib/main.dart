import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaidzen_app/achievements/AchievementsRepository.dart';
import 'package:kaidzen_app/achievements/EventsRepository.dart';

import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/announcements/AnnouncementsRepository.dart';
import 'package:kaidzen_app/announcements/AnnouncementsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/emotions/EmotionPointsRepository.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/features/FeaturesRepository.dart';
import 'package:kaidzen_app/features/FeaturesState.dart';
import 'package:kaidzen_app/service/AnalyticsService.dart';
import 'package:kaidzen_app/service/BoardMessageState.dart';
import 'package:kaidzen_app/service/TaskRepository.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/tutorial/TutorialRepository.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';
import 'package:kaidzen_app/views/createTask.dart';
import 'package:kaidzen_app/views/profilePanel.dart';
import 'package:kaidzen_app/views/switchableBoard.dart';
import 'package:provider/provider.dart';

import 'service/ProgressRepository.dart';
import 'service/ProgressState.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ProgressState progressState = ProgressState(
    repository: ProgressRepository(),
  );
  var eventsRepository = EventsRepository();
  AchievementsState achievementsState = AchievementsState(
      eventsRepository: eventsRepository,
      achievementsRepository: AchievementsRepository());

  TutorialState tutorialState = TutorialState(TutorialRepository());
  EmotionsState emotionsState =
      EmotionsState(eventsRepository, EmotionPointsRepository(), tutorialState);

  AnnouncementsState announcementsState =
      AnnouncementsState(announcementsRepository: AnnouncementsRepository());

  FeaturesState featuresState =
      FeaturesState(featuresRepository: FeaturesRepository());

  TasksState taskState = TasksState(
      repository: TaskRepository(),
      progressState: progressState,
      achievementsState: achievementsState,
      emotionsState: emotionsState,
      tutorialState: tutorialState);

  await taskState.loadAll();
  await achievementsState.loadAll();
  await tutorialState.loadAll();
  await emotionsState.loadAll();
  await announcementsState.loadAll();
  await featuresState.loadAll();

  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runZonedGuarded(
          () => runApp(MultiProvider(providers: [
                ChangeNotifierProvider(create: (context) {
                  AnalyticsService.initUserProperties(
                      taskState, emotionsState, tutorialState);
                  return taskState;
                }),
                ChangeNotifierProvider(create: (context) {
                  progressState.loadAll();
                  return progressState;
                }),
                ChangeNotifierProvider(create: (context) {
                  return achievementsState;
                }),
                ChangeNotifierProvider(create: (context) {
                  return tutorialState;
                }),
                ChangeNotifierProvider(create: (context) {
                  return emotionsState;
                }),
                ChangeNotifierProvider(create: (context) {
                  return BoardMessageState(tutorialState, taskState);
                }),
                ChangeNotifierProvider(create: (context) {
                  return announcementsState;
                }),
                ChangeNotifierProvider(create: (context) {
                  return featuresState;
                }),
              ], child: const MyApp())),
          CrashReporting.reportCrash));
  Instabug.init(
      token: defaultTargetPlatform == TargetPlatform.iOS
          ? '5512d7634f2aa086cb94903be6939bc3'
          : 'a1b46ee08c00dec58122306994a09310',
      invocationEvents: [InvocationEvent.none]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [InstabugNavigatorObserver()],
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
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
            label: "Sticky Goals", primaryColor: moreScreenBackColor.value));
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark
            .copyWith(statusBarColor: Colors.white.withOpacity(0)),
        child: Scaffold(
          body: Stack(children: [
            Column(children: [
              Expanded(flex: 28, child: ProfilePanel(key: _profilePanelKey)),
              Expanded(
                flex: 24,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.01),
                  child: Image.asset("assets/mountains_cut.png",
                      width: MediaQuery.of(context).size.width),
                ),
              ),
              Expanded(flex: 60, child: Container())
            ]),
            SwitchableBoard(key: _switchableBoardKey),
          ]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              await FirebaseAnalytics.instance.logEvent(
                  name: AnalyticsEventType.create_goal_button_pressed.name);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreateTask()));
            },
            tooltip: 'Add goal',
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ));
  }
}
