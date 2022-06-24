import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:kaidzen_app/views/boardSection.dart';
import 'package:kaidzen_app/assets/constants.dart';

class SwitchableBoard extends StatefulWidget {
  const SwitchableBoard({Key? key}) : super(key: key);

  @override
  SwitchableBoardState createState() => SwitchableBoardState();
}

class SwitchableBoardState extends State<SwitchableBoard> {
  final GlobalKey<SwitchableBoardContainerState> _switchableBoardKey =
      GlobalKey();
  final List<String> _boards = [
    Boards.DO,
    Boards.DOING,
    Boards.DONE,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleSwitch(
          initialLabelIndex: 0,
          totalSwitches: 3,
          labels: const [Boards.DO, Boards.DOING, Boards.DONE],
          onToggle: (index) {
            _switchableBoardKey.currentState?.changeBoard(_boards[index!]);
          },
        ),
        SwitchableBoardContainer(_switchableBoardKey)
      ],
    );
  }
}

class SwitchableBoardContainer extends StatefulWidget {
  const SwitchableBoardContainer(
      GlobalKey<SwitchableBoardContainerState> switchableBoardContainerKey,
      {Key? key})
      : super(key: key);

  @override
  SwitchableBoardContainerState createState() =>
      SwitchableBoardContainerState();
}

class SwitchableBoardContainerState extends State<SwitchableBoardContainer> {
  late String currentBoard = Boards.DO;
  final GlobalKey<BoardSectionState> _doBoardKey = GlobalKey();
  final GlobalKey<BoardSectionState> _doingBoardKey = GlobalKey();
  final GlobalKey<BoardSectionState> _doneBoardKey = GlobalKey();
  final Map<String, BoardSection> sections = {};

  @override
  void initState() {
    setState(() {
      sections.putIfAbsent(Boards.DO, () => BoardSection(_doBoardKey));
      sections.putIfAbsent(Boards.DOING, () => BoardSection(_doingBoardKey));
      sections.putIfAbsent(Boards.DONE, () => BoardSection(_doneBoardKey));
    });
    super.initState();
  }

  void changeBoard(String board) {
    setState(() {
      currentBoard = board;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: sections[currentBoard]!,
    );
  }
}
