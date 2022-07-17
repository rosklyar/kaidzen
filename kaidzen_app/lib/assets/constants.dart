import 'package:flutter/material.dart';

class Boards {
  static const String DO = "To Do";
  static const String DOING = "In Progress";
  static const String DONE = "Done";
}

class Status {
  static const String TODO = "todo";
  static const String DOING = "inProgress";
  static const String DONE = "done";
}

enum Category {
  CAREER_AND_FINANCES("Career and finances", Colors.yellow),
  HEALTH("Health", Colors.green),
  PERSONAL_DEVELOPMENT("Personal development", Colors.blue),
  RELATIONSHIPS("Relatioships", Colors.red),
  LEISURE("Leisure", Colors.purple);

  const Category(this.name, this.color);
  final String name;
  final Color color;
}
