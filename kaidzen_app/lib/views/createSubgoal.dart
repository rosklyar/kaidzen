import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/assets/constants.dart';

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
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(widget.parent.category.backgroundColor),
          centerTitle: true,
          title: Wrap(children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 15),
              child: Icon(Icons.circle_rounded,
                  color: widget.parent.category.color,
                  size: 10.0 + Difficulty.EASY.id * 3),
            ),
            const Text('Subgoal'),
          ])),
      body: Column(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Subgoal title',
                        labelText: 'Subgoal title'),
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
                      style: const TextStyle(color: Colors.grey),
                      widget.parent.name)
                ],
              )
            ]),
            flex: 7),
        Expanded(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20)),
                      onPressed: submit,
                      child: const Text('Create',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ))),
            flex: 1)
      ]),
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
    newTaskController = TextEditingController();
  }
}
