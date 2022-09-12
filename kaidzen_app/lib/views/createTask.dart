import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/models/insparation.dart';
import 'package:kaidzen_app/views/listViewTaskItem.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../achievements/AchievementsState.dart';
import '../achievements/event.dart';
import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';

class CreateTask extends StatefulWidget {
  final Task? parent;

  const CreateTask({Key? key, this.parent}) : super(key: key);

  @override
  State<CreateTask> createState() {
    return _CreateTaskState();
  }
}

class _CreateTaskState extends State<CreateTask> {
  late TextEditingController newTaskController;
  int _currentCategory = -1;
  int _currentDifficulty = 0;
  bool _isCreateButtonActive = false;
  late Future<List<Inspiration>>? _inspirationsFuture;
  final GlobalKey<_TaskTypeWidgetState> _taskTypeWidgetKey = GlobalKey();
  final GlobalKey<_TaskDifficultyWidgetState> _taskDifficultyWidgetKey =
      GlobalKey();

  @override
  void initState() {
    super.initState();
    _inspirationsFuture = getInspirations(context);
    newTaskController = TextEditingController();
    newTaskController.addListener(() {
      setState(() {
        _isCreateButtonActive = newTaskController.text.isNotEmpty;
      });
    });
  }

  static Future<List<Inspiration>> getInspirations(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data =
        await assetBundle.loadString('assets/inspiration/inspirations.json');
    final body = json.decode(data);
    return body.map<Inspiration>((json) => Inspiration.fromJson(json)).toList();
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
                              hintText: 'Goal title',
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
                                }))),
                    flex: 4),
                Expanded(child: getDiff(), flex: 7),
              ]),
              Visibility(
                  visible: newTaskController.text.isEmpty,
                  child: SlidingUpPanel(
                      minHeight: MediaQuery.of(context).size.height * 0.25,
                      panelBuilder: (sc) => inspirationsWidget(context)))
            ]),
            flex: 9),
        Expanded(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isCreateButtonActive
                          ? () {
                              submit();
                            }
                          : null,
                      child: Text('Create',
                          style: _isCreateButtonActive
                              ? largeTextStyle20.copyWith(color: Colors.white)
                              : largeTextStyle20),
                      style: ElevatedButton.styleFrom(
                          primary: _isCreateButtonActive
                              ? activeButtonColor
                              : unselectedToggleColor),
                    ))),
            flex: 1)
      ]),
    );
  }

  Widget inspirationsWidget(BuildContext context) {
    return FutureBuilder<List<Inspiration>>(
        future: _inspirationsFuture,
        builder: (ctx, snapshot) {
          final inspirations = snapshot.hasData ? snapshot.data! : [];
          return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: inspirations.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                        height: 30,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Icon(Icons.circle_rounded,
                                    color: inspirations[index].category.color,
                                    size: 10.0),
                                const SizedBox(width: 5),
                                Text(
                                  inspirations[index].title,
                                  style: mediumTextStyle,
                                  textAlign: TextAlign.left,
                                )
                              ]),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      newTaskController.text =
                                          inspirations[index].title;
                                      _taskTypeWidgetKey.currentState!._value =
                                          inspirations[index].category.id;
                                      _currentCategory =
                                          inspirations[index].category.id;
                                      _taskDifficultyWidgetKey.currentState!
                                              ._currentDifficulty =
                                          inspirations[index].difficulty.id;
                                      _currentDifficulty =
                                          inspirations[index].difficulty.id;
                                    });
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/shevron-right-black.svg"))
                            ]));
                  }));
        });
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
                  callback: (value) => _currentDifficulty = value!)))
    ]);
  }

  void submit() {
    var category = DevelopmentCategory.values
        .firstWhere((element) => element.id == _currentCategory);
    Provider.of<TasksState>(context, listen: false).addTask(Task(
        newTaskController.text,
        category,
        Difficulty.values
            .firstWhere((element) => element.id == _currentDifficulty),
        parent: widget.parent != null ? widget.parent!.id : null));
    Provider.of<AchievementsState>(context, listen: false)
        .addEvent(Event(EventType.taskCreated, DateTime.now(), category));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }
}

class TaskTypeWidget extends StatefulWidget {
  final void Function(int?)? callback;
  const TaskTypeWidget({Key? key, required this.callback}) : super(key: key);
  @override
  State<TaskTypeWidget> createState() {
    return _TaskTypeWidgetState(callback);
  }
}

class _TaskTypeWidgetState extends State<TaskTypeWidget> {
  final void Function(int?)? callback;
  _TaskTypeWidgetState(this.callback);
  int? _value = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Wrap(
            spacing: 10,
            children: activeCategories
                .map((cat) => ChoiceChip(
                      selectedColor: selectedToggleColor,
                      disabledColor: unselectedToggleColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      label: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.circle, color: cat.color, size: 7),
                            const SizedBox(width: 5),
                            Text(cat.name,
                                style: cat.index == _value
                                    ? mediumWhiteTextStyle
                                    : mediumTextStyle)
                          ])),
                      selected: _value == cat.index,
                      onSelected: (bool selected) {
                        setState(() {
                          _value = selected ? cat.index : _value;
                        });
                        callback?.call(_value);
                      },
                    ))
                .toList()));
  }
}

class TaskDifficultyWidget extends StatefulWidget {
  final void Function(int?)? callback;
  const TaskDifficultyWidget({Key? key, required this.callback})
      : super(key: key);

  @override
  State<TaskDifficultyWidget> createState() {
    return _TaskDifficultyWidgetState(callback);
  }
}

class _TaskDifficultyWidgetState extends State<TaskDifficultyWidget> {
  final void Function(int?)? callback;
  _TaskDifficultyWidgetState(this.callback);
  int? _currentDifficulty = 0;

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: double.infinity,
      activeBgColor: const [selectedToggleColor],
      activeFgColor: Colors.white,
      inactiveBgColor: unselectedToggleColor,
      inactiveFgColor: activeButtonColor,
      initialLabelIndex: _currentDifficulty,
      dividerColor: selectedToggleColor,
      totalSwitches: 3,
      cornerRadius: 5,
      labels: [
        Difficulty.EASY.name,
        Difficulty.MEDIUM.name,
        Difficulty.HARD.name
      ],
      onToggle: (index) {
        setState(() {
          _currentDifficulty = index;
        });
        callback?.call(_currentDifficulty);
      },
    );
  }
}
