import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/utils/theme.dart';
import 'package:kaidzen_app/views/viewGoal.dart';

import '../assets/constants.dart';
import 'MoveTaskIconButton.dart';

class ListViewSubTaskItem extends ListTile {
  const ListViewSubTaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.shortenedName(75),
        style: Fonts.largeBoldTextStyle,
      ),
      horizontalTitleGap: -10,
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
