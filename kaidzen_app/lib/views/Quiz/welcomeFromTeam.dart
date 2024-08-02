import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaidzen_app/assets/light_dark_theme.dart';
import 'package:kaidzen_app/views/Quiz/signatureScreen.dart';

import '../../service/AnalyticsService.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[900], // Set to the dark mode background color
      body: SafeArea(
        // This will avoid overlapping the status bar
        child: Column(
          children: <Widget>[
            // Adjusted flex values to allocate more space for the container
            Expanded(
              flex:
                  3, // Increases the flex factor of the container, making it larger
              child: Container(
                decoration: BoxDecoration(
                  color: Colors
                      .grey[850], // Darker grey background for the container
                  border: Border.all(
                    color: Colors.white.withOpacity(
                        0.2), // White border with some transparency
                    width: 2, // Border thickness
                  ),
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                margin:
                    const EdgeInsets.all(16.0), // Margin around the container
                padding:
                    const EdgeInsets.all(16.0), // Padding inside the container
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the children vertically
                  children: [
                    // First row of portraits aligned to the end
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        PortraitWidget(assetName: 'assets/001.png'),
                        PortraitWidget(assetName: 'assets/004.png'),
                        PortraitWidget(assetName: 'assets/005.png'),
                      ],
                    ),
                    const SizedBox(
                        height: 16), // Provides spacing between the rows
                    // Second row of portraits aligned to the end with text at the start
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Welcome\nfrom\nthe team',
                            style: Fonts_mode.largeTextStyleWhite(true,
                                fontSize: 22)),
                        const PortraitWidget(assetName: 'assets/003.png'),
                        const PortraitWidget(assetName: 'assets/002.png'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\nHello Friend",
                      style: Fonts_mode.largeTextStyleWhite(true,
                          fontSize: 30), // Style it as a heading
                    ),
                    const SizedBox(
                        height:
                            16), // Space between "Hello Friend" and the rest of the text
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          "You've already taken a pivotal step\ntowards embracing change and the power \nof small, consistent steps towards a\nbetter you.\n\nThank you for being here.\nLet's make it remarkable.",
                          textAlign: TextAlign.justify,
                          style: Fonts_mode.medium14TextStyleWelcome(true,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 32.0,
                  left: 16,
                  right: 16), // Adjusted padding
              child: ElevatedButton(
                onPressed: () async {
                  // Handle the button action
                  HapticFeedback.heavyImpact();
                  await FirebaseAnalytics.instance.logEvent(
                      name: AnalyticsEventType.welcome_from_team_screen.name);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SignatureScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // Custom padding
                ),
                child: Row(
                  children: <Widget>[
                    // White circle fulfilled on the left
                    Container(
                      width: 14, // Adjust the size to your preference
                      height: 14, // Adjust the size to your preference
                      decoration: const BoxDecoration(
                        color: Colors.white, // White color for the circle
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                        width: 16), // Space between the circle and the text
                    // Column for the two rows of text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Start my Journey',
                            style: Fonts_mode.medium14TextStyle(true,
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ), // First row of text
                          Text(
                            'For myself',
                            style: Fonts_mode.medium14TextStyle(true,
                                fontSize: 14),
                          ), // Second row of text
                        ],
                      ),
                    ),
                    // Arrow icon centered and aligned to the right
                    Container(
                      color: Colors.grey[900],
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 32, // Adjust the icon size inside the square
                        color: dark_light_modes.statusIcon(true), // Icon color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PortraitWidget extends StatelessWidget {
  final String assetName;

  const PortraitWidget({super.key, required this.assetName});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 44,
      backgroundImage: AssetImage(assetName),
    );
  }
}
