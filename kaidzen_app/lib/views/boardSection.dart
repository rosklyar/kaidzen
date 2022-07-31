import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/utils/margin.dart';
import 'package:kaidzen_app/utils/theme.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../service/ProgressState.dart';

class Board extends StatefulWidget {
  const Board({
    Key? key,
    required this.name,
    required this.list,
  }) : super(key: key);

  final List<Task> list;
  final String name;

  @override
  // ignore: no_logic_in_create_state
  BoardState createState() {
    debugPrint('createState:');
    return BoardState();
  }
}

class BoardState extends State<Board> {
  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final Task item = widget.list.removeAt(oldIndex);
        widget.list.insert(newIndex, item);
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
                    return Dismissible(
                      key: Key(widget.list[index].id.toString()),
                      onDismissed: (direction) async {
                        await Provider.of<TasksState>(context, listen: false)
                            .deleteTask(widget.list[index]);
                      },
                      // Show a red background as the item is swiped away.
                      background: Container(color: Colors.red),
                      child: ListViewCard(
                        widget.list[index],
                        index,
                        key: Key('$index'),
                        boardName: widget.name,
                      ),
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
  final Task task;
  final String? boardName;

  const ListViewCard(this.task, this.index, {Key? key, this.boardName})
      : super(key: key);

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
    return widget.task.hasSubtasks() &&
            [Boards.DO, Boards.DONE].contains(widget.boardName)
        ? taskWithSubtasks(context, widget.task, widget.boardName!)
        : buildContainer(widget.task);
  }

  ExpandablePanel taskWithSubtasks(
      BuildContext context, Task task, String boardName) {
    debugPrint("ExpandablePanel: rebuild");
    List<Task> subtasks = boardName == Boards.DO
        ? widget.task.subtasks.where((st) => st.status == Status.TODO).toList()
        : widget.task.subtasks.where((st) => st.status == Status.DONE).toList();
    debugPrint("ExpandablePanel: $subtasks");
    return ExpandablePanel(
        header: buildContainer(task),
        collapsed: const SizedBox.shrink(),
        expanded: Container(
          height: (70 * subtasks.length).ceilToDouble(),
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
              subtasks.length,
              (index) {
                return Dismissible(
                    key: Key(subtasks[index].id.toString()),
                    onDismissed: (direction) async {
                      await Provider.of<TasksState>(context, listen: false)
                          .deleteTask(subtasks[index]);
                    },
                    // Show a red background as the item is swiped away.
                    background: Container(color: Colors.red),
                    child: ListViewCard(
                      subtasks[index],
                      index,
                      key: Key('$index'),
                      boardName: boardName,
                    ));
              },
            ),
          ),
        ));
  }

  Future<String?> openDialog(Task parent) => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('New subtask'),
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

  Widget buildContainer(Task task) {
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
                child: Row(children: [
                  Visibility(
                    visible: task.status != Status.TODO,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_left),
                      onPressed: () async {
                        await Provider.of<TasksState>(context, listen: false)
                            .moveTaskAndNotify(
                                task,
                                task.status == Status.DOING
                                    ? Status.TODO
                                    : Status.DOING);
                      },
                    ),
                  ),
                  Center(
                    child: Text(task.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: Colors.grey[400],
                        )),
                  ),
                  Visibility(
                    visible: task.status != Status.DONE && !task.hasSubtasks(),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_right),
                      onPressed: () async {
                        var newStatus = task.status == Status.DOING
                            ? Status.DONE
                            : Status.DOING;
                        await Provider.of<TasksState>(context, listen: false)
                            .moveTaskAndNotify(task, newStatus);
                        if (newStatus == Status.DONE) {
                          var progressState = Provider.of<ProgressState>(
                              context,
                              listen: false);
                          progressState.updateProgress(task);
                          await Provider.of<AchievementsState>(context,
                                  listen: false)
                              .addEvent(
                                  Event(EventType.completed, DateTime.now()));
                        }
                      },
                    ),
                  ),
                  Visibility(
                                      visible: task.status == Status.TODO && task.parent == null,
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () async {
                                          String? text = await openDialog(widget.task);
                                          String? text = await openDialog(widget.task);
                                                          setState(() {
                                                            widget.task.addSubTask(Task(
                                                                text!, widget.task.category, widget.task.difficulty));
                                                          });
                                          addSubtask(Task(
                                                                                                                     text!, widget.task.category, widget.task.difficulty));
                                                                                                               });
                                        },
                                      ),
                                    )Ï
                ]),
              ),
            ],
          ),
        ));
  }

  Future<void> addSubtask(
      String? text, Task parentTask, BuildContext context) async {
    Task newSubtask = Task(text!, parent: parentTask.id);
    parentTask.addSubTask(newSubtask);
    await Provider.of<TasksState>(context, listen: false).addTask(newSubtask);
  }
}

extension Num on num {
  double nextMax(num max) {
    return this + (max - this) * Random().nextDouble();
  }
}
