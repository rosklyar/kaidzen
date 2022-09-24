import 'package:flutter/material.dart';
import 'package:kaidzen_app/views/createSubTask.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';

import '../utils/dashSeparator.dart';
import 'MoveTaskIconButton.dart';
import 'ListViewTaskItem.dart';

class ViewTask extends StatefulWidget {
  final Task task;

  const ViewTask(this.task, {Key? key}) : super(key: key);

  @override
  State<ViewTask> createState() {
    return _ViewTaskState();
  }
}

class _ViewTaskState extends State<ViewTask> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksState>(builder: (context, state, child) {
      var task = state.getById(widget.task.id!);
      if (task == null) {
        return const SizedBox.shrink();
      }
      return buildViewTask(context, task);
    });
  }

  Scaffold buildViewTask(BuildContext context, Task task) {
    return Scaffold(
      backgroundColor: Color(task.category.backgroundColor),
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
            child: Column(children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        task.name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0),
                      ))),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 10,
                        children: [
                          Icon(Icons.circle_rounded,
                              color: task.category.color,
                              size: 10.0 + task.difficulty.id * 3),
                          Text(
                            "${task.difficulty.noun} impact on my ${task.category.id >= 0 ? DevelopmentCategory.values.firstWhere((element) => element.id == widget.task.category.id).name : 'life sphere'} ",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Color.fromARGB(204, 147, 138, 138)),
                          )
                        ],
                      ))),
              const SizedBox(height: 20),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: SingleChildScrollView(
                    child: Column(
                      children: buildExpandableContent(context, task),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 50,
                  child: Visibility(
                    visible: task.status == Status.TODO && task.parent == null,
                    child: ListTile(
                      horizontalTitleGap: 1,
                      leading: IconButton(
                        icon: Image.asset("assets/plus_in_circle.png"),
                        color: Theme.of(context).errorColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateSubTask(parent: task)));
                        },
                      ),
                      title: const Text('Add subtask',
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CreateSubTask(parent: task)));
                      },
                    ),
                  ),
                ),
              ),
            ]),
            flex: 7),
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text("now in " + task.status,
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center)),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Image.asset("assets/delete.png"),
                color: Theme.of(context).errorColor,
                onPressed: () async {
                  await Provider.of<TasksState>(context, listen: false)
                      .deleteTask(task);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: task.status != Status.TODO && task.subtasks.isEmpty
                      ? MoveTaskIconButton(
                          task: task, direction: Direction.BACKWARD)
                      : Image.asset("assets/left_inactive.png")),
              Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: task.status != Status.DONE && task.subtasks.isEmpty
                      ? MoveTaskIconButton(
                          task: task, direction: Direction.FORWARD)
                      : Image.asset("assets/right_inactive.png")),
              IconButton(
                icon: Image.asset("assets/edit.png"),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

List<Widget> buildExpandableContent(BuildContext context, Task task) {
  List<Widget> columnContent = [];

  var divider = Container(
    child: const DashSeparator(),
    padding: const EdgeInsets.only(left: 40),
  );
  for (Task subtask in task.subtasks) {
    columnContent.add(Container(
        padding: const EdgeInsets.fromLTRB(25, 0, 5, 0),
        child: ListTile(
          title: Text(
            subtask.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
          subtitle: Text('in ' + subtask.status),
          trailing: ListTileTrail(task: subtask),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewTask(subtask)));
          },
          selected: false,
        )));

    columnContent.add(divider);
  }

  return columnContent;
}
