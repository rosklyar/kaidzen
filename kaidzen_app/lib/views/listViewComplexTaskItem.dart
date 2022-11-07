import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/utils/margin.dart';
import 'package:kaidzen_app/utils/theme.dart';
import 'package:kaidzen_app/views/createSubgoal.dart';
import 'package:kaidzen_app/views/viewGoal.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../utils/dashSeparator.dart';
import 'ListViewTaskItem.dart';

class ListViewComplexTaskItem extends StatelessWidget {
  ListViewComplexTaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.only(right: 30),
      title: ListViewTaskItem(task: task),
      //tilePadding: const EdgeInsets.all(5),
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

  columnContent.add(const DashSeparator());
  var divider = Container(
    child: const DashSeparator(),
    padding: const EdgeInsets.only(left: 40),
  );
  for (Task subtask in task.subtasks) {
    if (subtask.status == task.status) {
      columnContent.add(Container(
          padding: const EdgeInsets.fromLTRB(25, 10, 5, 5),
          child: ListViewTaskItem(task: subtask)));
      columnContent.add(divider);
    }
  }

  if (task.status == Status.TODO && task.parent == null) {
    columnContent.add(Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
      child: ListTile(
        horizontalTitleGap: 1,
        leading: IconButton(
          icon: Image.asset("assets/plus_in_circle.png"),
          color: Theme.of(context).errorColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateSubGoal(parent: task)));
          },
        ),
        title: const Text('Add subgoal',
            style: TextStyle(decoration: TextDecoration.underline)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateSubGoal(parent: task)));
        },
      ),
    ));
  }

  return columnContent;
}
