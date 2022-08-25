import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/achievements/AchievementsState.dart';
import 'package:kaidzen_app/achievements/event.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/utils/margin.dart';
import 'package:kaidzen_app/views/listViewComplexTaskItem.dart';
import 'package:provider/provider.dart';
import '../assets/constants.dart';
import '../service/ProgressState.dart';
import 'ListViewTaskItem.dart';

class Board extends StatefulWidget {
  const Board({
    Key? key,
    required this.name,
    required this.list,
  }) : super(key: key);

  final List<Task> list;
  final String name;

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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              height: context.screenHeight(1),
              width: context.screenWidth(1),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ReorderableListView(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                onReorder: _onReorder,
                scrollController: ScrollController(),
                children: List.generate(
                  widget.list.length,
                  (index) {
                    return Dismissible(
                      key: Key(widget.list[index].id.toString()),
                      onDismissed: (direction) async {
                        await Provider.of<TasksState>(context, listen: false)
                            .deleteTask(widget.list[index]);
                      },
                      child: Column(key: Key('$index'),
                          children: [
                            Card(
                                child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/test.png"),
                                ),
                              ),
                              child: listItem(widget.list[index]),
                            ))
                          ]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
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
