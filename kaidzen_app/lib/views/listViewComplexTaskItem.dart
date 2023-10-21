import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/views/createSubgoal.dart';
import 'package:kaidzen_app/views/listViewSubTaskItem.dart';

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
          child: ListViewSubTaskItem(task: subtask)));
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
                    builder: (context) => CreateSubGoal(task)));
          },
        ),
        title: const Text('Add subgoal',
            style: TextStyle(decoration: TextDecoration.underline)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateSubGoal(task)));
        },
      ),
    ));
  }

  return columnContent;
}
