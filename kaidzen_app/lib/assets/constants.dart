import 'package:flutter/material.dart';

class Status {
  static const String TODO = "To Do";
  static const String DOING = "In Progress";
  static const String DONE = "Done";
}

enum DevelopmentCategory {
  MIND(0, "Mind", Color.fromRGBO(69, 131, 151, 1.0)),
  HEALTH(1, "Health", Color.fromRGBO(166, 187, 31, 1.0)),
  ENERGY(2, "Energy", Color.fromRGBO(242, 202, 0, 1.0)),
  RELATIONS(3, "Relations", Color.fromRGBO(234, 125, 98, 1.0)),
  WEALTH(4, "Wealth", Color.fromRGBO(138, 94, 176, 1.0));

  const DevelopmentCategory(this.id, this.name, this.color);
  final int id;
  final String name;
  final Color color;
}

enum Difficulty {
  EASY(0, "A little"),
  MEDIUM(1, "Average"),
  HARD(2, "Hugely");

  const Difficulty(this.id, this.name);
  final int id;
  final String name;
}

const selectedToggleColor = Color.fromARGB(255, 81, 79, 79);
const unselectedToggleColor = Colors.grey;

const TextStyle smallTextStyle = TextStyle(
  fontSize: 8,
  color: Colors.black,
);

const TextStyle mediumTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.black,
);

const TextStyle largeTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

const TextStyle mediumWhiteTextStyle =
    TextStyle(fontSize: 12, color: Colors.white);
