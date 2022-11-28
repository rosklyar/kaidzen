import 'package:flutter/material.dart';

showSnackbar(String text, BuildContext context) {
  final snackBar = SnackBar(
    duration: Duration(milliseconds: 2000),
    content: Text(text),
    backgroundColor: const Color(0xFF751E84),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
