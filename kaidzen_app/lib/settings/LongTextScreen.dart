import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kaidzen_app/settings/SettingsScreen.dart';

import '../assets/constants.dart';

class LongTextScreen extends StatelessWidget {
  final String title;
  final DateTime date;
  final String mainText;

  const LongTextScreen(
      {Key? key,
      required this.title,
      required this.date,
      required this.mainText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child:
                              SvgPicture.asset("assets/shevron-left-black.svg"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen()));
                          },
                        ),
                        GestureDetector(
                          child: SvgPicture.asset(
                              "assets/settings/close_black_icon.svg"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen()));
                          },
                        ),
                      ]),
                  flex: 2),
              Expanded(
                  child: Align(
                      child: Text(title, style: Fonts.screenTytleTextStyle),
                      alignment: Alignment.centerLeft),
                  flex: 2),
              Expanded(
                  child: Align(
                      child: Text(
                          "Last updated " + DateFormat.yMMMMd().format(date),
                          style: Fonts.mediumTextStyle),
                      alignment: Alignment.centerLeft),
                  flex: 1),
              const Expanded(child: SizedBox(), flex: 1),
              Expanded(
                  child: SingleChildScrollView(
                      child: Text(mainText, style: Fonts.largeTextStyle)),
                  flex: 25)
            ])));
  }
}
