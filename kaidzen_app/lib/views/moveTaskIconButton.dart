import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaidzen_app/assets/light_dark_theme.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../assets/constants.dart';
import '../main.dart';
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
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;

    return IconButton(
      // Use a smaller icon size if needed
      iconSize:
          24, // Adjust this value to make the clickable area smaller or larger
      onPressed: () async {
        // isDarkTheme ? HapticFeedback.lightImpact() : null;
        await moveTask(context, task);
      },
      icon: Container(
        width: 32, // Set the width of the square
        height: 32, // Set the height of the square
        padding: const EdgeInsets.all(
            2), // Adjust padding to make the icon smaller within the square
        decoration: BoxDecoration(
          color: dark_light_modes.cardMoveButtonColor(
              isDarkTheme), // Background color of the square
          shape: BoxShape.rectangle, // Makes the container a square
          borderRadius: BorderRadius.circular(4),
          // Rounded corners of the square
        ),
        child: Icon(
          direction == Direction.FORWARD
              ? Icons.arrow_forward_rounded
              : Icons.arrow_back_rounded,
          size: 24, // Adjust the icon size inside the square
          color: dark_light_modes.statusIcon(isDarkTheme), // Icon color
        ),
      ),
    );
  }

  Future<void> moveTask(BuildContext context, Task task) async {
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;
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
          .moveTaskAndNotify(task, newStatus, context, false);
      showTutorialTopFlushbar('Moved to $newStatus', context);
      // showDarkThemeFlushbar(newStatus, context, task);
      newStatus == 'DONE'
          ? isDarkTheme
              ? Vibration.vibrate(duration: 100)
              : null
          : isDarkTheme
              ? HapticFeedback.mediumImpact()
              : null;
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
        final themeProvider =
            Provider.of<DarkThemeProvider>(context, listen: false);
        bool isDarkTheme = themeProvider.darkTheme;
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
                            style: Fonts_mode.largeBoldTextStyle(isDarkTheme)),
                      ),
                    ),
                    flex: 5),
                Visibility(
                  visible: parentTask.id != 0,
                  child: Expanded(
                      child: GestureDetector(
                          child: Text('I want to keep it in \'Do\'',
                              style: Fonts_mode.largeBoldTextStyle(isDarkTheme)
                                  .copyWith(
                                      decoration: TextDecoration.underline)),
                          onTap: () {
                            Provider.of<TasksState>(context, listen: false)
                                .moveSubtaskOnlyAndNotify(
                                    task, newStatus, context, true);

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const HomeScreen()));
                            // Navigator.pop(context);
                          }),
                      flex: 2),
                ),
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
                                Provider.of<TasksState>(context, listen: false)
                                    .moveTaskAndNotify(
                                        task, newStatus, context, true);

                                await showTutorialTopFlushbar(
                                    'Moved to $newStatus', context);

                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: activeButtonColor),
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
