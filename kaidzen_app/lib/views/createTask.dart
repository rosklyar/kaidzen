import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/models/inspiration.dart';
import 'package:kaidzen_app/service/AnalyticsService.dart';
import 'package:kaidzen_app/service/HabitState.dart';
import 'package:kaidzen_app/views/utils.dart';
import 'package:kaidzen_app/views/theamedAlertDIalog.dart';
import 'package:kaidzen_app/widgets/taskDifficulty.dart';

import '../achievements/AchievementsState.dart';
import '../achievements/event.dart';
import '../models/habit.dart';
import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';
import '../utils/snackbar.dart';
import '../widgets/habitOption.dart';
import '../widgets/taskType.dart';

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
  int _targetTotal = 10;
  HabitType _currentHabitType = HabitType.FIXED;
  bool _isCreateButtonActive = false;
  bool _isHabit = false;
  late Future<List<Inspiration>>? _inspirationsFuture;
  final GlobalKey<dynamic> _taskTypeWidgetKey = GlobalKey();
  final GlobalKey<dynamic> _taskDifficultyWidgetKey = GlobalKey();
  final GlobalKey<dynamic> _habitWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _inspirationsFuture = getInspirations(context);
    newTaskController = TextEditingController();
    newTaskController.addListener(() {
      setState(() {
        _isCreateButtonActive = newTaskController.text.isNotEmpty;
      });
    });
  }

  static Future<List<Inspiration>> getInspirations(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data =
        await assetBundle.loadString('assets/inspiration/inspirations.json');
    final body = json.decode(data);
    return body.map<Inspiration>((json) => Inspiration.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: SvgPicture.asset("assets/shevron-left-black.svg"),
            onPressed: () async {
              await FirebaseAnalytics.instance.logEvent(
                  name: AnalyticsEventType.create_goal_screen_back_button.name);
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Goal",
            style: Fonts.screenTytleTextStyle,
          ),
          centerTitle: true,
          backgroundColor: Color(DevelopmentCategory.values
              .firstWhere((element) => element.id == _currentCategory)
              .backgroundColor),
        ),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          child: Container(
            padding: const EdgeInsets.only(bottom: 8),
            color: Color(DevelopmentCategory.values
                .firstWhere((element) => element.id == _currentCategory)
                .backgroundColor),
            child: Column(children: [
              Expanded(
                  child: Column(children: [
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 20),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              maxLength: maxInputCharCount,
                              autofocus: true,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        newTaskController.clear();
                                        _taskTypeWidgetKey
                                            .currentState!._value = -1;
                                        _taskDifficultyWidgetKey.currentState
                                            ._currentDifficulty = 0;
                                      },
                                      icon: Visibility(
                                          visible:
                                              newTaskController.text.isNotEmpty,
                                          child: SvgPicture.asset(
                                              "assets/close-grey.svg"))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: inputInactiveBorderColor)),
                                  hintText: 'Goal title',
                                  hintStyle: Fonts.inputHintTextStyle),
                              controller: newTaskController,
                            )),
                        flex: 3),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                                width: double.infinity,
                                child: Text("Life sphere to be affected",
                                    textAlign: TextAlign.left,
                                    style: Fonts.largeTextStyle))),
                        flex: 1),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(children: [
                              Expanded(
                                  child: TaskTypeWidget(
                                      initialCategory: -1,
                                      key: _taskTypeWidgetKey,
                                      callback: (value) => setState(() {
                                            _currentCategory = value!;
                                            Utils.tryToLostFocus(context);
                                          })),
                                  flex: 1),
                              const Expanded(child: SizedBox(), flex: 1)
                            ])),
                        flex: 5),
                    Expanded(child: getDiff(), flex: 5),
                    Expanded(
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                      child: Text("Recurring goal",
                                          textAlign: TextAlign.left,
                                          style: Fonts.largeTextStyle))),
                              Switch(
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.deepPurpleAccent,
                                  value: _isHabit,
                                  onChanged: (value) {
                                    setState(() {
                                      _isHabit = value;
                                    });
                                  })
                            ],
                          ),
                          Visibility(
                              visible: _isHabit, child: getHabitWidget()),
                          Visibility(
                            visible: _isHabit &&
                                _currentHabitType == HabitType.FIXED,
                            child: GestureDetector(
                              onTap: () async {
                                int? newTargetTotal =
                                    await showNumberInputDialog('Enter target total',
                                        context, _targetTotal, maxFixedValue, 1);
                                if (newTargetTotal != null) {
                                  setState(() {
                                    _targetTotal = newTargetTotal;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenWidth * 0.04,
                                    horizontal: screenWidth * 0.04),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "$_targetTotal times",
                                      style: Fonts.mindfulMomentTextStyleLarge,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: screenWidth * 0.04),
                                        SvgPicture.asset("assets/edit.svg"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isHabit &&
                                _currentHabitType == HabitType.GIVE_IT_A_TRY,
                            child: GestureDetector(
                              child: Container(
                                height: screenWidth * 0.35,
                                padding: EdgeInsets.symmetric(
                                    vertical: screenWidth * 0.04,
                                    horizontal: screenWidth * 0.01),
                                child: Image.asset("assets/habits_background.png"),
                              ),
                            ),
                          ),
                        ]),
                        flex: 10)
                  ]),
                  flex: 9),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isCreateButtonActive
                                ? () async {
                                    if (_currentCategory == -1) {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                            child: Center(
                                              child: Column(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15),
                                                          child: Text(
                                                              'Choose the life sphere to\nreinforce your motivation',
                                                              style: Fonts
                                                                  .screenTytleTextStyle)),
                                                      flex: 4),
                                                  const Expanded(
                                                      child: SizedBox(),
                                                      flex: 1),
                                                  Expanded(
                                                      child: Text(
                                                          "Sometimes we set goals we don’t need.\nChoosing the sphere helps to\nunderstand why this goal is important\n— will it improve your mind, health,\nrelationships, make you more wealthy,\nor fulfill with energy.\n\n\nAnd adds you some extra points.",
                                                          style: Fonts
                                                              .largeTextStyle),
                                                      flex: 10),
                                                  const Expanded(
                                                      child: SizedBox(),
                                                      flex: 1),
                                                  Expanded(
                                                      child: GestureDetector(
                                                          child: Text(
                                                              'Create without sphere',
                                                              style: Fonts
                                                                  .largeTextStyle
                                                                  .copyWith(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline)),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            submit();
                                                          }),
                                                      flex: 2),
                                                  Expanded(
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  bottom: 10),
                                                          child: SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  ElevatedButton(
                                                                child: Text(
                                                                    'Choose from the spheres',
                                                                    style: Fonts
                                                                        .largeTextStyle20
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.white)),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        primary:
                                                                            activeButtonColor),
                                                              ))),
                                                      flex: 3),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      submit();
                                    }
                                    await FirebaseAnalytics.instance.logEvent(
                                        name: AnalyticsEventType
                                            .create_goal_screen_create_button
                                            .name);
                                  }
                                : null,
                            child: Text('Create',
                                style: _isCreateButtonActive
                                    ? Fonts.largeTextStyle20
                                        .copyWith(color: Colors.white)
                                    : Fonts.largeTextStyle20),
                            style: ElevatedButton.styleFrom(
                                primary: _isCreateButtonActive
                                    ? activeButtonColor
                                    : unselectedToggleColor),
                          ))),
                  flex: 1)
            ]),
          ),
          onTap: () {
            Utils.tryToLostFocus(context);
          },
        ));
  }

  Widget inspirationsWidget(
      BuildContext context, ScrollController scrollController) {
    return FutureBuilder<List<Inspiration>>(
        future: _inspirationsFuture,
        builder: (ctx, snapshot) {
          final inspirations = snapshot.hasData ? snapshot.data! : [];
          return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  controller: scrollController,
                  itemCount: inspirations.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                        height: 35,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.circle_rounded,
                                    color: inspirations[index].category.color,
                                    size: 15.0),
                                const SizedBox(width: 5),
                                Text(
                                  inspirations[index].title,
                                  style: Fonts.largeTextStyle,
                                  textAlign: TextAlign.left,
                                )
                              ]),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      newTaskController.text =
                                          inspirations[index].title;
                                      _taskTypeWidgetKey.currentState!._value =
                                          inspirations[index].category.id;
                                      _currentCategory =
                                          inspirations[index].category.id;
                                      _taskDifficultyWidgetKey.currentState!
                                              ._currentDifficulty =
                                          inspirations[index].difficulty.id;
                                      _currentDifficulty =
                                          inspirations[index].difficulty.id;
                                    });
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/shevron-right-black.svg"))
                            ]));
                  }));
        });
  }

  Widget getHabitWidget() {
    return Column(children: [
      const SizedBox(height: 10),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
              width: double.infinity,
              child: Text(
                "Track the progress on your goal with the fixed amount of repetitions",
                style: Fonts.mediumTextStyle,
              ))),
      Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
          child: SizedBox(
              width: double.infinity,
              child: HabitOptionWidget(
                  initialOption: HabitType.FIXED,
                  key: _habitWidgetKey,
                  callback: (value) => setState(() {
                        _currentHabitType = value!;
                        Utils.tryToLostFocus(context);
                      }))))
    ]);
  }

  Widget getDiff() {
    return Column(children: [
      const SizedBox(height: 10),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
              width: double.infinity,
              child: Text(
                "Achieving this will improve my ${_currentCategory >= 0 ? DevelopmentCategory.values.firstWhere((element) => element.id == _currentCategory).name : 'life sphere'}...",
                style: Fonts.largeTextStyle,
              ))),
      Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
          child: SizedBox(
              width: double.infinity,
              child: TaskDifficultyWidget(
                  initialDifficulty: 0,
                  key: _taskDifficultyWidgetKey,
                  callback: (value) => setState(() {
                        _currentDifficulty = value!;
                        Utils.tryToLostFocus(context);
                      }))))
    ]);
  }

  Widget getHabitOptionLayout(HabitType habitType, bool selected) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: selected ? selectedToggleColor : unselectedToggleColor,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(habitType.name,
                style:
                    selected ? Fonts.largeTextStyleWhite : Fonts.largeTextStyle)
          ]),
        )));
  }

  void submit() {
    var category = DevelopmentCategory.values
        .firstWhere((element) => element.id == _currentCategory);
    if (_isHabit) {
      var totalCount = _currentHabitType == HabitType.FIXED
              ? _targetTotal
              : _currentHabitType.stageCount.values
                  .fold(0, (previousValue, element) => previousValue + element);
                  
      Provider.of<HabitState>(context, listen: false).addHabit(Habit(
          Task(
              newTaskController.text,
              category,
              Difficulty.values
                  .firstWhere((element) => element.id == _currentDifficulty),
              parent: widget.parent != null ? widget.parent!.id : null),
          1,
          0,
          totalCount,
          _currentHabitType.id));
    } else {
      Provider.of<TasksState>(context, listen: false).addTask(Task(
          newTaskController.text,
          category,
          Difficulty.values
              .firstWhere((element) => element.id == _currentDifficulty),
          parent: widget.parent != null ? widget.parent!.id : null));
    }

    Provider.of<EmotionsState>(context, listen: false).loadAll();
    Navigator.pop(context);
    showTutorialTopFlushbar("Goal created", context);
  }

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }
}
