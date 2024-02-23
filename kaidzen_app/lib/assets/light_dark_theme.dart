// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();

  DarkThemeProvider() {
    loadThemePreference();
  }

  Future<void> loadThemePreference() async {
    _darkTheme = await darkThemePreference.getTheme();
    // No need to call notifyListeners here as it's during initialization
  }

  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class dark_light_modes {
  static Color statusBarColor(bool isDarkTheme) {
    // Assuming isDarkTheme determines the theme mode
    return isDarkTheme
        ? Colors.white.withOpacity(0)
        : Colors.white.withOpacity(0); // Example colors, adjust as necessary
  }

  static Color statusIcon(bool isDarkTheme) {
    // Assuming isDarkTheme determines the theme mode
    return isDarkTheme
        ? Colors.white
        : Colors.black; // Example colors, adjust as necessary
  }

  static Color statusIconReversed(bool isDarkTheme) {
    // Assuming isDarkTheme determines the theme mode
    return isDarkTheme
        ? Colors.black
        : Colors.white; // Example colors, adjust as necessary
  }

  static Color cardShadowColor(bool isDarkTheme) {
    // Assuming isDarkTheme determines the theme mode
    return isDarkTheme
        ? const Color(0xFFE1E1E1).withOpacity(0)
        : const Color(0xFFE1E1E1)
            .withOpacity(0.8); // Example colors, adjust as necessary
  }

  static Color cardMoveButtonColor(bool isDarkTheme) {
    // Assuming isDarkTheme determines the theme mode
    return isDarkTheme ? Colors.grey[900]! : Colors.grey[100]!;
  }

  static dark_light(bool isDarkTheme, BuildContext context) {
    Color selectedToggleColor = isDarkTheme
        ? const Color.fromRGBO(86, 92, 95, 1)
        : const Color.fromRGBO(86, 92, 95, 1);
    Color unselectedToggleColor = isDarkTheme
        ? const Color.fromRGBO(231, 233, 234, 1)
        : const Color.fromRGBO(231, 233, 234, 1);
    Color whiteBackgroundColor = isDarkTheme
        ? const Color.fromRGBO(225, 218, 218, 1.0)
        : const Color.fromRGBO(225, 218, 218, 1.0);
    Color inputInactiveBorderColor = isDarkTheme
        ? const Color.fromRGBO(114, 118, 121, 1)
        : const Color.fromRGBO(114, 118, 121, 1);
    Color activeButtonColor = isDarkTheme
        ? const Color.fromRGBO(18, 17, 17, 1)
        : const Color.fromRGBO(18, 17, 17, 1);
    Color moreScreenBackColor = isDarkTheme
        ? const Color.fromRGBO(245, 243, 243, 1.0)
        : const Color.fromRGBO(245, 243, 243, 1.0);
    Color greyTextColor = isDarkTheme
        ? const Color.fromRGBO(114, 118, 121, 1.0)
        : const Color.fromRGBO(114, 118, 121, 1.0);
    Color statusBarColor = isDarkTheme
        ? Colors.white.withOpacity(0)
        : const Color.fromRGBO(114, 118, 121, 1.0);
  }
}

