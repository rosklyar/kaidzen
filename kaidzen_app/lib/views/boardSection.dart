import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kaidzen_app/models/task.dart';

import 'package:kaidzen_app/utils/margin.dart';
import 'package:kaidzen_app/utils/theme.dart';

class BoardSection extends StatefulWidget {
  const BoardSection(GlobalKey<BoardSectionState> doBoardKey, {Key? key})
      : super(key: key);

  @override
  BoardSectionState createState() => BoardSectionState();
}

class BoardSectionState extends State<BoardSection> {
  List<Task> tasks = [
    Task(name: 'Do this'),
    Task(name: 'Do that'),
    Task(name: 'Clean room'),
    Task(name: 'Do not forget about 1st task'),
    Task(name: 'Visit dentist'),
    Task(name: 'Read Berlin diary 1'),
    Task(name: 'Read Berlin diary 2'),
    Task(name: 'Read Berlin diary 3'),
  ];

  @override
  void initState() {
    setState(() {
      tasks;
    });
    super.initState();
  }

  void addItem(Task newTask) {
    tasks.add(newTask);
    initState();
  }

  @override
  Widget build(BuildContext context) {
    return Board(
      list: tasks,
    );
  }
}

class Board extends StatefulWidget {
  const Board({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List<Task> list;

  @override
  _BoardState createState() => _BoardState(this.list);
}

class _BoardState extends State<Board> {
  _BoardState(this.list);
  List<Task> list;

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final Task item = list.removeAt(oldIndex);
        list.insert(newIndex, item);
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
              decoration: const BoxDecoration(
                color: Color(0xfff0f2f5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(0),
                ),
              ),
              child: ReorderableListView(
                onReorder: _onReorder,
                scrollController: ScrollController(),
                // buildDraggableFeedback: (a, b, c) => Container(),
                children: List.generate(
                  widget.list.length,
                  (index) {
                    return ListViewCard(
                      widget.list[index],
                      index,
                      Key('$index'),
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
}

class ListViewCard extends StatefulWidget {
  final int index;
  final Key key;
  final Task task;

  ListViewCard(this.task, this.index, this.key);

  @override
  _ListViewCard createState() => _ListViewCard();
}

class _ListViewCard extends State<ListViewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 18, 15, 0),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(9),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.2),
                blurRadius: 10,
              )
            ]),
        child: Container(
          height: 20,
          width: 200,
          child: ListView(
            padding: EdgeInsets.all(0),
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                margin: EdgeInsets.only(right: 6),
                child: Center(
                  child: Text(widget.task.name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Colors.grey[400],
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}

extension Num on num {
  double nextMax(num max) {
    return this + (max - this) * Random().nextDouble();
  }
}
