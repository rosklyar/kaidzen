import 'package:flutter/material.dart';

Theme ThemedDialog(BuildContext context, Widget? childWidget) {
  return Theme(
      data: ThemeData(
        colorScheme: const ColorScheme.light(
          secondary: Colors.deepPurple, // OK button background color
          onSecondary: Colors.black, // OK button text color
        ),
      ),
      child: childWidget!);
}
