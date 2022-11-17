import 'package:flutter/material.dart';

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
