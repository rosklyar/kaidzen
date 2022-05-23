import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaizen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
        seconds: 8,
        navigateAfterSeconds: const MyHomePage(title: 'Kaizen App'),
        // ignore: prefer_const_constructors
        title: Text(
          'Choose your destiny',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue[200],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const kaidzens = ["Warrior", "Mage", "Rogue", "Hunter"];
  int _index = 0;
  Random _random = Random();

  void _showKaidzen() {
    setState(() {
      _index = _random.nextInt(kaidzens.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Kaidzen is: ${kaidzens[_index]}',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showKaidzen,
        tooltip: 'Show Kaidzen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
