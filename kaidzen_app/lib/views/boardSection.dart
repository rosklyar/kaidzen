import 'dart:math';
import 'dart:developer' as logging;
import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';
import 'package:kaidzen_app/service/TasksState.dart';
import 'package:kaidzen_app/views/listViewComplexTaskItem.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../assets/constants.dart';
import 'ListViewTaskItem.dart';

class Board extends StatefulWidget {
  const Board({
    Key? key,
    required this.name,
    required this.list,
    required this.sc,
    required this.scrollEnabled,
    required this.pnc,
  }) : super(key: key);

  final List<Task> list;
  final String name;
  final ScrollController sc;
  final PanelController pnc;
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragEnd: (details) {
          if (widget.pnc.isPanelClosed &&
              details.velocity.pixelsPerSecond.direction < 0) {
            widget.pnc.open();
          }
        },
        onVerticalDragDown: (details) {
          var shouldClose = widget.list.isEmpty ||
              widget.sc.position.atEdge && widget.sc.position.pixels == 0;
          if (shouldClose &&
              widget.pnc.isPanelOpen &&
              details.globalPosition.direction < 1) {
            widget.pnc.close();
          }
        },
        child: ReorderableListView(
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
                  key: Key('$index'), children: [taskCard(widget.list[index])]);
            },
          ),
        ));
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
            "assets/doing" + ((task.priority + 1) % 2 + 1).toString() + ".png")
        : AssetImage(task.category.backgroundLink +
            ((task.priority + 1) % 2 + 1).toString() +
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
