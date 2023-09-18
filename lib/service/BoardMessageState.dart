import 'package:flutter/widgets.dart';
import 'package:kaidzen_app/service/HabitState.dart';
import 'package:kaidzen_app/service/TasksState.dart';

import '../assets/constants.dart';
import '../tutorial/TutorialState.dart';

class BoardMessageState extends ChangeNotifier {
  final TutorialState tutorialState;
  final TasksState tasksState;
  final HabitState habitState;

  Map<ToggleBoard, String> _boardMessages = {
    ToggleBoard.TODO: "Create meaningful goals to\ndevelop your life spheres",
    ToggleBoard.DOING: "Keep here the goals \nyou want to concentrate on",
    ToggleBoard.DONE: "Experience fulfillment and satisfaction\nas you visualize your accomplishments",
  };

  BoardMessageState(this.tutorialState, this.tasksState, this.habitState);

  void setShowBoardMessage(ToggleBoard board, String boardMessage) {
    _boardMessages[board] = boardMessage;
    notifyListeners();
  }

  String getBoardMessage(ToggleBoard board) {
    var message =
        !tutorialState.tutorialCompleted() && board == ToggleBoard.TODO
            ? "You will hatch the egg\nby creating meaningful goals"
            : _boardMessages[board] ?? "";
;
    return tasksState.getCountByStatus(board.name) > 0 || habitState.getCountByStatus(board.name) > 0 ? "" : message;
  }
}
