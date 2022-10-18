import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaidzen_app/settings/SettingsScreen.dart';

import '../assets/constants.dart';
import 'EmailSender.dart';

class MoreFeedbackScreen extends StatelessWidget {
  const MoreFeedbackScreen({Key? key}) : super(key: key);

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
                  child: SvgPicture.asset("assets/emotions/communication.svg"),
                  flex: 5),
              Expanded(
                  child: Text("Your thoughts matter",
                      style: Fonts.screenTytleTextStyle),
                  flex: 2),
              Expanded(
                  child: Text(
                      "Thank you for helping the app to become\nbetter. Feel free to contact us with any\nthoughts and ideas!",
                      style: Fonts.largeTextStyle,
                      textAlign: TextAlign.center),
                  flex: 3),
              const Expanded(child: SizedBox(), flex: 5),
              Expanded(
                  child: InkWell(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child:
                                  SvgPicture.asset("assets/settings/mail.svg"),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EmailSender()));
                              },
                            ),
                            Text('Send another message',
                                style: Fonts.largeTextStyle.copyWith(
                                    decoration: TextDecoration.underline))
                          ]),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmailSender()));
                      }),
                  flex: 2),
            ])));
  }
}
