import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/theme.dart';

class DoneIconButton extends StatelessWidget {
  const DoneIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.done, color: black),
        color: Theme.of(context).errorColor,
        onPressed: () {});
  }
}