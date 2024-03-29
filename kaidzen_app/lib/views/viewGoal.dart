import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/views/createSubgoal.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/views/editSubgoal.dart';
import 'package:kaidzen_app/views/editGoal.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';

import '../utils/dashSeparator.dart';
import 'MoveTaskIconButton.dart';
import 'ListViewTaskItem.dart';

class ViewGoal extends StatefulWidget {
  final Task task;

  const ViewGoal(this.task, {Key? key}) : super(key: key);

  @override
  State<ViewGoal> createState() {
    return _ViewGoalState();
  }
}

class _ViewGoalState extends State<ViewGoal> {
  bool deleteOverlayVisible = false;

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
    var parentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(task.category.backgroundColor),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset("assets/shevron-left-black.svg"),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white.withOpacity(0),
      ),
      body: Column(children: [
        Expanded(
            child: Column(children: [
              Stack(
                children: [
                  Visibility(
                      visible: deleteOverlayVisible,
                      child: Image.asset("assets/Deleted.png")),
                  Column(children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              task.name,
                              textAlign: TextAlign.left,
                              style: Fonts.screenTytleTextStyle,
                            ))),
                    Visibility(
                      visible: task.parent != null,
                      child: task.parent != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          parentWidth * 0.03, 0, 5, 8),
                                      child:
                                          Image.asset("assets/back_arrow.png")),
                                  SizedBox(
                                    width: parentWidth * 0.8,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          parentWidth * 0.01, 5, 5, 5),
                                      child: Text(
                                          style: Fonts.graySubtitleMedium,
                                          Provider.of<TasksState>(context,
                                                  listen: false)
                                              .getById(task.parent!)!
                                              .shortenedName(75)),
                                    ),
                                  )
                                ],
                              ))
                          : const SizedBox(),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 10,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Icon(Icons.circle_rounded,
                                      color: task.category.color,
                                      size: 10.0 + task.difficulty.id * 3),
                                ),
                                Text(
                                    "${task.difficulty.noun} impact on my ${task.category.id >= 0 ? DevelopmentCategory.values.firstWhere((element) => element.id == widget.task.category.id).name : 'life sphere'} ",
                                    textAlign: TextAlign.left,
                                    style: Fonts.graySubtitleMedium)
                              ],
                            ))),
                  ]),
                ],
              ),
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
                                  builder: (context) => CreateSubGoal(task,
                                      popTarget: "parentTask")));
                        },
                      ),
                      title: const Text('Add subgoal',
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateSubGoal(task,
                                    popTarget: "parentTask")));
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
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Image.asset("assets/delete.png"),
                color: Theme.of(context).errorColor,
                onPressed: () async {
                  setState(() {
                    deleteOverlayVisible = true;
                  });
                  await deletePopup(context, task);
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: task.status != Status.TODO
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
                icon: SvgPicture.asset("assets/edit.svg"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return task.parent == null
                        ? EditGoal(task)
                        : EditSubGoal(
                            parent:
                                Provider.of<TasksState>(context, listen: false)
                                    .getById(task.parent!)!,
                            task: task);
                  }));
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Future<void> deletePopup(BuildContext context, Task task) async {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text('Are you sure?',
                            style: Fonts.screenTytleTextStyle)),
                    flex: 5),
                const Expanded(child: SizedBox(), flex: 1),
                Expanded(
                    child: GestureDetector(
                        child: Text('Delete',
                            style: Fonts.largeTextStyle.copyWith(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFE50000))),
                        onTap: () async {
                          Navigator.pop(context);
                          await Provider.of<TasksState>(context, listen: false)
                              .deleteTask(task);
                          Navigator.pop(context);
                        }),
                    flex: 2),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: activeButtonColor),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: Fonts.largeTextStyle20
                                    .copyWith(color: Colors.white)),
                          )),
                    ),
                    flex: 4),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        deleteOverlayVisible = false;
      });
    });
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
            style: Fonts.largeTextStyle,
          ),
          subtitle: Text(
            'in ' + subtask.status,
            style: Fonts.graySubtitle,
          ),
          trailing: ListTileTrail(task: subtask),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewGoal(subtask)));
          },
          selected: false,
        )));

    columnContent.add(divider);
  }

  return columnContent;
}
