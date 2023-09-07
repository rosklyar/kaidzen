import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/views/viewGoal.dart';

import '../assets/constants.dart';
import 'MoveTaskIconButton.dart';
import 'doneIconButton.dart';

class ListViewTaskItem extends ListTile {
  const ListViewTaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //contentPadding: EdgeInsets.symmetric(horizontal: 16),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.circle_rounded,
              color: task.category.color, size: 8.0 + task.difficulty.id * 4),
        ],
      ),
      title: Text(
        task.shortenedName(75),
        style: Fonts.largeBoldTextStyle,
      ),
      horizontalTitleGap: -10,
      subtitle: Text('For ' + task.category.nameLowercase, style: Fonts.graySubtitle,),
      trailing: ListTileTrail(task: task),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                settings: const RouteSettings(name: "parentTask"),
                builder: (context) => ViewGoal(task)));
      },
      selected: false,
    );
  }
}

class ListTileTrail extends StatelessWidget {
  const ListTileTrail({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    if (task.subtasks.isNotEmpty) {
      return const SizedBox.shrink();
    }
    return task.status == Status.DONE
        ? const DoneIconButton()
        : MoveTaskIconButton(task: task, direction: Direction.FORWARD);
  }
}