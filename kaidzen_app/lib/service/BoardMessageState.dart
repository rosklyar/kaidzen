import 'package:flutter/widgets.dart';

import '../assets/constants.dart';
import '../tutorial/TutorialState.dart';

class BoardMessageState extends ChangeNotifier {
  final TutorialState tutorialState;

  Map<ToggleBoard, String> _boardMessages = {
    ToggleBoard.TODO: "Create meaningful goals to\ndevelop your life spheres",
    ToggleBoard.DOING: "Keep here goals you want\nconcentrate on",
    ToggleBoard.DONE:
        "Feel satisfied by seeing here all\ngoals you will achieve",
  };

  BoardMessageState(this.tutorialState);

  void setShowBoardMessage(ToggleBoard board, String boardMessage) {
    _boardMessages[board] = boardMessage;
    notifyListeners();
  }

  String getBoardMessage(ToggleBoard board) {
    if (!tutorialState.tutorialCompleted() && board == ToggleBoard.TODO) {
      return "You will hatch the egg\nby creating meaningful goals";
    }
    return _boardMessages[board] ?? "";
  }
}
