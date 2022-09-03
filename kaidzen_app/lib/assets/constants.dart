import 'package:flutter/material.dart';

class Status {
  static const String TODO = "Do";
  static const String DOING = "Doing";
  static const String DONE = "Done";
}

enum DevelopmentCategory {
  MIND(0, "Mind", "mind", Color.fromRGBO(69, 131, 151, 1.0), "assets/Mind", 0xFFEBF8FA),
  HEALTH(1, "Health", "health", Color.fromRGBO(166, 187, 31, 1.0), "assets/Health", 0xFFF1FABC),
  ENERGY(2, "Energy", "energy", Color.fromRGBO(242, 202, 0, 1.0), "assets/Energy", 0xFFFCF5CB),
  RELATIONS(3, "Relations", "relations",Color.fromRGBO(234, 125, 98, 1.0), "assets/Relations", 0xFFFFEBE6),
  WEALTH(4, "Wealth", "wealth", Color.fromRGBO(138, 94, 176, 1.0), "assets/Wealth", 0xFFF4E8FE);

  const DevelopmentCategory(this.id, this.name, this.nameLowercase, this.color, this.backgroundLink, this.backgroundColor);
  final int id;
  final String name;
  final String nameLowercase;
  final Color color;
  final String backgroundLink;
  final int backgroundColor;
}

enum Difficulty {
  EASY(0, "A little", "Little"),
  MEDIUM(1, "Average", "Avarage"),
  HARD(2, "Hugely", "Huge");

  const Difficulty(this.id, this.name, this.noun);
  final int id;
  final String name;
  final String noun;
}

const selectedToggleColor = Colors.black;
const unselectedToggleColor = Colors.white;

const TextStyle smallTextStyle = TextStyle(
  fontSize: 8,
  fontFamily: "Montserrat",
  color: Colors.black,
);

const TextStyle mediumTextStyle = TextStyle(
  fontSize: 12,
  fontFamily: "Montserrat",
  color: Colors.black,
);

const TextStyle largeTextStyle = TextStyle(
  fontSize: 16,
  fontFamily: "Montserrat",
  color: Colors.black,
);

const TextStyle mediumWhiteTextStyle =
    TextStyle(fontSize: 12, fontFamily: "Montserrat", color: Colors.white);
