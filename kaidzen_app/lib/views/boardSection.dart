import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/announcements/AnnouncementsState.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/BoardMessageState.dart';
import 'package:kaidzen_app/service/HabitState.dart';
import 'package:kaidzen_app/service/LocalPropertiesService.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';
import 'package:kaidzen_app/views/taskCard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../assets/constants.dart';
import '../models/habit.dart';
import '../service/AnalyticsService.dart';
import 'habitCard.dart';

class Board extends StatefulWidget {
  const Board(
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
            annoncementIsPresentAndRelevant(announcementState)
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
                      Expanded(child: reorderableListView(), flex: 2)
                    ],
                  )
                : reorderableListView()
          ],
        ),
      );
    });
  }

  bool annoncementIsPresentAndRelevant(AnnouncementsState announcementState) {
    final topAnnouncement = announcementState.getTopAnnouncement();
    final todoTasksCount = Provider.of<TasksState>(context, listen: false).getByStatus(Status.TODO).length;
    return topAnnouncement != null && (topAnnouncement.id != 1 || todoTasksCount > 1);
  }

  ReorderableListView reorderableListView() {
    var habits = Visibility(
      key: Key('habits'),
      visible: widget.habits.isNotEmpty,
      child: Column(
        children: [
          Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: Colors.black,
              onExpansionChanged: (value) {
                Provider.of<LocalPropertiesService>(context, listen: false)
                    .setBool(PropertyKey.HABITS_EXPANDED, value);
              },
              initiallyExpanded:
                  Provider.of<LocalPropertiesService>(context, listen: false)
                          .getBool(PropertyKey.HABITS_EXPANDED) ??
                      true,
              title: Row(
                children: [
                  SvgPicture.asset(
                    'assets/recurring.svg',
                    color: Colors.black,
                    width: 20.0,
                    height: 20.0,
                  ), // Replace with your desired icon
                  SizedBox(
                      width: 8.0), // Adds some spacing between the icon and text
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Recurring goals',
                              style: Fonts.largeTextStyle,
                              children: <InlineSpan>[
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.aboveBaseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: Text('  ${widget.habits.length}',
                                      style: Fonts.largeBoldTextStyle),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(3, 20, 3, 20),
            child: Divider(
              color: Color.fromARGB(255, 190, 189, 189), // or any color you want
              height: 3.0, // control the height of the divider
              thickness: 1.0, // control the thickness of the line
            ),
          ),
        ],
      ),
    );
    List<Widget> all = [habits];

    List<Widget> tasks = List.generate(
      widget.tasks.length,
      (index) {
        return Column(
            key: Key('$index'), children: [taskCard(widget.tasks[index])]);
      },
    );
    all.addAll(tasks);

    return ReorderableListView(
      physics: widget.scrollEnabled
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      onReorder: _onReorder,
      scrollController: widget.sc,
      children: all,
    );
  }
}

extension Num on num {
  double nextMax(num max) {
    return this + (max - this) * Random().nextDouble();
  }
}
