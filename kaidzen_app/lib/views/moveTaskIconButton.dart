import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../utils/snackbar.dart';

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
    var newStatus = direction == Direction.FORWARD
        ? task.status == Status.DOING
            ? Status.DONE
            : Status.DOING
        : task.status == Status.DOING
            ? Status.TODO
            : Status.DOING;

    var tasksState = Provider.of<TasksState>(context, listen: false);
    if (lastSubtaskIsDone(newStatus, task, tasksState)) {
      await showModalRegardingParent(context, tasksState, task, newStatus);
    } else {
      await Provider.of<TasksState>(context, listen: false)
          .moveTaskAndNotify(task, newStatus);
      showTutorialTopFlushbar('Moved to $newStatus', context);
    }
  }

  Future<void> showModalRegardingParent(BuildContext context,
      TasksState tasksState, Task task, String newStatus) async {
    var parentHeight = MediaQuery.of(context).size.height;
    var parentWidth = MediaQuery.of(context).size.width;
    var parentTask = tasksState.getById(task.parent!)!;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Center(
            child: Column(
              children: <Widget>[
                const Expanded(child: SizedBox(), flex: 2),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: SizedBox(
                        width: parentWidth * 0.9,
                        child: Text(
                            "You have completed the last subgoal and '" +
                                parentTask.shortenedName(50) +
                                "' is about to be moved to 'Done'",
                            style: Fonts.largeBoldTextStyle),
                      ),
                    ),
                    flex: 5),
                Expanded(
                    child: GestureDetector(
                        child: Text('I want to keep it in \'Do\'',
                            style: Fonts.largeTextStyle.copyWith(
                                decoration: TextDecoration.underline)),
                        onTap: () {
                          Provider.of<TasksState>(context, listen: false)
                              .moveSubtaskOnlyAndNotify(task, newStatus);
                          Navigator.pop(context);
                        }),
                    flex: 2),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            right: 15, left: 15, bottom: 20),
                        child: SizedBox(
                            height: parentHeight * 0.08,
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text('Ok',
                                  style: Fonts.largeTextStyle20
                                      .copyWith(color: Colors.white)),
                              onPressed: () async {
                                await Provider.of<TasksState>(context,
                                        listen: false)
                                    .moveTaskAndNotify(task, newStatus);
                                Navigator.pop(context);
                                showTutorialTopFlushbar(
                                    'Moved to $newStatus', context);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: activeButtonColor),
                            ))),
                    flex: 3),
              ],
            ),
          ),
        );
      },
    );
  }

  bool lastSubtaskIsDone(String newStatus, Task task, TasksState tasksState) =>
      newStatus == Status.DONE &&
      task.isSubtask() &&
      tasksState.getById(task.parent!)!.uncompletedSubtaskCount() == 1;

  String getNewStatus() {
    if (direction == Direction.FORWARD && task.hasSubtasks()) {
      return Status.TODO;
    } else {
      return direction == Direction.FORWARD
          ? task.status == Status.DOING
              ? Status.DONE
              : Status.DOING
          : task.status == Status.DOING
              ? Status.TODO
              : Status.DOING;
    }
  }
}

enum Direction { FORWARD, BACKWARD }
