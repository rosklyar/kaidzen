import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../../assets/light_dark_theme.dart';
import '../../main.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine the size of the canvas for the Yin-Yang symbol
    final screenWidth = MediaQuery.of(context).size.width;
    final symbolSize = screenWidth - 100; // Adjust the size as needed
    final symbolRadius = symbolSize / 2;
    final dotRadius =
        symbolRadius / 4; // Small dot radius (1/4th of the symbol's radius)
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: moreScreenBackColor, // Background color
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Stretch to the width of the screen
        children: [
          const SizedBox(height: 88),
          const Padding(
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
          // SizedBox(height: 32), // Space between text and symbol
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // CustomPaint(
                //   painter: YinYangPainter(),
                //   size: Size(symbolSize, symbolSize),
                // ),
                // Light Mode Button on the white dot
                Positioned(
                  top: symbolRadius * 3 - dotRadius * 2,
                  child: GestureDetector(
                    onLongPress: () {
                      HapticFeedback.heavyImpact();
                      setThemeMode(false, context);
                      themeProvider.darkTheme = false;
                    },
                    child: SizedBox(
                      width: 111, // Set your desired width
                      height: 111, // Set your desired height
                      child: FloatingActionButton(
                        heroTag: "light_mode_btn",
                        backgroundColor: Colors.white,
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                        child: const Icon(Icons.wb_sunny,
                            size: 36,
                            color: Colors.black), // Adjust icon size as needed
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: symbolRadius * 3 - dotRadius * 2,
                    child: GestureDetector(
                      onLongPress: () {
                        HapticFeedback.heavyImpact();
                        themeProvider.darkTheme = true;
                        setThemeMode(true, context);
                      },
                      child: SizedBox(
                        width: 111, // Set your desired width
                        height: 111, // Set your desired height
                        child: FloatingActionButton(
                          heroTag: "dark_mode_btn",
                          backgroundColor: Colors.black,
                          onPressed: () {
                            HapticFeedback.lightImpact();
                          },
                          child: const Icon(Icons.nightlight_round,
                              size: 36,
                              color:
                                  Colors.white), // Adjust icon size as needed
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void setThemeMode(bool isDarkMode, BuildContext context) async {
    // final preferences = await SharedPreferences.getInstance();
    // await preferences.setBool('themeMode', isDarkMode);
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    themeProvider.darkTheme = isDarkMode;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'hasChosenTheme', 1); // Indicate that the user has chosen a theme

    // Navigate to the ModeConfirmationScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (_) => ModeConfirmationScreen(isDarkMode: isDarkMode)),
    );
  }
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

  const ModeConfirmationScreen({super.key, required this.isDarkMode});

  @override
  _ModeConfirmationScreenState createState() => _ModeConfirmationScreenState();
}

class _ModeConfirmationScreenState extends State<ModeConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
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

