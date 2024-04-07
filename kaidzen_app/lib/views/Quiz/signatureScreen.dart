import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import 'light_dark_question.dart';

class SignatureScreen extends StatefulWidget {
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Personal Promise', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset('assets/sticky_note.png'),
            ),
          ),
          Positioned(
            bottom:
                77, // Adjust based on your needs for positioning closer to the bottom edge
            right:
                44, // Adjust based on your needs for positioning closer to the right edge
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTapDown: (TapDownDetails details) async {
                    _timer = Timer(Duration(seconds: 2), () async {
                      if (await Vibration.hasVibrator() ?? false) {
                        Vibration.vibrate(pattern: [500, 1000]);
                      }

                      // Navigate after holding down for 2 seconds
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ThemeSelectionPage()));
                    });

                    Vibration.vibrate(duration: 500);
                  },
                  child: Transform.scale(
                    scale: 2, // Scale up the FAB by 2 times
                    child: FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.fingerprint,
                          size: 40, color: Colors.white),
                      onPressed: () {}, // For visual feedback
                    ),
                  ),
                ),
                SizedBox(height: 33), // Space between the button and the text
                Text(
                  "Tap and hold\n the fingerprint to commit",
                  textAlign: TextAlign.right,
                  style: textTheme.bodyText2?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// class ThemeSelectionPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Next Screen")),
//       body: Center(child: Text("This is the next screen after signing.")),
//     );
//   }
// }
