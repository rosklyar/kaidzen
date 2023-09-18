import 'package:flutter/material.dart';
import 'package:kaidzen_app/views/listViewHabitItem.dart';

import '../assets/constants.dart';
import '../models/habit.dart';
import '../models/task.dart';
import 'ListViewTaskItem.dart';
import 'listViewComplexTaskItem.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;

  HabitCard({required this.habit});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> _colorAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _colorAnimation =
        ColorTween(begin: Colors.white, end: Colors.black).animate(_controller);
  }

  @override
  void didUpdateWidget(HabitCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Debugging print statements:
    print("didUpdateWidget called!");
    print("shouldAnimate value: ${widget.habit.shouldAnimate}");

    if (widget.habit.shouldAnimate) {
      print("Starting animation...");
      _controller.forward().then((_) {
        print("Animation finished. Reversing...");
        widget.habit.shouldAnimate = false;
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.1).animate(_controller),
          child: _buildHabitCard(widget.habit),
        );
      },
    );
  }

  Widget _buildHabitCard(Habit habit) {
    var type = HabitType.getById(habit.type);
    double progressValue = calculateCurrentHabitProgress(habit);

    Widget progressBar = LinearProgressIndicator(
      value: progressValue,
      backgroundColor: _colorAnimation.value, // this line has been changed
      valueColor: AlwaysStoppedAnimation<Color>(habit.task.category.color),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

double calculateCurrentHabitProgress(Habit habit) {
  var type = HabitType.getById(habit.type);
  return type == HabitType.FIXED
      ? habit.stageCount / habit.totalCount
      : habit.stageCount / type.stageCount[habit.stage]!;
}
