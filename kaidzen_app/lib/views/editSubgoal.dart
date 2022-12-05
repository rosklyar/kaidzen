import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/views/utils.dart';

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
    var parentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: SvgPicture.asset("assets/shevron-left-black.svg"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Edit subgoal",
            style: Fonts.screenTytleTextStyle,
          ),
          centerTitle: true,
          backgroundColor: Color(widget.parent.category.backgroundColor),
        ),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
            child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                color: Color(widget.parent.category.backgroundColor),
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
                                        hintStyle: Fonts.inputHintTextStyle),
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
                                          style: Fonts.graySubtitle,
                                          widget.parent.name),
                                    ),
                                  )
                                ],
                              )
                            ]),
                        flex: 16),
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
                                  primary: _isSaveButtonActive
                                      ? activeButtonColor
                                      : unselectedToggleColor),
                            )),
                        flex: 2)
                  ]),
                )),
            onTap: () => Utils.tryToLostFocus(context)));
  }

  void submit() {
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
