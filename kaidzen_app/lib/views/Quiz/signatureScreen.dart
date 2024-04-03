import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class SignatureScreen extends StatefulWidget {
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  Color _backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 30), // Adjusted for more content
              decoration: BoxDecoration(
                color: Colors.grey[200], // Sticker background color
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                // Added to allow scrolling
                child: Text(
                  "I, [Your Name], solemnly pledge to fully engage with the philosophy of continuous improvement espoused by the Kaizen App. Understanding the value of consistency, I commit to applying the app’s principles and practices diligently in my pursuit of personal growth.\n\nFor the next seven consecutive days, I will make my best effort to integrate these lessons into my life, aiming to realize my potential for self-improvement.\n\nIf, at the end of this period, I find that the changes in my life are not as I expected, I will accept that this journey through the Kaizen App may not be for me, and I will uninstall the app, parting ways without looking back. Conversely, if I observe positive impacts and benefits, I pledge to continue on this path, embracing the journey of becoming my best self over the course of the next year.",
                  style: TextStyle(
                      fontSize: 16.0), // Adjust the text size as needed
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onLongPressStart: (_) async {
                Vibration.vibrate(pattern: [500, 1000], repeat: 0);
              },
              onLongPressEnd: (_) async {
                Vibration.cancel();
                setState(() {
                  _backgroundColor = Colors.black;
                });
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue, // Button background color
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.fingerprint, // Fingerprint icon
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
