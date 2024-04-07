import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:vibration/vibration.dart';

import '../../assets/light_dark_theme.dart';
import '../../main.dart';
import 'elevated_button.dart';

class ThemeSelectionPage extends StatelessWidget {
  void handleLongPress(
      BuildContext context, bool isDarkMode, Function setElevation) async {
    setElevation(true); // Raise the button by increasing elevation
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(
          pattern: [500, 1000],
          repeat: 3); // Vibrate for ~4 seconds with pauses
    }

    Future.delayed(Duration(seconds: 4), () {
      setThemeMode(isDarkMode, context);
      setElevation(false); // Reset elevation after action is complete
    });
  }

  void setThemeMode(bool isDarkMode, BuildContext context) async {
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    themeProvider.darkTheme = isDarkMode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('hasChosenTheme', 1);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (_) => ModeConfirmationScreen(isDarkMode: isDarkMode)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moreScreenBackColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 88),
          Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: Text(
              'Choose Experience \n and Hold It\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 20, // Adjusted position
                  // right:
                  //     0, // Add some right padding to ensure it's not sticking to the edge
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Aligns the text to the start
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dark experience same as light, plus:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "- Dark background",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "- Haptic responses",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "- Visual gamification",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      // Add your ElevatedIconButton here
                    ],
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height /
                      2, // Position for light mode button
                  child: ElevatedIconButton(
                    iconData: Icons.wb_sunny,
                    color: Colors.white,
                    iconColor: Colors.black,
                    isDarkMode: false,
                    onLongPressCompleted: (isDarkMode) =>
                        setThemeMode(isDarkMode, context),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height / 2 -
                      200, // Position for dark mode button
                  child: ElevatedIconButton(
                    iconData: Icons.nightlight_round,
                    color: Colors.black,
                    iconColor: Colors.white,
                    isDarkMode: true,
                    onLongPressCompleted: (isDarkMode) =>
                        setThemeMode(isDarkMode, context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildButton(BuildContext context, bool isDarkMode) {
  //   // Using a StatefulBuilder to manage elevation state locally
  //   return StatefulBuilder(
  //     builder: (BuildContext context, StateSetter setState) {
  //       double elevation = 10; // Default elevation

  //       return Positioned(
  //         bottom: isDarkMode
  //             ? MediaQuery.of(context).size.height / 2 - 200
  //             : MediaQuery.of(context).size.height / 2,
  //         child: GestureDetector(
  //           onLongPress: () =>
  //               handleLongPress(context, isDarkMode, (bool isPressed) {
  //             setState(() =>
  //                 elevation = isPressed ? 10 : 0); // Adjust elevation on press
  //           }),
  //           onLongPressUp: () {
  //             Vibration.cancel(); // Stop vibration when released
  //             setState(() => elevation = 0); // Reset elevation
  //           },
  //           child: Material(
  //             elevation: elevation,
  //             color: isDarkMode
  //                 ? Colors.black
  //                 : Colors.white, // Button color based on theme
  //             shape: CircleBorder(),
  //             child: Container(
  //               width: 111,
  //               height: 111,
  //               alignment: Alignment.center,
  //               child: Icon(
  //                 isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
  //                 size: 36,
  //                 color: isDarkMode ? Colors.white : Colors.black,
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

class YinYangPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final halfRadius = radius / 2;

    // Black half
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi / 2,
      math.pi,
      true,
      paint,
    );

    // White half
    paint.color = Colors.white;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi,
      true,
      paint,
    );

    // Small black semicircle
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(center.dx, center.dy + halfRadius),
      halfRadius,
      paint,
    );

    // Small white semicircle
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(center.dx, center.dy - halfRadius),
      halfRadius,
      paint,
    );

    // Small black dot
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(center.dx, center.dy - halfRadius),
      radius / 8,
      paint,
    );

    // Small white dot
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(center.dx, center.dy + halfRadius),
      radius / 8,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ModeConfirmationScreen extends StatefulWidget {
  final bool isDarkMode;

  ModeConfirmationScreen({required this.isDarkMode});

  @override
  _ModeConfirmationScreenState createState() => _ModeConfirmationScreenState();
}

class _ModeConfirmationScreenState extends State<ModeConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Text(
          widget.isDarkMode ? 'Dark Experience' : 'Light Experience',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Ensure HomeScreen is defined in your application.
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Your HomeScreen layout
//     return Scaffold(
//       // Define your HomeScreen layout here
//     );
//   }
// }

