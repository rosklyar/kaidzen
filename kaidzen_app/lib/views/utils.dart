export 'utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Future<int?> showNumberInputDialog(String title,
    BuildContext context, int currentValue, int maxValue, int minValue) async {
  TextEditingController controller =
      TextEditingController(text: '$currentValue');
  bool hasError = false; // to keep track of input error

  return showDialog<int>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ThemedDialog(
              context,
              AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                        hintText:
                            'Enter number between $minValue and $maxValue',
                        border: OutlineInputBorder(),
                        errorText: hasError
                            ? 'Value must be between $minValue and $maxValue'
                            : null, // display errorText if there's an error
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Closes dialog without saving
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (!hasError) {
                        int enteredNumber = int.parse(controller.text);
                        Navigator.pop(context, enteredNumber);
                      }
                      // Else, the button will simply close the dialog without doing anything. You can also disable the OK button when there's an error if you prefer.
                    },
                    child: Text('OK'),
                  ),
                ],
              ));
        },
      );
    },
  );
}
