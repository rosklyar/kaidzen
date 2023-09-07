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
import 'package:kaidzen_app/views/taskCard.dart';
import 'package:provider/provider.dart';
import '../assets/constants.dart';
import '../models/habit.dart';
import '../service/AnalyticsService.dart';
import 'ListViewTaskItem.dart';
import 'habitCard.dart';

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
        if (oldIndex == 0) {
          return;
        }
        if (newIndex == 0) {
          newIndex++;
        }
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        debugPrint("old: $oldIndex new: $newIndex");
        final Task item = widget.tasks.removeAt(oldIndex - 1);
        widget.tasks.insert(newIndex - 1, item);

        List<Task> tasksToUpdate = List.empty(growable: true);
        int from = newIndex > oldIndex ? oldIndex - 1 : newIndex - 1;
        int to = newIndex > oldIndex ? newIndex - 1 : oldIndex - 1;
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

  void _onHabitReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final Habit item = widget.habits.removeAt(oldIndex);
        widget.habits.insert(newIndex, item);

        List<Habit> habitsToUpdate = List.empty(growable: true);
        int from = newIndex > oldIndex ? oldIndex : newIndex;
        int to = newIndex > oldIndex ? newIndex : oldIndex;
        for (int i = from; i <= to; i++) {
          Habit h = widget.habits[i];
          h.task.priority = i;
          habitsToUpdate.add(h);
        }

        Provider.of<HabitState>(context, listen: false)
            .updateHabits(habitsToUpdate);

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
                      )
                    ],
                  )
                : reorderableListView()
          ],
        ),
      );
    });
  }


  ReorderableListView reorderableListView() {
    var habits = Visibility(
      key: Key('habits'),
      visible: widget.habits.isNotEmpty,
      child: Column(
        children: [
          ExpansionTile(
            title: Text("Recurring goals (${widget.habits.length})"),
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.habits.length,
                  (index) {
                    return Column(
                        key: Key('$index'),
                        children: [habitCard(widget.habits[index])]);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );

    List<Widget> tasks = List.generate(
      widget.tasks.length,
      (index) {
        return Column(
            key: Key('$index'), children: [taskCard(widget.tasks[index])]);
      },
    );

    return ReorderableListView(
      physics: widget.scrollEnabled
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      onReorder: _onReorder,
      scrollController: widget.sc,
      children: [habits, tasks],
    );
  }
}

extension Num on num {
  double nextMax(num max) {
    return this + (max - this) * Random().nextDouble();
  }
}
