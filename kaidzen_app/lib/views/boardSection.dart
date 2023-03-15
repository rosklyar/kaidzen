import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/BoardMessageState.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';
import 'package:kaidzen_app/views/listViewComplexTaskItem.dart';
import 'package:provider/provider.dart';
import '../assets/constants.dart';
import '../service/AnalyticsService.dart';
import 'ListViewTaskItem.dart';

class Board extends StatefulWidget {
  const Board({
    Key? key,
    required this.board,
    required this.list,
    required this.sc,
    required this.scrollEnabled,
  }) : super(key: key);

  final List<Task> list;
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
        final Task item = widget.list.removeAt(oldIndex);
        widget.list.insert(newIndex, item);

        List<Task> tasksToUpdate = List.empty(growable: true);
        int from = newIndex > oldIndex ? oldIndex : newIndex;
        int to = newIndex > oldIndex ? newIndex : oldIndex;
        for (int i = from; i <= to; i++) {
          Task t = widget.list[i];
          t.priority = i;
          tasksToUpdate.add(t);
        }

        Provider.of<TasksState>(context, listen: false)
            .updateTasks(tasksToUpdate);

        FirebaseAnalytics.instance.logEvent(name: AnalyticsEventType.goals_reordered.name);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BoardMessageState, TutorialState>(
        builder: (context, boardMessageState, tutorialState, child) =>
            GestureDetector(
                child: Stack(children: [
              Column(children: [
                const Expanded(child: SizedBox(), flex: 1),
                Expanded(
                    child: Align(
                        child: Text(
                            boardMessageState.getBoardMessage(widget.board),
                            style: Fonts.largeTextStyle
                                .copyWith(color: greyTextColor),
                            textAlign: TextAlign.center),
                        alignment: Alignment.bottomCenter),
                    flex: 2),
                !tutorialState.tutorialCompleted() &&
                        widget.board == ToggleBoard.TODO
                    ? Expanded(
                        child: SvgPicture.asset("assets/arrow-to-create.svg"),
                        flex: 2)
                    : const Expanded(child: SizedBox(), flex: 2),
                const Expanded(child: SizedBox(), flex: 3)
              ]),
              ReorderableListView(
                physics: widget.scrollEnabled
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                onReorder: _onReorder,
                scrollController: widget.sc,
                children: List.generate(
                  widget.list.length,
                  (index) {
                    return Column(
                        key: Key('$index'),
                        children: [taskCard(widget.list[index])]);
                  },
                ),
              )
            ])));
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
