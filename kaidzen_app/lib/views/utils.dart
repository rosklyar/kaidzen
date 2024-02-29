export 'utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../assets/light_dark_theme.dart';
import 'package:kaidzen_app/views/theamedAlertDIalog.dart';

import '../emotions/EmotionsState.dart';
import '../tutorial/TutorialState.dart';

class Utils {
  static void tryToLostFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static String resolveEmotionedAvatar(
      TutorialState tutorialState, EmotionsState emotionsState) {
    var completedStepsCount =
        tutorialState.getTutorialProgress().completedStepsCount();

    if (completedStepsCount < 3) {
      if (completedStepsCount == 0) {
        return "assets/emotions/egg01.png";
      } else if (completedStepsCount == 1) {
        return "assets/emotions/egg02.png";
      } else {
        return "assets/emotions/egg03.png";
      }
    }

    return emotionsState.getCurrentEmotion().assetPath;
  }
}

Future<int?> showNumberInputDialog(String title, BuildContext context,
    int currentValue, int maxValue, int minValue) async {
  TextEditingController controller =
      TextEditingController(text: '$currentValue');
  bool hasError = false; // to keep track of input error

  return showDialog<int>(
    context: context,
    builder: (context) {
      final themeProvider = Provider.of<DarkThemeProvider>(context);
      bool isDarkTheme = themeProvider.darkTheme;
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(title,
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface)), // Use onSurface for title color
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface), // Use onSurface for input text color
                  onChanged: (value) {
                    int? enteredNumber = int.tryParse(value);
                    // Check for error and update state accordingly
                    if (enteredNumber == null ||
                        enteredNumber > maxValue ||
                        enteredNumber < minValue) {
                      setState(() {
                        hasError = true;
                      });
                    } else {
                      setState(() {
                        hasError = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter number between $minValue and $maxValue',
                    hintStyle: TextStyle(
                        color: Theme.of(context)
                            .hintColor), // Use hintColor for hint text
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .surface), // Use surface for border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(
                                  0.5)), // Lighten onSurface for enabled border
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .errorColor), // Use errorColor for error border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .primary), // Use primary for focused border
                    ),
                    errorText: hasError
                        ? 'Value must be between $minValue and $maxValue'
                        : null, // display errorText if there's an error
                    errorStyle: TextStyle(
                        color: Theme.of(context)
                            .errorColor), // Use errorColor for error text
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel',
                    style: Fonts_mode.mindfulMomentTextStyleLarge(isDarkTheme,
                        fontWeight: FontWeight.w500)),
              ),
              TextButton(
                onPressed: () {
                  if (!hasError) {
                    int enteredNumber = int.parse(controller.text);
                    Navigator.pop(context, enteredNumber);
                  }
                },
                child: Text('OK',
                    style: Fonts_mode.mindfulMomentTextStyleLarge(isDarkTheme,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          );
        },
      );
    },
  );
}
