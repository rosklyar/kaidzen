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

// void showDarkThemeToast(
//     String title, BuildContext context, task, String points, bool flagMoved) {
//   final themeProvider = Provider.of<DarkThemeProvider>(context, listen: false);
//   bool isDarkTheme = themeProvider.darkTheme;

//   String message = flagMoved
//       ? 'Moved to $title:\n +$points to your ${task.category.name} and cookies for Buddy'
//       : '+$points to your ${task.category.name} and cookies for Buddy';

//   Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.TOP,
//       timeInSecForIosWeb: 2,
//       backgroundColor: task.category
//           .getBackgroundColor(isDarkTheme), // Adjust colors based on theme
//       textColor: isDarkTheme
//           ? Colors.white
//           : Colors.black, // Adjust text color based on theme
//       fontSize: 16.0);
// }

Flushbar? currentFlushbar;

void showDarkThemeFlushbar(
    String title, BuildContext context, task, String points, bool flagMoved,
    {VoidCallback? onDismiss}) {
  final themeProvider = Provider.of<DarkThemeProvider>(context, listen: false);
  bool isDarkTheme = themeProvider.darkTheme;

  // Dismiss the current Flushbar if it's being shown
  currentFlushbar?.dismiss();
  currentFlushbar = null;

  if (isDarkTheme) {
    currentFlushbar = Flushbar(
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Color.lerp(
          task.category.getBackgroundColor(isDarkTheme), Colors.white, 0.1)!,

// Color.lerp(categoryColorSelectedDark, Colors.white, 0.55)!

      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      borderWidth: 1,
      titleText: flagMoved
          ? Text('Moved to $title',
              textAlign: TextAlign.left,
              style: Fonts_mode.largeBoldTextStyle(isDarkTheme,
                  fontSize: 14, fontWeight: FontWeight.bold))
          : null,
      messageText: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan(
                text: '+$points points ',
                style: Fonts_mode.largeBoldTextStyle(isDarkTheme,
                    fontSize: 14, fontWeight: FontWeight.bold)),
            TextSpan(
              text: 'to your ${task.category.name} and cookies for Buddy',
              style: Fonts_mode.largeBoldTextStyle(isDarkTheme, fontSize: 12),
            ),
          ],
        ),
      ),
      onStatusChanged: (status) {
        if (status == FlushbarStatus.DISMISSED) {
          currentFlushbar = null;
          if (onDismiss != null) {
            onDismiss(); // Call the completion callback
          }
        }
      },
    )..show(context);
  }
}
