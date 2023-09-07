import 'package:flutter/material.dart';
import 'package:kaidzen_app/views/listViewHabitItem.dart';

import '../assets/constants.dart';
import '../models/habit.dart';
import '../models/task.dart';
import 'ListViewTaskItem.dart';
import 'listViewComplexTaskItem.dart';

Widget habitCard(Habit habit) {
  var type = HabitType.getById(habit.type);
  double progressValue = calculateCurrentHabitProgress(habit);

  Widget progressBar = LinearProgressIndicator(
    value: progressValue,
    backgroundColor: Colors.grey[200],
    valueColor: AlwaysStoppedAnimation<Color>(
        habit.task.category.color), // Or any color you prefer
  );

  if (habit.task.status == Status.TODO) {
    return Card(
      shadowColor: cardShadowColor,
      elevation: cardElavation,
      child: Column(
        children: [ListViewHabitItem(habit: habit), progressBar],
      ),
    );
  }

  var background = habit.task.status == Status.DOING
      ? AssetImage(
          "assets/doing" + ((habit.task.id! + 1) % 2 + 1).toString() + ".png")
      : AssetImage(habit.task.category.backgroundLink +
          ((habit.task.id! + 1) % 2 + 1).toString() +
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
      child: Column(
        children: [ListViewHabitItem(habit: habit), progressBar],
      ),
    ),
  );
}

double calculateCurrentHabitProgress(Habit habit) {
  var type = HabitType.getById(habit.type);
  return type == HabitType.FIXED
      ? habit.stageCount / habit.totalCount
      : habit.stageCount / type.stageCount[habit.stage]!;
}


