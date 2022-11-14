import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/views/utils.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';

class CreateSubGoal extends StatefulWidget {
  final Task parent;

  const CreateSubGoal({Key? key, required this.parent}) : super(key: key);

  @override
  State<CreateSubGoal> createState() {
    return _CreateSubGoalState();
  }
}

class _CreateSubGoalState extends State<CreateSubGoal> {
  late TextEditingController newTaskController;

  @override
  Widget build(BuildContext context) {
    var parentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(widget.parent.category.backgroundColor),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          centerTitle: true,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName("parentTask"));
            },
          ),
          backgroundColor: Colors.white.withOpacity(0),
          title: Wrap(children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 15),
              child: Icon(Icons.circle_rounded,
                  color: widget.parent.category.color,
                  size: 10.0 + Difficulty.EASY.id * 3),
            ),
            Text('Subgoal', style: Fonts.screenTytleTextStyle),
          ])),
      body: GestureDetector(
          child: Column(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 16),
                          child: TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Subgoal title',
                                labelText: 'Subgoal title',
                                hintStyle: Fonts.inputHintTextStyle),
                            controller: newTaskController,
                          )),
                      Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 5),
                            child: Image.asset("assets/back_arrow.png"),
                          ),
                          Text(
                              style: Fonts.graySubtitle,
                              widget.parent.shortenedName(200))
                        ],
                      )
                    ]),
                flex: 7),
            Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: parentHeight * 0.01),
                      child: GestureDetector(
                          child: Text('Create and start another one',
                              style: Fonts.largeTextStyle.copyWith(
                                  decoration: TextDecoration.underline)),
                          onTap: () {
                            submit();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateSubGoal(parent: widget.parent)));
                          }),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            right: 15, left: 15, bottom: parentHeight * 0.001),
                        child: SizedBox(
                            height: parentHeight * 0.07,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: activeButtonColor),
                              onPressed: () {
                                submit();
                                Navigator.pop(context);
                              },
                              child: Text('Create',
                                  style: Fonts.largeTextStyle20
                                      .copyWith(color: Colors.white)),
                            ))),
                  ],
                ),
                flex: 1)
          ]),
          onTap: () => Utils.tryToLostFocus(context)),
    );
  }

  void submit() {
    Provider.of<TasksState>(context, listen: false).addTask(Task(
        newTaskController.text, widget.parent.category, Difficulty.EASY,
        parent: widget.parent.id));

    var event =
        Event(EventType.taskCreated, DateTime.now(), widget.parent.category);
    Provider.of<AchievementsState>(context, listen: false).addEvent(event);
    Provider.of<EmotionsState>(context, listen: false)
        .updateEmotionPoints(event);
  }

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    newTaskController = TextEditingController();
  }
}
