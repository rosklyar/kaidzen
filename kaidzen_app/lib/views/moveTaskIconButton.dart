import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';

class MoveTaskIconButton extends StatelessWidget {
  const MoveTaskIconButton({
    Key? key,
    required this.task,
    required this.direction,
  }) : super(key: key);

  final Direction direction;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: direction == Direction.FORWARD
            ? Image.asset("assets/right_active.png")
            : Image.asset("assets/left_active.png"),
        color: Theme.of(context).errorColor,
        onPressed: () async {
          await moveTask(context, task);
        });
  }

  Future<void> moveTask(BuildContext context, Task task) async {
    debugPrint('move task:');
    var newStatus = direction == Direction.FORWARD
        ? task.status == Status.DOING
            ? Status.DONE
            : Status.DOING
        : task.status == Status.DOING
            ? Status.TODO
            : Status.DOING;
    debugPrint('move task:' + newStatus);
    await Provider.of<TasksState>(context, listen: false)
        .moveTaskAndNotify(task, newStatus);
  }
}

enum Direction { FORWARD, BACKWARD }
