import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/widgets/taskType.dart';
import 'package:kaidzen_app/widgets/taskDifficulty.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';

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

  @override
  void initState() {
    super.initState();
    newTaskController = TextEditingController(text: widget.task.name);
    _currentCategory = widget.task.category.id;
    _currentDifficulty = widget.task.difficulty.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
            child: Stack(fit: StackFit.expand, children: [
              Column(children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10),
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
                          const Expanded(
                              child: Center(
                                  child: Text(
                                "Goal",
                                style: screenTytleTextStyle,
                              )),
                              flex: 9),
                          const Expanded(child: SizedBox(), flex: 1)
                        ])),
                    flex: 3),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    newTaskController.clear();
                                    _taskTypeWidgetKey.currentState!._value =
                                        -1;
                                  },
                                  icon: Visibility(
                                      visible:
                                          newTaskController.text.isNotEmpty,
                                      child: SvgPicture.asset(
                                          "assets/close-grey.svg"))),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                      color: inputInactiveBorderColor)),
                              hintStyle: inputHintTextStyle),
                          controller: newTaskController,
                        )),
                    flex: 3),
                const Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: SizedBox(
                            width: double.infinity,
                            child: Text("Life sphere to be affected",
                                textAlign: TextAlign.left,
                                style: largeTextStyle))),
                    flex: 1),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TaskTypeWidget(
                            key: _taskTypeWidgetKey,
                            callback: (value) => setState(() {
                                  _currentCategory = value!;
                                }),
                            initialCategory: _currentCategory)),
                    flex: 4),
                Expanded(child: getDiff(), flex: 7),
              ])
            ]),
            flex: 9),
        Expanded(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submit,
                      child: Text('Save',
                          style:
                              largeTextStyle20.copyWith(color: Colors.white)),
                      style:
                          ElevatedButton.styleFrom(primary: activeButtonColor),
                    ))),
            flex: 1)
      ]),
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
                style: largeTextStyle,
              ))),
      Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
          child: SizedBox(
              width: double.infinity,
              child: TaskDifficultyWidget(
                  key: _taskDifficultyWidgetKey,
                  callback: (value) => _currentDifficulty = value!,
                  initialDifficulty: _currentDifficulty)))
    ]);
  }

  void submit() {
    var category = DevelopmentCategory.values
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
