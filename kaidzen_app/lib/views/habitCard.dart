import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/views/listViewHabitItem.dart';

import '../assets/constants.dart';
import '../models/habit.dart';
import '../models/task.dart';
import 'ListViewTaskItem.dart';
import 'listViewComplexTaskItem.dart';

Widget habitCard(Habit habit) {
  double progressValue = calculateCurrentHabitProgress(habit);

  Widget progressBar = ClipRRect(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(20), // Adjust the radius as needed
      bottomRight: Radius.circular(20),
    ),
    child: LinearProgressIndicator(
      backgroundColor: habit.task.category.color.withOpacity(0.2),
      value: progressValue,
      valueColor: AlwaysStoppedAnimation<Color>(
          habit.task.category.color), // Or any color you prefer
    ),
  );

  return Card(
    shadowColor: cardShadowColor,
    elevation: cardElavation,
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: getBackgroundImage(habit),
        ),
      ),
      child: Column(
        children: [ListViewHabitItem(habit: habit), progressBar],
      ),
    ),
  );
}

AssetImage getBackgroundImage(Habit habit) {
  if (habit.type == HabitType.FIXED.id || habit.task.category == DevelopmentCategory.NO_CATEGORY) {
    return AssetImage("assets/no_category.png");
  }
  var stagesCountInHabit = habit.getType().stageCount.length;

  return stagesCountInHabit == habit.stage &&
          habit.stageCount ==
              habit.getType().stageCount[habit.stage]
      ? AssetImage("assets/cards/habit_stage_done_cat_${habit.task.category.id}.png")
      : AssetImage("assets/cards/habit_stage_${habit.stage}_cat_${habit.task.category.id}.png");
}

double calculateCurrentHabitProgress(Habit habit) {
  var type = habit.getType();
  return type == HabitType.FIXED
      ? habit.stageCount / habit.totalCount
      : habit.stageCount / type.stageCount[habit.stage]!;
}
