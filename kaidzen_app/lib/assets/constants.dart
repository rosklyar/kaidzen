import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Status {
  static const String TODO = "Do";
  static const String DOING = "Doing";
  static const String DONE = "Done";
}

enum ToggleBoard {
  TODO(0, Status.TODO),
  DOING(1, Status.DOING),
  DONE(2, Status.DONE);

  const ToggleBoard(this.id, this.name);

  final int id;
  final String name;
}

const List<ToggleBoard> toggleBoards = [
  ToggleBoard.TODO,
  ToggleBoard.DOING,
  ToggleBoard.DONE,
];

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
  NO_CATEGORY(-1, "No category", "life", Colors.white, "", 0xFFFFFFFF);

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
  MEDIUM(1, "Average", "Average"),
  HARD(2, "Hugely", "Huge");

  const Difficulty(this.id, this.name, this.noun);
  final int id;
  final String name;
  final String noun;
}

Color cardShadowColor = const Color(0xFFE1E1E1).withOpacity(0.8);
const selectedToggleColor = Color.fromRGBO(86, 92, 95, 1);
const unselectedToggleColor = Color.fromRGBO(231, 233, 234, 1);
const whiteBackgroundColor = Color.fromRGBO(225, 218, 218, 1.0);
const inputInactiveBorderColor = Color.fromRGBO(114, 118, 121, 1);
const activeButtonColor = Color.fromRGBO(18, 17, 17, 1);
const moreScreenBackColor = Color.fromRGBO(245, 243, 243, 1.0);
const greyTextColor = Color.fromRGBO(114, 118, 121, 1.0);

class Fonts {
  static TextStyle smallTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 8,
    color: Colors.black,
  ));

  static TextStyle smallTextStyleLvl = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 8,
    color: Color.fromRGBO(72, 76, 79, 1),
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

  static TextStyle largeBoldTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  ));

  static TextStyle announcementBoldTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ));

  static TextStyle mediumBoldTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ));

  static TextStyle largeTextStyleWhite = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 16,
    color: Colors.white,
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
      textStyle: const TextStyle(fontSize: 12, color: Colors.white));

  static TextStyle xLargeTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  ));

  static TextStyle xLargeWhiteTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.white,
  ));

  static TextStyle inputHintTextStyle = GoogleFonts.montserrat(
      textStyle:
          const TextStyle(fontSize: 16, color: inputInactiveBorderColor));

  static TextStyle graySubtitle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
          color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500));

  static TextStyle graySubtitleMedium = GoogleFonts.montserrat(
      textStyle: const TextStyle(
          color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500));

  static TextStyle flushbarText = GoogleFonts.montserrat(
      textStyle: const TextStyle(
          color: Color.fromARGB(255, 117, 117, 117),
          fontSize: 12,
          fontWeight: FontWeight.w500));

  static TextStyle mindfulMomentTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
    fontSize: 14,
    color: Colors.deepPurpleAccent,
  ));
}

enum Emotion {
  VERY_SAD(0, "assets/emotions/sad03.png",
      "*Don't want to talk with you right now*"),
  SAD(1, "assets/emotions/sad02.png", "You could do better"),
  A_BIT_SAD(2, "assets/emotions/sad01.png", "You could do even better"),
  REGULAR(3, "assets/emotions/regular.png", "Consistency is the key!"),
  A_BIT_HAPPY(4, "assets/emotions/happy01.png",
      "You are moving in the right direction"),
  HAPPY(5, "assets/emotions/happy02.png", "Doing great!"),
  VERY_HAPPY(6, "assets/emotions/happy03.png", "You are amazing!");

  const Emotion(this.id, this.assetPath, this.text);

  final int id;
  final String assetPath;
  final String text;
}

const cardElavation = 8.0;
const maxInputCharCount = 150;

enum RepeatType {
  DAILY(0, "Daily", 1),
  WEEKLY(1, "Weekly", 7),
  BIWEEKLY(2, "Every two weeks", 14);

  const RepeatType(this.id, this.name, this.daysShift);

  final int id;
  final String name;
  final int daysShift;
}

enum AppNotifications {
  REMINDER(0, "Mindful moments reminder");

  const AppNotifications(this.id, this.name);

  final int id;
  final String name;
}
