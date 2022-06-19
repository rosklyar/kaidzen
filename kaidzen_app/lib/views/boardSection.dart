import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';

import 'package:kaidzen_app/utils/margin.dart';
import 'package:kaidzen_app/utils/theme.dart';

class BoardSection extends StatefulWidget {
  const BoardSection({Key? key}) : super(key: key);

  @override
  BoardSectionState createState() => BoardSectionState();
}

class BoardSectionState extends State<BoardSection> {
  List<Task> tasks = [
    Task('Do this', subtasks: [
      Task('DO that'),
      Task('AND that'),
      Task('EVEN that'),
      Task('AND EVEN that')
    ]),
    Task('Do that'),
    Task('Clean room'),
    Task('Do not forget about 1st task'),
    Task('Visit dentist'),
    Task('Read Berlin diary 1'),
    Task('Read Berlin diary 2'),
    Task('Read Berlin diary 3'),
  ];

  @override
  void initState() {
    setState(() {
      tasks;
    });
    super.initState();
  }

  void addItem(Task newTask) {
    tasks.add(newTask);
    initState();
  }

  @override
  Widget build(BuildContext context) {
    return Board(
      list: tasks,
    );
  }
}

class Board extends StatefulWidget {
  const Board({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List<Task> list;

  @override
  _BoardState createState() => _BoardState(this.list);
}

class _BoardState extends State<Board> {
  _BoardState(this.list);
  List<Task> list;

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final Task item = list.removeAt(oldIndex);
        list.insert(newIndex, item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              height: context.screenHeight(1),
              width: context.screenWidth(1),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              decoration: const BoxDecoration(
                color: Color(0xfff0f2f5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(0),
                ),
              ),
              child: ReorderableListView(
                onReorder: _onReorder,
                scrollController: ScrollController(),
                // buildDraggableFeedback: (a, b, c) => Container(),
                children: List.generate(
                  widget.list.length,
                  (index) {
                    return ListViewCard(
                      widget.list[index],
                      index,
                      Key('$index'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}

class ListViewCard extends StatefulWidget {
  final int index;
  final Key key;
  final Task task;

  ListViewCard(this.task, this.index, this.key);

  @override
  _ListViewCard createState() => _ListViewCard();
}

class _ListViewCard extends State<ListViewCard> {
  final newTaskController = TextEditingController();

  void _onSubtasksReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final Task item = widget.task.subtasks.removeAt(oldIndex);
        widget.task.subtasks.insert(newIndex, item);
      },
    );
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.task.hasSubtasks()
        ? ExpandablePanel(
            header: buildContainer('(' +
                widget.task.subtasks.length.toString() +
                ')' +
                widget.task.name),
            collapsed: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'New subtask',
              onPressed: () async {
                String? text = await openDialog();
                setState(() {
                  widget.task.addSubTask(Task(text!));
                });
              },
            ),
            expanded: Container(
              height: (70 * widget.task.subtasks.length).ceilToDouble(),
              width: context.screenWidth(1),
              margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              decoration: const BoxDecoration(
                color: Color(0xfff0f2f5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(0),
                ),
              ),
              child: ReorderableListView(
                onReorder: _onSubtasksReorder,
                scrollController: ScrollController(),
                // buildDraggableFeedback: (a, b, c) => Container(),
                children: List.generate(
                  widget.task.subtasks.length,
                  (index) {
                    return ListViewCard(
                      widget.task.subtasks[index],
                      index,
                      Key('$index'),
                    );
                  },
                ),
              ),
            ))
        : buildContainer(widget.task.name);
  }

  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('New subtask'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'What should be done?'),
              controller: newTaskController,
            ),
            actions: [
              TextButton(onPressed: submit, child: Text("Create")),
            ],
          ));
  void submit() {
    Navigator.of(context).pop(newTaskController.text);
  }

  Widget buildContainer(String name) {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 18, 15, 0),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(9),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.2),
                blurRadius: 10,
              )
            ]),
        child: Container(
          height: 20,
          width: 200,
          child: ListView(
            padding: EdgeInsets.all(0),
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                margin: EdgeInsets.only(right: 6),
                child: Center(
                  child: Text(name,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Colors.grey[400],
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}

extension Num on num {
  double nextMax(num max) {
    return this + (max - this) * Random().nextDouble();
  }
}
