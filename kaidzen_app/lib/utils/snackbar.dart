import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/tutorial/TutorialState.dart';
import 'package:provider/provider.dart';

import '../assets/light_dark_theme.dart';

showTopFlushbar(String text, BuildContext context, int durationInMs) {
  final flushBar = Flushbar(
    duration: Duration(milliseconds: durationInMs),
    messageText: Text(
      textAlign: TextAlign.center,
      text,
      style: Fonts.flushbarText,
    ),
    backgroundColor: const Color(0xFFE1DADA),
    isDismissible: false,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
  );
  flushBar.show(context);
}

showDefaultTopFlushbar(String text, BuildContext context) {
  showTopFlushbar(text, context, 1500);
}

showTutorialTopFlushbar(String text, BuildContext context) {
  if (!Provider.of<TutorialState>(context, listen: false).tutorialCompleted()) {
    // showTopFlushbar(text, context, 1500);
  }
}

Flushbar? currentFlushbar;

void showDarkThemeFlushbar(String title, BuildContext context, task) {
  final themeProvider = Provider.of<DarkThemeProvider>(context, listen: false);
  bool isDarkTheme = themeProvider.darkTheme;

  // Dismiss the current Flushbar if it's being shown
  currentFlushbar?.dismiss();
  currentFlushbar = null;

  String message_buff =
      '+20 points to your ' + task.category.name + ' and cookies for Buddy';

  if (isDarkTheme) {
    currentFlushbar = Flushbar(
      title: 'Moved to ' + title,
      message: message_buff,
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: task.category.getBackgroundColor(isDarkTheme),
      margin:
          EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Smaller margin
      padding:
          EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Smaller padding
      borderRadius: BorderRadius.circular(
          8), // Adjusted border radius for a less pronounced curve
      // borderColor: Colors.white,
      borderWidth: 1,
      // boxShadows: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.5),
      //     offset: Offset(0, 2),
      //     blurRadius: 3,
      //   ),
      // ],
      titleText: Text(
        'Moved to ' + title,
        textAlign: TextAlign.left,
        style: Fonts_mode.largeBoldTextStyle(isDarkTheme,
            fontSize: 12), // Smaller font size
      ),
      messageText: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: '+20 points ',
                style: Fonts_mode.largeBoldTextStyle(isDarkTheme,
                    fontSize: 14, fontWeight: FontWeight.bold)),
            TextSpan(
              text: 'to your ' + task.category.name + ' and cookies for Buddy',
              style: Fonts_mode.largeBoldTextStyle(isDarkTheme, fontSize: 12),
              // Assuming Fonts_mode.largeBoldTextStyle returns a TextStyle, adjust fontSize if needed.
            ),
          ],
        ),
      ),
      onStatusChanged: (status) {
        // When Flushbar is dismissed, clear the reference
        if (status == FlushbarStatus.DISMISSED) {
          currentFlushbar = null;
        }
      },
    )..show(context);
  }
}
