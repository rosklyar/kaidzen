import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/views/utils.dart';
import 'package:kaidzen_app/widgets/taskType.dart';
import 'package:kaidzen_app/widgets/taskDifficulty.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/AnalyticsService.dart';
import '../service/TasksState.dart';
import '../assets/light_dark_theme.dart';

class EditGoal extends StatefulWidget {
  final Task task;

  const EditGoal(this.task, {Key? key}) : super(key: key);

  @override
  State<EditGoal> createState() {
    return _EditGoalState();
  }
}

class _EditGoalState extends State<EditGoal> {
  late TextEditingController newTaskController;
  int _currentCategory = -1;
  int _currentDifficulty = 0;
  final GlobalKey<dynamic> _taskTypeWidgetKey = GlobalKey();
  final GlobalKey<dynamic> _taskDifficultyWidgetKey = GlobalKey();
  bool _isSaveButtonActive = true;

  @override
  void initState() {
    super.initState();
    newTaskController = TextEditingController(text: widget.task.name);
    newTaskController.addListener(() {
      setState(() {
        _isSaveButtonActive = newTaskController.text.isNotEmpty;
      });
    });
    _currentCategory = widget.task.category.id;
    _currentDifficulty = widget.task.difficulty.id;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    bool isDarkTheme = themeProvider.darkTheme;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: dark_light_modes.statusIcon(isDarkTheme),
            ),
            // SvgPicture.asset("assets/shevron-left-black.svg"),
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
          backgroundColor: Color(DevelopmentCategoryDark.values
              .firstWhere((element) => element.id == _currentCategory)
              .backgroundColor),
        ),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            child: Container(
              padding: const EdgeInsets.only(bottom: 8),
              color: Color(DevelopmentCategoryDark.values
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
                                autofocus: false,
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
                    flex: 1)
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
                "Achieving this will improve my ${_currentCategory >= 0 ? DevelopmentCategoryDark.values.firstWhere((element) => element.id == _currentCategory).name : 'life sphere'}...",
                style: Fonts.largeTextStyle,
              ))),
      Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
          child: SizedBox(
              width: double.infinity,
              child: TaskDifficultyWidget(
                  categoryColor: _currentCategory,
                  key: _taskDifficultyWidgetKey,
                  callback: (value) => setState(() {
                        _currentDifficulty = value!;
                        Utils.tryToLostFocus(context);
                      }),
                  initialDifficulty: _currentDifficulty)))
    ]);
  }

  void submit() {
    var category = DevelopmentCategoryDark.values
        .firstWhere((element) => element.id == _currentCategory);
    widget.task.name = newTaskController.text;
    widget.task.category = category;
    widget.task.difficulty = Difficulty.values
        .firstWhere((element) => element.id == _currentDifficulty);
    Provider.of<TasksState>(context, listen: false).updateTask(widget.task);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }
}
