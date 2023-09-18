import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kaidzen_app/service/HabitState.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/views/editGoal.dart';
import 'package:kaidzen_app/views/editHabit.dart';
import 'package:kaidzen_app/views/listViewHabitItem.dart';
import '../models/habit.dart';
import 'package:provider/provider.dart';
import 'MoveTaskIconButton.dart';

class ViewHabit extends StatefulWidget {
  final Habit habit;

  const ViewHabit(this.habit, {Key? key}) : super(key: key);

  @override
  State<ViewHabit> createState() {
    return _ViewHabitState();
  }
}

class _ViewHabitState extends State<ViewHabit> {
  bool deleteOverlayVisible = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitState>(builder: (context, state, child) {
      var habit = state.getById(widget.habit.id!);
      if (habit == null) {
        return const SizedBox.shrink();
      }
      return buildViewHabit(context, habit);
    });
  }

  Scaffold buildViewHabit(BuildContext context, Habit habit) {
    return Scaffold(
      backgroundColor: Color(habit.task.category.backgroundColor),
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
                              habit.task.name,
                              textAlign: TextAlign.left,
                              style: Fonts.screenTytleTextStyle,
                            ))),
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
                                      color: habit.task.category.color,
                                      size: 10.0 + habit.task.difficulty.id * 3),
                                ),
                                Text(
                                    "${habit.task.difficulty.noun} impact on my ${habit.task.category.id >= 0 ? DevelopmentCategory.values.firstWhere((element) => element.id == widget.habit.task.category.id).name : 'life sphere'} ",
                                    textAlign: TextAlign.left,
                                    style: Fonts.graySubtitleMedium)
                              ],
                            ))),
                  ]),
                ],
              ),
              const SizedBox(height: 20)
            ]),
            flex: 7),
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text("now in " + habit.task.status,
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
                  await deletePopup(context, habit);
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: habit.task.status != Status.TODO
                      ? MoveHabitIconButton(
                          habit: habit, direction: Direction.BACKWARD)
                      : Image.asset("assets/left_inactive.png")),
              Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: habit.task.status != Status.DONE
                      ? MoveHabitIconButton(
                          habit: habit, direction: Direction.FORWARD)
                      : Image.asset("assets/right_inactive.png")),
              IconButton(
                icon: SvgPicture.asset("assets/edit.svg"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditHabit(habit);
                  }));
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Future<void> deletePopup(BuildContext context, Habit habit) async {
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
                          await Provider.of<HabitState>(context, listen: false)
                              .deleteHabit(habit);
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
