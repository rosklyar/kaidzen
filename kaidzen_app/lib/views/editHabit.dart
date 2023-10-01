import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/habit.dart';
import 'package:kaidzen_app/service/HabitState.dart';
import 'package:kaidzen_app/views/utils.dart';
import 'package:kaidzen_app/widgets/taskType.dart';
import 'package:kaidzen_app/widgets/taskDifficulty.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/AnalyticsService.dart';
import '../service/TasksState.dart';

class EditHabit extends StatefulWidget {
  final Habit habit;

  const EditHabit(this.habit, {Key? key}) : super(key: key);

  @override
  State<EditHabit> createState() {
    return _EditHabitState();
  }
}

class _EditHabitState extends State<EditHabit> {
  late TextEditingController newTaskController;
  int _currentCategory = -1;
  int _currentDifficulty = 0;
  final GlobalKey<dynamic> _taskTypeWidgetKey = GlobalKey();
  final GlobalKey<dynamic> _taskDifficultyWidgetKey = GlobalKey();
  bool _isSaveButtonActive = true;

  @override
  void initState() {
    super.initState();
    newTaskController = TextEditingController(text: widget.habit.task.name);
    newTaskController.addListener(() {
      setState(() {
        _isSaveButtonActive = newTaskController.text.isNotEmpty;
      });
    });
    _currentCategory = widget.habit.task.category.id;
    _currentDifficulty = widget.habit.task.difficulty.id;
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLength: maxInputCharCount,
                                autofocus: true,
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          newTaskController.clear();
                                          _taskTypeWidgetKey
                                              .currentState!._value = -1;
                                        },
                                        icon: Visibility(
                                            visible: newTaskController
                                                .text.isNotEmpty,
                                            child: SvgPicture.asset(
                                                "assets/close-grey.svg"))),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: inputInactiveBorderColor)),
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(children: [
                                Expanded(
                                    child: TaskTypeWidget(
                                        initialCategory: _currentCategory,
                                        key: _taskTypeWidgetKey,
                                        callback: (value) => setState(() {
                                              _currentCategory = value!;
                                              Utils.tryToLostFocus(context);
                                            })),
                                    flex: 1),
                                const Expanded(child: SizedBox(), flex: 1)
                              ])),
                          flex: 4),
                      Expanded(child: getDiff(), flex: 7),
                    ]),
                    flex: 9),
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
                      ],
                    ),
                    Visibility(
                      visible: widget.habit.getType() ==
                          HabitType.FIXED,
                      child: GestureDetector(
                        onTap: () async {
                          int? newTargetTotal = await showNumberInputDialog(
                              context, widget.habit.totalCount);
                          if (newTargetTotal != null) {
                            setState(() {
                              widget.habit.totalCount = newTargetTotal;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${widget.habit.totalCount} times",
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
                    )
                  ]),
                  flex: 2,
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_isSaveButtonActive) {
                                  await FirebaseAnalytics.instance.logEvent(
                                      name: AnalyticsEventType
                                          .edit_goal_screen_save_button.name);
                                  submit();
                                }
                              },
                              child: Text('Save',
                                  style: _isSaveButtonActive
                                      ? Fonts.largeTextStyle20
                                          .copyWith(color: Colors.white)
                                      : Fonts.largeTextStyle20),
                              style: ElevatedButton.styleFrom(
                                  primary: _isSaveButtonActive
                                      ? activeButtonColor
                                      : unselectedToggleColor),
                            ))),
                    flex: 1),
              ]),
            ),
            onTap: () => Utils.tryToLostFocus(context)));
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
                  key: _taskDifficultyWidgetKey,
                  callback: (value) => setState(() {
                        _currentDifficulty = value!;
                        Utils.tryToLostFocus(context);
                      }),
                  initialDifficulty: _currentDifficulty)))
    ]);
  }

  void submit() {
    var category = DevelopmentCategory.values
        .firstWhere((element) => element.id == _currentCategory);
    widget.habit.task.name = newTaskController.text;
    widget.habit.task.category = category;
    widget.habit.task.difficulty = Difficulty.values
        .firstWhere((element) => element.id == _currentDifficulty);
    Provider.of<HabitState>(context, listen: false).updateHabit(widget.habit);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }
}
