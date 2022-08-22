import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/utils/margin.dart';
import 'package:kaidzen_app/utils/theme.dart';
import 'package:kaidzen_app/views/createSubTask.dart';
import 'package:kaidzen_app/views/viewTask.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../service/ProgressState.dart';
import 'ListViewTaskItem.dart';
import 'createTask.dart';

class ListViewComplexTaskItem extends StatelessWidget {
  ListViewComplexTaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListViewTaskItem(task: task),
      tilePadding: const EdgeInsets.all(5),
      children: <Widget>[
        Column(
          children: buildExpandableContent(context, task),
        ),
      ],
    );
  }
}

List<Widget> buildExpandableContent(BuildContext context, Task task) {
  List<Widget> columnContent = [];

  for (Task subtask in task.subtasks) {
    if (subtask.status == task.status) {
      columnContent.add(Container(
          padding: const EdgeInsets.fromLTRB(25, 10, 5, 5),
          child: ListViewTaskItem(task: subtask)));
    }
  }

  if (task.status == Status.TODO && task.parent == null) {
    columnContent.add(Container(
      padding: const EdgeInsets.fromLTRB(25, 10, 5, 5),
      child: ListTile(
        title: const Text('Add subtask',
            style: TextStyle(decoration: TextDecoration.underline)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateSubTask(parent: task)));
        },
      ),
    ));
  }

  return columnContent;
}
