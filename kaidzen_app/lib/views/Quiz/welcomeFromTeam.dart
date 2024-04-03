import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaidzen_app/assets/light_dark_theme.dart';
import 'package:kaidzen_app/views/Quiz/signatureScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Welcome from Fun Work Studio'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.grey[900]),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PortraitWidget(assetName: 'assets/001.png'),
                PortraitWidget(assetName: 'assets/004.png'),
                PortraitWidget(assetName: 'assets/005.png'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PortraitWidget(assetName: 'assets/003.png'),
                PortraitWidget(assetName: 'assets/002.png'),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  "Dear Customer,\n\nThank you for choosing our App. \n\nYou've already taken a pivotal step towards embracing change\nand the power of small, consistent steps towards a better you.\n\nThank you for being here.\nLet's make it remarkable.\n\nWith warmest regards,\nFun Team",
                  textAlign: TextAlign.justify,
                  style: Fonts_mode.medium14TextStyle(true, fontSize: 18),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 8.0, bottom: 32.0), // Adjusted padding
            child: ElevatedButton(
              onPressed: () {
                // Handle the button action
                HapticFeedback.heavyImpact();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => SignatureScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[
                    700], // Use any color from the MaterialColor palette or a custom color
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10), // Custom padding
              ),
              child: Row(
                mainAxisSize: MainAxisSize
                    .min, // Minimize the row size to fit the content
                children: <Widget>[
                  Text(
                    'Proceed',
                    style: Fonts_mode.medium14TextStyle(true, fontSize: 18),
                  ), // Button text
                  SizedBox(width: 8), // Space between text and icon
                  Container(
                    width: 32, // Set the width of the square
                    height: 32, // Set the height of the square
                    padding: EdgeInsets.all(
                        2), // Adjust padding to make the icon smaller within the square
                    decoration: BoxDecoration(
                      color: dark_light_modes.cardMoveButtonColor(
                          true), // Background color of the square
                      shape: BoxShape.rectangle, // Makes the container a square
                      borderRadius: BorderRadius.circular(4),
                      // Rounded corners of the square
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 24, // Adjust the icon size inside the square
                      color: dark_light_modes.statusIcon(true), // Icon color
                    ),
                  ), // Icon on the right
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PortraitWidget extends StatelessWidget {
  final String assetName;

  PortraitWidget({required this.assetName});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 44,
      backgroundImage: AssetImage(assetName),
    );
  }
}