class Fonts_mode {
  static TextStyle smallTextStyle(bool isDarkTheme,
      {double fontSize = 8, double? letterSpacing, Color? color}) {
    // bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    // Adjust default color based on theme if not specified
    color = color ?? (isDarkTheme ? Colors.white : Colors.black);

    return GoogleFonts.montserrat(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle smallTextStyleLvl(bool isDarkTheme,
      {double fontSize = 8, Color? color}) {
    // bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    // Adjust default color based on theme if not specified
    color =
        color ?? (isDarkTheme ? Colors.white : Color.fromRGBO(72, 76, 79, 1));

    return GoogleFonts.montserrat(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle mediumTextStyle(bool isDarkTheme,
      {double fontSize = 12, Color? color}) {
    // bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    // Adjust default color based on theme if not specified
    color = color ?? (isDarkTheme ? Colors.white : Colors.black);

    return GoogleFonts.montserrat(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle medium14TextStyle(bool isDarkTheme,
      {double fontSize = 12,
      FontWeight fontWeight = FontWeight.w500,
      Color? color}) {
    // bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    // Adjust default color based on theme if not specified
    color = color ?? (isDarkTheme ? Colors.white : Colors.black);

    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle largeTextStyle(bool isDarkTheme,
      {double fontSize = 12,
      FontWeight fontWeight = FontWeight.w500,
      Color? color}) {
    // bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    // Adjust default color based on theme if not specified
    color = color ?? (isDarkTheme ? Colors.white : Colors.black);

    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle mediumBoldTextStyle(bool isDarkTheme,
      {double fontSize = 12,
      FontWeight fontWeight = FontWeight.bold,
      Color? color}) {
    // bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    // Adjust default color based on theme if not specified
    color = color ?? (isDarkTheme ? Colors.white : Colors.black);

    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle largeBoldTextStyle(bool isDarkTheme,
      {double fontSize = 16,
      FontWeight fontWeight = FontWeight.w500,
      Color? color}) {
    // bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    // Adjust default color based on theme if not specified
    color = color ?? (isDarkTheme ? Colors.white : Colors.black);

    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  //  static TextStyle largeBoldTextStyle(bool isDarkTheme,
  //     {double fontSize = 16,
  //     FontWeight fontWeight = FontWeight.w500,
  //     Color? color}) {
  //   // bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  //   // Adjust default color based on theme if not specified
  //   color = color ?? (isDarkTheme ? Colors.white : Colors.black);

  //   return GoogleFonts.montserrat(
  //     fontSize: fontSize,
  //     fontWeight: fontWeight,
  //     color: color,
  //   );
  // }
}


////
// ///
//   static TextStyle  = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontSize: 16,
//     color: Colors.black,
//   ));



//   static TextStyle announcementBoldTextStyle = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.bold,
//     color: Colors.black,
//   ));

//   static TextStyle mediumBoldTextStyle = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.bold,
//     color: Colors.black,
//   ));

//   static TextStyle largeTextStyleWhite = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontSize: 16,
//     color: Colors.white,
//   ));

//   static TextStyle largeTextStyle20 = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontSize: 20,
//     color: Colors.black,
//   ));

//   static TextStyle screenTytleTextStyle = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontSize: 24,
//     fontWeight: FontWeight.bold,
//     color: Colors.black,
//   ));

//   static TextStyle mediumWhiteTextStyle = GoogleFonts.montserrat(
//       textStyle: const TextStyle(fontSize: 12, color: Colors.white));

//   static TextStyle xLargeTextStyle = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//     color: Colors.black,
//   ));

//   static TextStyle xLargeWhiteTextStyle = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontWeight: FontWeight.bold,
//     fontSize: 18,
//     color: Colors.white,
//   ));

//   static TextStyle inputHintTextStyle = GoogleFonts.montserrat(
//       textStyle:
//           const TextStyle(fontSize: 16, color: dark_light_modes.dark_light(isDarkTheme).inputInactiveBorderColor));

//   static TextStyle graySubtitle = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//           color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500));

//   static TextStyle graySubtitle14 = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//           color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500));

//   static TextStyle graySubtitleMedium = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//           color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500));

//   static TextStyle flushbarText = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//           color: Color.fromARGB(255, 117, 117, 117),
//           fontSize: 12,
//           fontWeight: FontWeight.w500));

//   static TextStyle mindfulMomentTextStyle = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontSize: 14,
//     color: Colors.deepPurpleAccent,
//   ));

//   static TextStyle mindfulMomentTextStyleLarge = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontSize: 16,
//     color: Colors.deepPurpleAccent,
//   ));

//   static TextStyle mindfulMomentTextStyleXLarge = GoogleFonts.montserrat(
//       textStyle: const TextStyle(
//     fontSize: 18,
//     color: Colors.deepPurpleAccent,
//   ));
// }