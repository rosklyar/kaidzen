import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/utils/margin.dart';
import 'package:kaidzen_app/views/listViewComplexTaskItem.dart';
import 'package:provider/provider.dart';
import '../assets/constants.dart';
import 'ListViewTaskItem.dart';

class Board extends StatefulWidget {
  const Board({
    Key? key,
    required this.name,
    required this.list,
    required this.sc,
  }) : super(key: key);

  final List<Task> list;
  final String name;
  final ScrollController sc;

  @override
  // ignore: no_logic_in_create_state
  BoardState createState() {
    return BoardState();
  }
}

class BoardState extends State<Board> {
  final _random = Random();

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
    return ReorderableListView(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      onReorder: _onReorder,
      scrollController: widget.sc,
      children: List.generate(
        widget.list.length,
        (index) {
          return Dismissible(
            key: Key(widget.list[index].id.toString()),
            onDismissed: (direction) async {
              await Provider.of<TasksState>(context, listen: false)
                  .deleteTask(widget.list[index]);
            },
            child: Column(
                key: Key('$index'),
                children: [taskCard(widget.list[index])]),
          );
        },
      ),
    );
  }

  Card taskCard(Task task) {
    if (task.status == Status.TODO) {
      return Card(elevation: 8, child: listItem(task));
    }
    var background = task.status == Status.DOING
        ? AssetImage(
            "assets/doing" + ((_random.nextInt(2) + 1)).toString() + ".png")
        : AssetImage(task.category.backgroundLink +
            ((_random.nextInt(2) + 1)).toString() +
            ".png");

    return Card(
        elevation: 8,
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
