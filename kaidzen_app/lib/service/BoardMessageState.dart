import 'package:flutter/widgets.dart';

import '../assets/constants.dart';

class BoardMessageState extends ChangeNotifier {
  Map<ToggleBoard, String> _boardMessages = {
    ToggleBoard.TODO: "Create meaningful goals to develop your life spheres",
    ToggleBoard.DOING: "Keep here goals you want concentrate on",
    ToggleBoard.DONE:
        "Feel satisfied by seeing here all goals you will achieve",
  };

  void setShowBoardMessage(ToggleBoard board, String boardMessage) {
    _boardMessages[board] = boardMessage;
    notifyListeners();
  }

  String getBoardMessage(ToggleBoard board) {
    return _boardMessages[board] ?? "";
  }
}
