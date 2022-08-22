import 'package:flutter/material.dart';
import 'package:kaidzen_app/views/createSubTask.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';

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
    return Consumer<TasksState>(
        builder: (context, state, child) =>
            buildViewTask(context, state.getById(widget.task.id!)));
  }

  Scaffold buildViewTask(BuildContext context, Task task) {
    return Scaffold(
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
                      child:
                          Text(task.category.name, textAlign: TextAlign.left))),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "This accomlishment with have ${task.difficulty.name} impact on my ${task.category.id >= 0 ? DevelopmentCategory.values.firstWhere((element) => element.id == widget.task.category.id).name : 'life sphere'} ",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Color.fromARGB(204, 147, 138, 138)),
                      ))),
              const SizedBox(height: 20),
              Column(
                children: buildExpandableContent(context, task),
              ),
              const SizedBox(height: 10),
            ]),
            flex: 7),
        Container(
          height: 70,
          width: double.maxFinite,
          padding: const EdgeInsets.fromLTRB(30, 5, 30, 230),
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 207, 219, 194),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {},
              ),
              Visibility(
                visible: task.status != Status.TODO && task.subtasks.isEmpty,
                child: MoveTaskIconButton(
                    task: task, direction: Direction.BACKWARD),
              ),
              Visibility(
                visible: task.status != Status.DONE && task.subtasks.isEmpty,
                child: MoveTaskIconButton(
                    task: task, direction: Direction.FORWARD),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ],
          ),
        )
      ]),
    );
  }
}

List<Widget> buildExpandableContent(BuildContext context, Task task) {
  List<Widget> columnContent = [];

  for (Task subtask in task.subtasks) {
    columnContent.add(Container(
        padding: const EdgeInsets.fromLTRB(25, 10, 5, 5),
        child: ListViewTaskItem(task: subtask)));
  }

  if (task.status == Status.TODO && task.parent == null) {
    columnContent.add(Container(
      padding: const EdgeInsets.fromLTRB(25, 10, 5, 5),
      child: ListTile(
        //contentPadding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
        title: const Text('Add subtask',
            style: TextStyle(decoration: TextDecoration.underline)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateSubTask(parent: task)));
        },
      ),
    ));
  }

  return columnContent;
}
