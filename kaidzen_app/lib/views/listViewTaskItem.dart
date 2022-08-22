import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/utils/margin.dart';
import 'package:kaidzen_app/utils/theme.dart';
import 'package:kaidzen_app/views/viewTask.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../service/ProgressState.dart';
import 'MoveTaskIconButton.dart';
import 'createTask.dart';

class ListViewTaskItem extends ListTile {
  const ListViewTaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.circle_rounded, color: task.category.color, size: 20.0 + task.difficulty.id * 3),
      title: Text(task.name),
      trailing: ListTileTrail(task: task),
      onTap: () {
        Navigator.push(context,
              MaterialPageRoute(builder: (context) => ViewTask(task)));
      },
      selected: false,
    );
  }
}

ExpandablePanel taskWithSubtasks(Task task) {
    debugPrint("ExpandablePanel: rebuild");
    List<Task> subtasks = task.subtasks;
    debugPrint("ExpandablePanel: $subtasks");
    return ExpandablePanel(
        header: ListViewTaskItem(task: task),
        collapsed: const SizedBox.shrink(),
        expanded: ReorderableListView(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                scrollController: ScrollController(),
                onReorder: (int oldIndex, int newIndex) {  },
                children: List.generate(
                  subtasks.length,
                  (index) {
                    return Dismissible(
                      key: Key(subtasks[index].id.toString()),
                      // Show a red background as the item is swiped away.
                      background: Container(color: Colors.red),
                      child: Column(key: Key('$index'), children: [
                        Container(
                          color: Color.fromARGB(255, 138, 192, 170),
                          child: ListViewTaskItem(task: subtasks[index]),
                        ),
                        Container(padding: const EdgeInsets.all(5)),
                      ]),
                    );
                  },
                ),
              ));
  }

class ListTileTrail extends StatelessWidget {
  const ListTileTrail({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    if(task.subtasks.isNotEmpty) {
      return const SizedBox.shrink();
    }
    return task.status == Status.DONE
        ? DoneIconButton(task: task)
        : MoveTaskIconButton(task: task, direction: Direction.FORWARD);
  }
}

class DoneIconButton extends StatelessWidget {
  const DoneIconButton({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.done, color: black),
        color: Theme.of(context).errorColor,
        onPressed: () {});
  }
}
