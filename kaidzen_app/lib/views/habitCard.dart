import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/views/listViewHabitItem.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../assets/light_dark_theme.dart';
import '../models/habit.dart';
import '../models/task.dart';
import 'ListViewTaskItem.dart';
import 'listViewComplexTaskItem.dart';

Widget habitCard(Habit habit, BuildContext context) {
  double progressValue = calculateCurrentHabitProgress(habit);

  final themeProvider = Provider.of<DarkThemeProvider>(context);
  bool isDarkTheme = themeProvider.darkTheme;

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
    shadowColor: dark_light_modes.cardShadowColor(isDarkTheme),
    elevation: cardElavation,
    color: dark_light_modes.statusIconReversed(isDarkTheme),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: getBackgroundImage(habit, context),
        ),
      ),
      child: Column(
        children: [ListViewHabitItem(habit: habit), progressBar],
      ),
    ),
  );
}

AssetImage getBackgroundImage(Habit habit, context) {
  final themeProvider = Provider.of<DarkThemeProvider>(context);
  bool isDarkTheme = themeProvider.darkTheme;

  if (habit.type == HabitType.FIXED.id ||
      habit.task.category == DevelopmentCategory.NO_CATEGORY) {
    return isDarkTheme
        ? AssetImage("assets/no_category_dark_default.png")
        : AssetImage("assets/no_category.png");
  }
  var stagesCountInHabit = habit.getType().stageCount.length;

  return stagesCountInHabit == habit.stage &&
          habit.stageCount == habit.getType().stageCount[habit.stage]
      ? isDarkTheme
          ? AssetImage(
              "assets/cards/dark/habit_stage_done_cat_${habit.task.category.id}_dark.png")
          : AssetImage(
              "assets/cards/habit_stage_done_cat_${habit.task.category.id}.png")
      : isDarkTheme
          ? AssetImage(
              "assets/cards/dark/habit_stage_${habit.stage}_cat_${habit.task.category.id}_dark.png")
          : AssetImage(
              "assets/cards/habit_stage_${habit.stage}_cat_${habit.task.category.id}.png");
}

double calculateCurrentHabitProgress(Habit habit) {
  var type = habit.getType();
  return type == HabitType.FIXED
      ? habit.stageCount / habit.totalCount
      : habit.stageCount / type.stageCount[habit.stage]!;
}
