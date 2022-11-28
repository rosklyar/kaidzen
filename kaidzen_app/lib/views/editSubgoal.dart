import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/views/utils.dart';

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
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: GestureDetector(
            child: Container(
                color: Color(widget.parent.category.backgroundColor),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Expanded(
                        child: Row(children: [
                          Expanded(
                              child: IconButton(
                                icon: SvgPicture.asset(
                                    "assets/shevron-left-black.svg"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              flex: 1),
                          Expanded(
                              child: Center(
                                  child: Text('Edit subgoal',
                                      style: Fonts.screenTytleTextStyle)),
                              flex: 8),
                          const Expanded(child: SizedBox(), flex: 1)
                        ]),
                        flex: 2),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
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
                                  Image.asset("assets/back_arrow.png"),
                                  Text(
                                      style:
                                          const TextStyle(color: Colors.grey),
                                      widget.parent.name)
                                ],
                              )
                            ]),
                        flex: 16),
                    Expanded(
                        child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black),
                              onPressed: submit,
                              child: const Text('Save',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
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
  }
}
