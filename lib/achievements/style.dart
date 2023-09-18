import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementsStyle {
  static TextStyle achievementsAppBarTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
          fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold));

  static TextStyle achievementsDescriptionTextStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(fontSize: 16, color: Colors.white));

  static TextStyle achievementsTitleTextStyle = GoogleFonts.lato(
      textStyle: const TextStyle(fontSize: 14, color: Colors.white));

  static TextStyle achievementsDetailsTextStyle = GoogleFonts.montserrat(
      textStyle:
          const TextStyle(fontSize: 16, color: Color.fromRGBO(86, 92, 95, 1)));
  static TextStyle achievementsDetailsAchievedTextStyle =
      GoogleFonts.montserrat(
          textStyle: const TextStyle(
              fontSize: 16, color: Color.fromRGBO(186, 169, 255, 1)));

  static Color achievementScreenBackgroundColor =
      const Color.fromRGBO(45, 45, 45, 1);

  static Color notCompletedAchievementScreenBackgroundColor =
      const Color.fromRGBO(189, 188, 199, 1);
  static Color completedAchievementScreenBackgroundColor =
      const Color.fromARGB(255, 185, 197, 205);

  static Color notCompletedAchievementScreenProgressColor =
      const Color.fromARGB(255, 151, 146, 132);

  static Color achievementDetailsActiveProgressColor =
      const Color.fromRGBO(195, 184, 239, 1);
  static Color achievementDetailsNotActiveProgressColor =
      const Color.fromRGBO(141, 140, 148, 1);

  static Color achievementDetailsBackgroundProgressColor =
      const Color.fromRGBO(108, 107, 107, 1);
}
