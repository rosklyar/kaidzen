import 'package:flutter/material.dart';

class Status {
  static const String TODO = "Do";
  static const String DOING = "Doing";
  static const String DONE = "Done";
}

enum DevelopmentCategory {
  MIND(0, "Mind", "mind", Color.fromRGBO(69, 131, 151, 1.0)),
  HEALTH(1, "Health", "health", Color.fromRGBO(166, 187, 31, 1.0)),
  ENERGY(2, "Energy", "energy", Color.fromRGBO(242, 202, 0, 1.0)),
  RELATIONS(3, "Relations", "relations", Color.fromRGBO(234, 125, 98, 1.0)),
  WEALTH(4, "Wealth", "wealth", Color.fromRGBO(138, 94, 176, 1.0)),
  NO_CATEGORY(-1, "No category", "", Colors.white);

  const DevelopmentCategory(this.id, this.name, this.nameLowercase, this.color, this.backgroundLink, this.backgroundColor);
  final int id;
  final String name;
  final String nameLowercase;
  final Color color;
  final String backgroundLink;
  final int backgroundColor;
}

const List<DevelopmentCategory> activeCategories = [
  DevelopmentCategory.MIND,
  DevelopmentCategory.HEALTH,
  DevelopmentCategory.ENERGY,
  DevelopmentCategory.RELATIONS,
  DevelopmentCategory.WEALTH
];

enum Difficulty {
  EASY(0, "A little", "Little"),
  MEDIUM(1, "Average", "Avarage"),
  HARD(2, "Hugely", "Huge");

  const Difficulty(this.id, this.name, this.noun);
  final int id;
  final String name;
  final String noun;
}

const selectedToggleColor = Color.fromRGBO(86, 92, 95, 1);
const unselectedToggleColor = Color.fromRGBO(231, 233, 234, 1);
const inputInactiveBorderColor = Color.fromRGBO(114, 118, 121, 1);
const inputHintTextStyle = TextStyle(
    fontSize: 16, color: inputInactiveBorderColor, fontFamily: 'Montserrat');
const activeButtonColor = Color.fromRGBO(18, 17, 17, 1);

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

const TextStyle largeTextStyle20 = TextStyle(
  fontSize: 20,
  fontFamily: "Montserrat",
  color: Colors.black,
);

const TextStyle screenTytleTextStyle = TextStyle(
  fontSize: 24,
  fontFamily: "Montserrat",
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle mediumWhiteTextStyle =
    TextStyle(fontSize: 12, fontFamily: "Montserrat", color: Colors.white);
