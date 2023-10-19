import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/habit.dart';
import 'package:kaidzen_app/service/HabitState.dart';
import 'package:kaidzen_app/views/utils.dart';
import 'package:kaidzen_app/widgets/taskType.dart';
import 'package:kaidzen_app/widgets/taskDifficulty.dart';

import 'package:provider/provider.dart';

import '../service/AnalyticsService.dart';

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
  int _stage = 0;
  int _stageCount = 0;
  int _totalCount = 0;
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
    _stage = widget.habit.stage;
    _stageCount = widget.habit.stageCount;
    _totalCount = widget.habit.totalCount;
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
            widget.habit.getType() == HabitType.FIXED
                ? "Target goal"
                : "Habit goal",
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
                    Visibility(
                      visible: widget.habit.getType() == HabitType.FIXED,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: _buildEditableCounter(
                              "Completed:",
                              _stageCount,
                              () {
                                setState(() {
                                  if (_stageCount > 0) {
                                    _stageCount--;
                                  }
                                });
                              },
                              () {
                                setState(() {
                                  if (_stageCount < _totalCount) {
                                    _stageCount++;
                                  }
                                });
                              },
                            ),
                          ),
                          GestureDetector(
                            child: _buildEditableCounter(
                              "Target:",
                              _totalCount,
                              () {
                                setState(() {
                                  if (_totalCount > 0 &&
                                      _totalCount > _stageCount) {
                                    _totalCount--;
                                  }
                                });
                              },
                              () {
                                setState(() {
                                  if (_totalCount < maxFixedValue) {
                                    _totalCount++;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible:
                          widget.habit.getType() == HabitType.GIVE_IT_A_TRY,
                      child: Column(
                        children: [
                          _buildNonEditableCounter("You are on stage:", _stage),
                          GestureDetector(
                            child: _buildEditableCounter(
                              "Stage completions:",
                              _stageCount,
                              () {
                                setState(decreaseHabitStageCountFunction);
                              },
                              () {
                                setState(increaseHabitStageCountFunction);
                              },
                            ),
                          ),
                        ],
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

  void increaseHabitStageCountFunction() {
    var maxStageCount = widget.habit.getType().stageCount[_stage]!;
    if (_stageCount < maxStageCount) {
      _stageCount++;
    }
    if (_stageCount == maxStageCount &&
        _stage < widget.habit.getType().stageCount.length) {
      _stage++;
      _stageCount = 0;
    }
  }

  void decreaseHabitStageCountFunction() {
    if (_stageCount > 0) {
      _stageCount--;
    } else if (_stageCount == 0) {
      if (_stage > 1) {
        _stage--;
        _stageCount = widget.habit.getType().stageCount[_stage]! - 1;
      }
    }
  }

  Row _nonEditableCounter(int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: DevelopmentCategory.values
                .firstWhere((element) => element.id == _currentCategory)
                .color
                .withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value.toString(),
            style: Fonts.largeBoldTextStyle,
          ),
        ),
        Visibility(
          maintainAnimation: true,
          maintainState: true,
          maintainSize: true,
          visible: false,
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Row _buildCounter(
      int value, VoidCallback onMinusPressed, VoidCallback onPlusPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: onMinusPressed,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: DevelopmentCategory.values
                .firstWhere((element) => element.id == _currentCategory)
                .color
                .withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value.toString(),
            style: Fonts.largeBoldTextStyle,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: onPlusPressed,
        ),
      ],
    );
  }

  Widget _buildNonEditableCounter(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$label ",
                    style: Fonts.largeTextStyle,
                  ),
                  Spacer(),
                  _nonEditableCounter(value),
                ]),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableCounter(String label, int value,
      VoidCallback onMinusPressed, VoidCallback onPlusPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$label ",
                    style: Fonts.largeTextStyle,
                  ),
                  Spacer(),
                  _buildCounter(value, onMinusPressed, onPlusPressed),
                ]),
          ),
        ],
      ),
    );
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

  void submit() async {
    var category = DevelopmentCategory.values
        .firstWhere((element) => element.id == _currentCategory);
    widget.habit.task.name = newTaskController.text;
    widget.habit.task.category = category;
    widget.habit.task.difficulty = Difficulty.values
        .firstWhere((element) => element.id == _currentDifficulty);

    widget.habit.stage = _stage;
    widget.habit.stageCount = _stageCount;
    widget.habit.totalCount = _totalCount;

    if (fixedIsDone(widget.habit) || habitIsDone(widget.habit)) {
      await Provider.of<HabitState>(context, listen: false)
          .moveHabitAndNotify(widget.habit, Status.DONE);
    } else {
      await Provider.of<HabitState>(context, listen: false)
          .updateHabit(widget.habit);
    }
    Navigator.pop(context);
  }

  bool fixedIsDone(Habit habit) {
    return habit.getType() == HabitType.FIXED &&
        habit.stageCount == habit.totalCount &&
        habit.task.status == Status.DOING;
  }

  bool habitIsDone(Habit habit) {
    return habit.getType() != HabitType.FIXED &&
        habit.stage == habit.getType().stageCount.length &&
        habit.stageCount == habit.getType().stageCount[habit.stage];
  }

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }
}
