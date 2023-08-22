import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/announcements/AnnouncementsState.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/BoardMessageState.dart';
import 'package:kaidzen_app/service/HabitState.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';
import 'package:kaidzen_app/views/listViewComplexTaskItem.dart';
import 'package:provider/provider.dart';
import '../assets/constants.dart';
import '../models/habit.dart';
import '../service/AnalyticsService.dart';
import 'ListViewTaskItem.dart';

class Board extends StatefulWidget {
  Board(
      {Key? key,
      required this.board,
      required this.tasks,
      required this.habits,
      required this.sc,
      required this.scrollEnabled})
      : super(key: key);

  final List<Task> tasks;
  final List<Habit> habits;
  final ToggleBoard board;
  final ScrollController sc;
  final bool scrollEnabled;

  @override
  // ignore: no_logic_in_create_state
  BoardState createState() {
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
        final Task item = widget.tasks.removeAt(oldIndex);
        widget.tasks.insert(newIndex, item);

        List<Task> tasksToUpdate = List.empty(growable: true);
        int from = newIndex > oldIndex ? oldIndex : newIndex;
        int to = newIndex > oldIndex ? newIndex : oldIndex;
        for (int i = from; i <= to; i++) {
          Task t = widget.tasks[i];
          t.priority = i;
          tasksToUpdate.add(t);
        }

        Provider.of<TasksState>(context, listen: false)
            .updateTasks(tasksToUpdate);

        FirebaseAnalytics.instance
            .logEvent(name: AnalyticsEventType.goals_reordered.name);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer5<BoardMessageState, TutorialState, AnnouncementsState,
            TasksState, HabitState>(
        builder: (context, boardMessageState, tutorialState, announcementState,
            tasksState, habitState, child) {
      String boardMessage = boardMessageState.getBoardMessage(widget.board);

      return GestureDetector(
        child: Stack(
          children: [
            Column(
              children: [
                const Expanded(child: SizedBox(), flex: 1),
                Expanded(
                  child: Align(
                    child: Text(
                      boardMessage,
                      style:
                          Fonts.largeTextStyle.copyWith(color: greyTextColor),
                      textAlign: TextAlign.center,
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                  flex: 2,
                ),
                widget.board == ToggleBoard.TODO &&
                        !tutorialState.tutorialCompleted() &&
                        boardMessage != ""
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset("assets/arrow-to-create.svg"),
                        ),
                        flex: 2,
                      )
                    : const Expanded(child: SizedBox(), flex: 2),
                const Expanded(child: SizedBox(), flex: 3),
              ],
            ),
            announcementState.getTopAnnouncement() != null
                ? Column(
                    children: [
                      Expanded(
                        child: Padding(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Expanded(child: SizedBox(), flex: 1),
                                    Expanded(
                                      child: Image.asset(
                                          "assets/announcement/announcement-dragon.png"),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: announcementState
                                    .getTopAnnouncement()!
                                    .widget,
                                flex: 4,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        ),
                        flex: 1,
                      ),
                      Expanded(child: habitsAndTasksListViews(), flex: 2)
                    ],
                  )
                : habitsAndTasksListViews()
          ],
        ),
      );
    });
  }

  Widget habitsAndTasksListViews() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The collapsible section on top
        ExpansionTile(
          title: Text("Repated goals"),
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.habits
                  .map((item) => ListTile(
                        title: Text(item.task.name),
                      ))
                  .toList(),
            )
          ],
        ),

        // Your reorderable list view
        Expanded(child: reorderableListView()),
      ],
    );
  }

  ReorderableListView reorderableListView() {
    return ReorderableListView(
      physics: widget.scrollEnabled
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      onReorder: _onReorder,
      scrollController: widget.sc,
      children: List.generate(
        widget.tasks.length,
        (index) {
          return Column(
              key: Key('$index'), children: [taskCard(widget.tasks[index])]);
        },
      ),
    );
  }

  Widget taskCard(Task task) {
    if (task.status == Status.TODO) {
      return Card(
          shadowColor: cardShadowColor,
          elevation: cardElavation,
          child: listItem(task));
    }
    var background = task.status == Status.DOING
        ? AssetImage(
            "assets/doing" + ((task.id! + 1) % 2 + 1).toString() + ".png")
        : AssetImage(task.category.backgroundLink +
            ((task.id! + 1) % 2 + 1).toString() +
            ".png");

    return Card(
        shadowColor: cardShadowColor,
        elevation: cardElavation,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: background,
            ),
          ),
          child: listItem(task),
        ));
  }

  Widget listItem(Task task) => task.hasSubtasks()
      ? ListViewComplexTaskItem(task: task)
      : ListViewTaskItem(task: task);
}

extension Num on num {
  double nextMax(num max) {
    return this + (max - this) * Random().nextDouble();
  }
}
