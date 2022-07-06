import 'dart:developer';

import 'package:flutter/material.dart';

class ProfilePanel extends StatefulWidget {
  const ProfilePanel({Key? key, required this.name, required this.level})
      : super(key: key);

  final String name;
  final int level;

  @override
  ProfilePanelState createState() => ProfilePanelState(this.name, this.level);
}

class ProfilePanelState extends State<ProfilePanel> {
  ProfilePanelState(this.name, this.level);
  String name;
  int level;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Column(children: [
            Icon(
              Icons.person,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              '$level LEVEL',
              style: TextStyle(fontSize: 20.0),
            ),
          ]),
          padding: const EdgeInsets.all(10.0),
        ),
        Center(child: Text(name, style: TextStyle(fontSize: 20.0)))
      ],
    );
  }
}
