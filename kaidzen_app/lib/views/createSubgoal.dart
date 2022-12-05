import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/views/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';
import '../utils/snackbar.dart';

class CreateSubGoal extends StatefulWidget {
  final Task parent;
  final String? popTarget;

  const CreateSubGoal(this.parent, {Key? key, this.popTarget})
      : super(key: key);

  @override
  State<CreateSubGoal> createState() {
    return _CreateSubGoalState();
  }
}

class _CreateSubGoalState extends State<CreateSubGoal> {
  late TextEditingController newTaskController;
  bool _isCreateButtonActive = false;

  @override
  Widget build(BuildContext context) {
    var parentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/shevron-left-black.svg"),
          onPressed: () {
            if (widget.popTarget == null) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              Navigator.of(context)
                  .popUntil(ModalRoute.withName(widget.popTarget!));
            }
          },
        ),
        title: Text(
          "Subgoal",
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
                                          parentWidth * 0.03, 0, 5, 8),
                                      child:
                                          Image.asset("assets/back_arrow.png")),
                                  SizedBox(
                                    width: parentWidth * 0.8,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          parentWidth * 0.01, 5, 5, 5),
                                      child: Text(
                                          style: Fonts.graySubtitleMedium,
                                          widget.parent.name),
                                    ),
                                  )
                                ],
                              )
                            ]),
                        flex: 13),
                    Expanded(
                        child: Column(
                          children: [
                            Expanded(
                                child: GestureDetector(
                                    child: Text('Create and start another one',
                                        style: Fonts.largeTextStyle.copyWith(
                                            decoration:
                                                TextDecoration.underline)),
                                    onTap: () {
                                      submit();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateSubGoal(
                                                    widget.parent,
                                                    popTarget: widget.popTarget,
                                                  )));
                                      showDefaultTopFlushbar(
                                          "Subgoal created", context);
                                    }),
                                flex: 3),
                            Expanded(
                                child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: _isCreateButtonActive
                                              ? activeButtonColor
                                              : unselectedToggleColor),
                                      onPressed: () {
                                        if (_isCreateButtonActive) {
                                          submit();
                                          if (widget.popTarget == null) {
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          } else {
                                            Navigator.of(context).popUntil(
                                                ModalRoute.withName(
                                                    widget.popTarget!));
                                          }
                                          showDefaultTopFlushbar(
                                              "Subgoal created", context);
                                        }
                                      },
                                      child: Text('Create',
                                          style: _isCreateButtonActive
                                              ? Fonts.largeTextStyle20
                                                  .copyWith(color: Colors.white)
                                              : Fonts.largeTextStyle20),
                                    )),
                                flex: 4),
                          ],
                        ),
                        flex: 3)
                  ]))),
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
    newTaskController.addListener(() {
      setState(() {
        _isCreateButtonActive = newTaskController.text.isNotEmpty;
      });
    });
  }
}
