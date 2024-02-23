import 'package:flutter/material.dart';
import 'package:kaidzen_app/views/listViewHabitItem.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../models/habit.dart';
import '../models/task.dart';
import 'ListViewTaskItem.dart';
import 'listViewComplexTaskItem.dart';
import '../assets/light_dark_theme.dart';

Widget taskCard(Task task, BuildContext context) {
  final themeProvider = Provider.of<DarkThemeProvider>(context);
  bool isDarkTheme = themeProvider.darkTheme;

  if (task.status == Status.TODO) {
    return Card(
        shadowColor: dark_light_modes.cardShadowColor(isDarkTheme),
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
      shadowColor: dark_light_modes.cardShadowColor(isDarkTheme),
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
