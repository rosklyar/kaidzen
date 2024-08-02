import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/views/utils.dart';
import 'package:vibration/vibration.dart';

import '../assets/light_dark_theme.dart';
import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/AnalyticsService.dart';
import '../service/TasksState.dart';

class EditSubGoal extends StatefulWidget {
  final Task parent;
  final Task task;

  const EditSubGoal({Key? key, required this.parent, required this.task})
      : super(key: key);

  @override
  State<EditSubGoal> createState() {
    return _EditSubGoalState();
  }
}

class _EditSubGoalState extends State<EditSubGoal> {
  late TextEditingController newTaskController;
  bool _isSaveButtonActive = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;
    var parentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: dark_light_modes.statusIcon(isDarkTheme),
            ),
            onPressed: () {
              isDarkTheme ? HapticFeedback.selectionClick() : null;
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Edit subgoal",
            style: Fonts_mode.screenTytleTextStyle(isDarkTheme),
          ),
          centerTitle: true,
          backgroundColor:
              (widget.parent.category.getBackgroundColor(isDarkTheme)),
        ),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                color: (widget.parent.category.getBackgroundColor(isDarkTheme)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: TextField(
                                    maxLength: maxInputCharCount,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        hintText: 'Subgoal title',
                                        labelText: 'Subgoal title',
                                        hintStyle:
                                            Fonts_mode.inputHintTextStyle(
                                                isDarkTheme)),
                                    controller: newTaskController,
                                  )),
                              Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          parentWidth * 0.03, 5, 5, 5),
                                      child:
                                          Image.asset("assets/back_arrow.png")),
                                  SizedBox(
                                    width: parentWidth * 0.8,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          parentWidth * 0.01, 5, 5, 5),
                                      child: Text(
                                          style: Fonts_mode.graySubtitle(
                                              isDarkTheme),
                                          widget.parent.name),
                                    ),
                                  )
                                ],
                              )
                            ]),
                        flex: 20),
                    Expanded(
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
                                  backgroundColor: _isSaveButtonActive
                                      ? activeButtonColor
                                      : unselectedToggleColor),
                            )),
                        flex: 2)
                  ]),
                )),
            onTap: () => () {
                  isDarkTheme ? Vibration.vibrate(duration: 100) : null;
                  Utils.tryToLostFocus(context);
                }));
  }

  void submit() {
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;

    isDarkTheme ? HapticFeedback.selectionClick() : null;
    widget.task.name = newTaskController.text;
    Provider.of<TasksState>(context, listen: false).updateTask(widget.task);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    newTaskController = TextEditingController(text: widget.task.name);
    newTaskController.addListener(() {
      setState(() {
        _isSaveButtonActive = newTaskController.text.isNotEmpty;
      });
    });
  }
}
