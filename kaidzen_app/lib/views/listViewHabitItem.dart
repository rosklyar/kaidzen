import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/service/HabitState.dart';
import 'package:kaidzen_app/views/viewGoal.dart';
import 'package:kaidzen_app/views/viewHabit.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

import '../assets/constants.dart';
import '../models/habit.dart';
import '../utils/snackbar.dart';
import 'doneIconButton.dart';

class ListViewHabitItem extends ListTile {
  const ListViewHabitItem({
    Key? key,
    required this.habit,
  }) : super(key: key);

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    var listText = HabitStage.getById(habit.stage).title;

    var habitType = habit.getType();
    listText += habitType == HabitType.FIXED
        ? ' • ${habit.stageCount} out of ${habit.totalCount}'
        : ' • ${habit.stageCount} out of ${habitType.stageCount[habit.stage]}';

    return ListTile(
      //contentPadding: EdgeInsets.symmetric(horizontal: 16),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/recurring.svg',
            color: habit.task.category.color,
            width: 12.0 + habit.task.difficulty.id * 4,
            height: 12.0 + habit.task.difficulty.id * 4,
          ),
        ],
      ),
      title: Text(
        habit.task.shortenedName(75),
        style: Fonts.largeBoldTextStyle,
      ),
      horizontalTitleGap: -10,
      subtitle: Text(
        listText,
        style: Fonts.graySubtitle,
      ),
      trailing: ListTileTrail(habit: habit),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ViewHabit(habit)));
      },
      selected: false,
    );
  }
}

class ListTileTrail extends StatelessWidget {
  const ListTileTrail({
    Key? key,
    required this.habit,
  }) : super(key: key);

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    if (habit.task.status == Status.DONE) {
      return const SizedBox();
    } else if (habit.task.status == Status.TODO) {
      return MoveHabitIconButton(habit: habit, direction: Direction.FORWARD);
    } else {
      return TrackHabitIconButton(habit: habit);
    }
  }
}

class TrackHabitIconButton extends StatefulWidget {
  const TrackHabitIconButton({Key? key, required this.habit}) : super(key: key);

  final Habit habit;

  @override
  _TrackHabitIconButtonState createState() => _TrackHabitIconButtonState();
}

class _TrackHabitIconButtonState extends State<TrackHabitIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool animationInterrupted = false;
  bool showCheckmark = false;
  // Indicates if the checkmark should be displayed
  bool _isButtonLocked = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.3).animate(_animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();

              if (showCheckmark) {
                // Once animation is complete and the habit is done, reset the checkmark state.
                setState(() {});
              }
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isButtonLocked) {
          if (_animationController.isAnimating) {
            animationInterrupted = true;
            _animationController.stop();
            Provider.of<HabitState>(context, listen: false)
                .trackHabit(widget.habit);
          }
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              showCheckmark
                  ? Icon(
                      Icons.check_circle) // Checkmark icon when habit is done
                  : Icon(Icons.add_circle_outline), // Default icon
            ],
          ),
          onPressed: () async {
            if (!_isButtonLocked) {
              _isButtonLocked = true;
              _animationController.forward();

              // Check if it's the last push before moving to "DONE"
              var type = widget.habit.getType();
              var stageTotal = type == HabitType.FIXED
                  ? widget.habit.totalCount
                  : type.stageCount[widget.habit.stage];

              if (widget.habit.stageCount + 1 == stageTotal) {
                // Note the +1, since we're about to increment it.
                if (mounted) {
                  // Ensure widget is still in the tree.
                  setState(() {
                    showCheckmark = true;
                  });
                }
                // await Future.delayed(Duration(milliseconds: 10)); // Updated delay
              }

              // Proceed with the existing logic.
              Future.delayed(Duration(milliseconds: 100), () async {
                if (!animationInterrupted) {
                  await Provider.of<HabitState>(context, listen: false)
                      .trackHabit(widget.habit);
                }
              });
              _animationController.addStatusListener((status) {
                if (status == AnimationStatus.completed ||
                    status == AnimationStatus.dismissed) {
                  _isButtonLocked = false;
                }
              });
            }
          },
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(TrackHabitIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.habit != oldWidget.habit) {
      showCheckmark = false;
      // Reset when the widget is updated with a new habit
    }
  }

  @override
  void dispose() {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    _animationController.dispose();
    super.dispose();
  }
}

Future<void> trackHabit(BuildContext context, Habit habit) async {
  var type = habit.getType();
  var stageTotal =
      type == HabitType.FIXED ? habit.totalCount : type.stageCount[habit.stage];
  habit.stageCount += 1;
  if (habit.stageCount == stageTotal) {
    if (habit.stage == type.stageCount.length) {
      await Provider.of<HabitState>(context, listen: false)
          .moveHabitAndNotify(habit, Status.DONE);
    } else {
      habit.stage += 1;
      habit.stageCount = 0;
      await Provider.of<HabitState>(context, listen: false).updateHabit(habit);
    }
  } else {
    await Provider.of<HabitState>(context, listen: false).updateHabit(habit);
  }
}

class MoveHabitIconButton extends StatelessWidget {
  const MoveHabitIconButton({
    Key? key,
    required this.habit,
    required this.direction,
  }) : super(key: key);

  final Direction direction;
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: direction == Direction.FORWARD
            ? Image.asset("assets/right_active.png")
            : Image.asset("assets/left_active.png"),
        color: Theme.of(context).errorColor,
        onPressed: () async {
          await moveHabit(context, habit);
        });
  }

  Future<void> moveHabit(BuildContext context, Habit habit) async {
    var newStatus = direction == Direction.FORWARD
        ? habit.task.status == Status.DOING
            ? Status.DONE
            : Status.DOING
        : habit.task.status == Status.DOING
            ? Status.TODO
            : Status.DOING;

    await Provider.of<HabitState>(context, listen: false)
        .moveHabitAndNotify(habit, newStatus);
    showTutorialTopFlushbar('Moved to $newStatus', context);
  }

  String getNewStatus() {
    if (direction == Direction.FORWARD && habit.task.hasSubtasks()) {
      return Status.TODO;
    } else {
      return direction == Direction.FORWARD
          ? habit.task.status == Status.DOING
              ? Status.DONE
              : Status.DOING
          : habit.task.status == Status.DOING
              ? Status.TODO
              : Status.DOING;
    }
  }
}
