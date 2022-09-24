import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Status {
  static const String TODO = "Do";
  static const String DOING = "Doing";
  static const String DONE = "Done";
}

enum DevelopmentCategory {
  MIND(0, "Mind", "mind", Color.fromRGBO(69, 131, 151, 1.0), "assets/Mind",
      0xFFEBF8FA),
  HEALTH(1, "Health", "health", Color.fromRGBO(166, 187, 31, 1.0),
      "assets/Health", 0xFFF1FABC),
  ENERGY(2, "Energy", "energy", Color.fromRGBO(242, 202, 0, 1.0),
      "assets/Energy", 0xFFFCF5CB),
  RELATIONS(3, "Relations", "relations", Color.fromRGBO(234, 125, 98, 1.0),
      "assets/Relations", 0xFFFFEBE6),
  WEALTH(4, "Wealth", "wealth", Color.fromRGBO(138, 94, 176, 1.0),
      "assets/Wealth", 0xFFF4E8FE),
  NO_CATEGORY(-1, "No category", "life", Colors.white, "", 0xFFFFFF);

  const DevelopmentCategory(this.id, this.name, this.nameLowercase, this.color,
      this.backgroundLink, this.backgroundColor);
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

class Fonts {
  static TextStyle smallTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 8,
    color: Colors.black,
  ));

  static TextStyle mediumTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 12,
    color: Colors.black,
  ));

  static TextStyle largeTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 16,
    color: Colors.black,
  ));

  static TextStyle largeTextStyle20 = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 20,
    color: Colors.black,
  ));

  static TextStyle screenTytleTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ));

  static TextStyle mediumWhiteTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
          fontSize: 12, fontFamily: "Montserrat", color: Colors.white));
}
