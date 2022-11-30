import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';

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
