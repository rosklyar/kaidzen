import 'package:flutter/material.dart';
import 'package:kaidzen_app/views/listViewHabitItem.dart';

import '../assets/constants.dart';
import '../models/habit.dart';
import '../models/task.dart';
import 'ListViewTaskItem.dart';
import 'listViewComplexTaskItem.dart';

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