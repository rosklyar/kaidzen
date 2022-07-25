import 'package:flutter/material.dart';

class Status {
  static const String TODO = "To Do";
  static const String DOING = "In Progress";
  static const String DONE = "Done";
}

enum DevelopmentCategory {
  CAREER_AND_FINANCES(0, "Career and finances", Colors.yellow),
  HEALTH(1, "Health", Colors.green),
  PERSONAL_DEVELOPMENT(2, "Personal development", Colors.blue),
  RELATIONSHIPS(3, "Relatioships", Colors.red),
  LEISURE(4, "Leisure", Colors.purple);

  const DevelopmentCategory(this.id, this.name, this.color);
  final int id;
  final String name;
  final Color color;
}

enum Difficulty {
  EASY(0, "A little"),
  MEDIUM(1, "Average"),
  HARD(2, "Majorly");

  const Difficulty(this.id, this.name);
  final int id;
  final String name;
}
