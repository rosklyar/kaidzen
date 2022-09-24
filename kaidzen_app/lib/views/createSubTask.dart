import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';

import '../models/task.dart';
import 'package:provider/provider.dart';

import '../service/TasksState.dart';

class CreateSubTask extends StatefulWidget {
  final Task parent;

  const CreateSubTask({Key? key, required this.parent}) : super(key: key);

  @override
  State<CreateSubTask> createState() {
    return _CreateSubTaskState();
  }
}

class _CreateSubTaskState extends State<CreateSubTask> {
  late TextEditingController newTaskController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create a subtask'),
      ),
      body: Column(children: [
        Expanded(
            child: Column(children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Goal title',
                        labelText: 'Goal title'),
                    controller: newTaskController,
                  )),
            ]),
            flex: 7),
        Expanded(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submit,
                      child:
                          const Text('Create', style: TextStyle(fontSize: 20)),
                    ))),
            flex: 1)
      ]),
    );
  }

  void submit() {
    Provider.of<TasksState>(context, listen: false).addTask(Task(
        newTaskController.text, widget.parent.category, Difficulty.EASY,
        parent: widget.parent.id));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    newTaskController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    newTaskController = TextEditingController();
  }
}
