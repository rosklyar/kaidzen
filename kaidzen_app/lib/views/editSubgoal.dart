import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/emotions/EmotionsState.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(widget.parent.category.backgroundColor),
          centerTitle: true,
          title: Wrap(children: [
            Padding(
              padding: EdgeInsets.only(top: 5, right: 15),
              child: Icon(Icons.circle_rounded,
                  color: widget.parent.category.color,
                  size: 10.0 + Difficulty.EASY.id * 3),
            ),
            const Text('Edit subgoal'),
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
                        hintText: 'Subtask title',
                        labelText: 'Subtask title'),
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
                      child: const Text('Save',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ))),
            flex: 1)
      ]),
    );
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
  }
}
